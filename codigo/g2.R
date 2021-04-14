library(data.table)
library(lubridate)
library(UpSetR)

df <- fread("./datos/a_adip_adicionada.csv")

df$fec_defuncion <- ymd(df$fec_defuncion)
# Fecha inicio: Domingo de inicio de registros de la DGE
# Fecha final: Sábado de la última semana disponible en la base de la ADIP
df <- df[fec_defuncion >= "2020-02-23" & fec_defuncion <= "2021-02-20", ] 

enfermedades <- c("Covid-19", "Insuficiencia respiratoria", "Neumonía atípica", "Neumonía viral")
setnames(df, old = c("menciona_covid", "menciona_insufresp", "menciona_neuatip", "menciona_neuviral"), new = enfermedades)

upset(df, 
      sets = enfermedades, 
      order.by = "freq", 
      point.size = 3.5, 
      line.size = 1.0, 
      mainbar.y.label = "Tamaño de la intersección", sets.x.label = "Total de actas por causa", 
      text.scale = c(1.25, 1.5, 1.25, 1.5, 1.5, 1.5))