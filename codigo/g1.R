library(data.table)
library(lubridate)
library(ggplot2)

df <- fread("./datos/a_adip_adicionada.csv")

df$fec_defuncion <- ymd(df$fec_defuncion)
# Fecha inicio: Domingo de inicio de registros de la DGE
# Fecha final: Sábado de la última semana disponible en la base de la ADIP
df <- df[fec_defuncion >= "2020-02-23" & fec_defuncion <= "2021-02-20", ] 

# Defunciones por causa
causas <- c("menciona_covid", "menciona_insufresp", "menciona_neuatip", "menciona_neuviral", "menciona_ninguna")
defunciones_por_causa_ <- as.numeric(lapply(df[, causas, with = FALSE], sum))
causas_factor <- factor(causas, 
                        levels = causas,  
                        labels = c("Covid-19", 
                                   "Insuficiencia respiratoria", 
                                   "Neumonía atípica", 
                                   "Neumonía viral",
                                   "Otra"))
defunciones_por_causa <- data.table(causa = causas_factor, total_defunciones = as.numeric(defunciones_por_causa_))

ggplot(defunciones_por_causa, 
       aes(x = causa, y = total_defunciones, fill = causa, label =  scales::comma(total_defunciones))) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3", "#cccccc")) +
  geom_text(color = "black", size = 4, position = position_stack(vjust = 0.5)) +
  labs(title = "Hay 63,059 actas de defunción de la CDMX que mencionan covid-19 como causa de muerte.",
       subtitle = "Total de actas de defunción que mencionan*: covid-19, insuficiencia respiratoria, neumonía atípica y neumonía viral\n23 de febrero del 2020 - 20 de febrero del 2021, CDMX",
       caption = "Fuente: Elaboración propia con datos de la Agencia Digital de Innovación Pública.\n*Contienen términos (COV o CORONAVIRUS), (NEU y ATIP), (NEU y VIRAL) o (INSUF y RESP) respectivamente.\nUn acta de defunción puede mencionar una o varias causas de muerte.",
       x = "Causa mencionada",
       y = "Total de actas") +
  guides(fill = FALSE) +
  theme_light() 