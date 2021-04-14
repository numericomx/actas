library(data.table)
library(ggplot2)

df <- fread("./datos/predicciones_modelo.csv")

breakpoint <- 4190.265

df$semana <- ymd(df$semana)

# Crear columna con concatenación de mes y año
df[, mes_anio := paste(lubridate::month(semana, label = T, abbr = F), 
                       year(semana), 
                       sep = " ")]

# Codificar columna mes_anio a factor  
mes_anio_ordenado <- c("marzo 2020", "abril 2020", "mayo 2020", "junio 2020", "julio 2020", "agosto 2020", "septiembre 2020",
                       "octubre 2020", "noviembre 2020", "diciembre 2020", "enero 2021", "febrero 2021")
df$mes_anio <- factor(df$mes_anio, 
                      levels = mes_anio_ordenado, 
                      labels = mes_anio_ordenado)

ggplot(df) +
  geom_vline(xintercept = breakpoint, color = "#555555", linetype = "dashed", size = 0.5) +
  geom_line(data = df, aes(x = hospitalizados_totales_cdmx, y = total_defunciones_domicilio_predicted), size = 0.5) + 
  geom_point(aes(x = hospitalizados_totales_cdmx, y = total_defunciones_domicilio, color = mes_anio), size = 2) + 
  scale_x_continuous(labels = scales::comma) +
  # scale_color_brewer(palette = "Paired") +
  labs(title = "Para casos de covid-19, a partir de casi 4,000 hospitalizaciones diarias promedio,\nlas defunciones en el domicilio del difunto se aceleran.",
       subtitle = "Cada punto representa un semana.\n29 de marzo del 2020 - 20 de febrero del 2021, CDMX",
       caption = "La línea negra representa el ajuste del modelo de regresión segmentada.
       La línea gris rayada representa el punto de cambio de tendencia.
       *Clasificación por la Agencia Digital de Innovación Pública.
       Fuente: Elaboración propia con datos de la Agencia Digital de Innovación Pública y de la Secretaria de Salud.",
       x = "Hospitalizaciones por covid-19 diarias promedio",
       y = "Total de defunciones en el domicilio del difunto por covid-19*") +
  guides(fill = FALSE) +
  theme_minimal() +
  theme(legend.title = element_blank(), 
        legend.position = "bottom")
