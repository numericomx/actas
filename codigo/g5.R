library(data.table)
library(lubridate)
Sys.getlocale("LC_TIME")
library(ggplot2)

df <- fread("./datos/a_adip_adicionada.csv")

df$fec_defuncion <- ymd(df$fec_defuncion)
df <- df[fec_defuncion >= "2020-03-01", ]

df <- df[causa == "Covid-19 Confirmado o Sospecha", ]

# Crear nueva columna con cadena compuesta de mes y año
df[, mes_anio := paste(month(fec_defuncion, label = T, abbr = F), 
                       year(fec_defuncion), 
                       sep = " ")]

# Defunciones por mes_anio y lugar de muerte
defunciones_mensuales_lugar <- df[, .(total_defunciones = .N), by = .(mes_anio, lugarmuerte)]
defunciones_mensuales <- df[, .(total_defunciones_mes_anio = .N), by = .(mes_anio)]

# Calcular porcentaje por por lugar de muerte de cada mes_anio
defunciones_mensuales_lugar <- merge(defunciones_mensuales_lugar, defunciones_mensuales, by = "mes_anio", all.x = T)
defunciones_mensuales_lugar[, pct_defunciones := total_defunciones/total_defunciones_mes_anio*100]

defunciones_mensuales_lugar[, label := paste0(prettyNum(total_defunciones, ",", scientific = F), 
                                              "\n(", round(pct_defunciones, 0), "%)")]

defunciones_mensuales_lugar <- defunciones_mensuales_lugar[!is.na(lugarmuerte), ]

# Codificar columna mes_anio a factor  
mes_anio_ordenado <- c("enero 2020", "febrero 2020", "marzo 2020", "abril 2020", "mayo 2020", "junio 2020", 
                       "julio 2020", "agosto 2020", "septiembre 2020", "octubre 2020", "noviembre 2020", "diciembre 2020",
                       "enero 2021", "febrero 2021")
defunciones_mensuales_lugar$mes_anio <- factor(defunciones_mensuales_lugar$mes_anio, 
                                            levels = mes_anio_ordenado, 
                                            labels = mes_anio_ordenado)

# Codificar columna mes_anio a factor
defunciones_mensuales_lugar$lugarmuerte <- factor(defunciones_mensuales_lugar$lugarmuerte, 
                                               levels = c("Domicilio", "Hospital"), 
                                               labels = c("Domicilio del difunto", "Hospital"))

ggplot(defunciones_mensuales_lugar) +
  aes(x = mes_anio, y = total_defunciones, fill = lugarmuerte, label = label) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#f8766dff", "#00bfc4ff")) +
  geom_text(color = "black",  size = 3, position = position_stack(vjust = .55)) +
  labs(title = "El 13% de las muertes por covid-19 han ocurrido en el domicilio del difunto",
       subtitle = "Total de defunciones mensuales por covid19* que ocurrieron en un hospital o en el domicilio del difunto.\n1º de marzo del 2020 - 26 de febrero del 2021, CDMX",
       caption = "La suma de los porcentajes mensuales no es 100% en todos los casos dado que el lugar de defunción en algunas actas fue distinto a las categorías señaladas.
       *Clasificación por la Agencia Digital de Innovación Pública.
       Fuente: Elaboración propia con datos de la Agencia Digital de Innovación Pública.",
       x = "",
       y = "Total de defunciones") +
       theme_light() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_blank(),
        legend.position = "bottom")