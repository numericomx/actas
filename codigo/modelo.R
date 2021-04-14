library(data.table)
library(segmented)

defunciones <- fread("./datos/a_adip_adicionada.csv")

# Defunciones semanales por lugar 
defunciones_semanales <- defunciones[causa == "Covid-19 Confirmado o Sospecha",
                                     .(total_defunciones_domicilio = sum(lugarmuerte == "Domicilio", na.rm = T),
                                       total_defunciones_hospitales = sum(lugarmuerte == "Hospital", na.rm=T)),
                                     by = semana]

# Defunciones semanales por lugar en formato largo
defunciones_semanales_largo <- melt(defunciones_semanales, 
                                    id.vars = "semana", 
                                    variable.name = "lugar", 
                                    value.name = "total_defunciones")

hospitalizaciones <- fread("./datos/h_sedesa.csv")
hospitalizaciones$fecha <- ymd(hospitalizaciones$fecha)
hospitalizaciones[, semana := floor_date(fecha, unit = "week")]

hospitalizaciones_semanales <- hospitalizaciones[, .(hospitalizados_totales_cdmx = mean(hospitalizados_totales_cdmx, na.rm = T), 
                                                     camas_intubados_cdmx = mean(camas_intubados_cdmx, na.rm = T),
                                                     camas_generales_cdmx = mean(camas_generales_cdmx, na.rm = T)), 
                                                 by = semana]

df <- merge(defunciones_semanales, hospitalizaciones_semanales, by = "semana")

# Fecha inicio: Domingo de inicio de registros de la DGE
# Fecha final: Sábado de la última semana disponible en la base de la ADIP
df <- df[semana >= "2020-03-29" & semana <= "2021-02-20"]

df_largo <- melt(df, 
                     id.vars = "semana", 
                     variable.name = "serie", 
                     value.name = "total_defunciones")

ggplot(df) +
  aes(x = hospitalizados_totales_cdmx, y = total_defunciones_domicilio)+
  geom_point()

# Modelo lineal inicial
lm.fit <- lm(total_defunciones_domicilio~hospitalizados_totales_cdmx, df)

# Modelo lineal segmentado
slm.fit <- segmented(lm.fit, seg.Z = ~hospitalizados_totales_cdmx, psi = 3000)

summary(slm.fit)

plot(df[, hospitalizados_totales_cdmx], df[, total_defunciones_domicilio])
plot(slm.fit, add = TRUE, link = FALSE, lwd = 2, col = 2:3, lty = c(1,3))
lines(slm.fit,col = 2, pch = 19, bottom = FALSE, lwd = 2) # Intervalo de confianza

slm.fit$psi[1, "Est."] # Punto de quiebre: 4190.265

df[, total_defunciones_domicilio_predicted := slm.fit$fitted.values]

write.csv(df, "./datos/predicciones_modelo.csv", row.names = F)