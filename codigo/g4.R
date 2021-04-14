library(data.table)
library(lubridate)
library(ggplot2)

# ADIP
df_adip <- fread("./datos/a_adip_adicionada.csv")
df_adip$fec_defuncion <- ymd(df_adip$fec_defuncion)
df_adip <- df_adip[fec_defuncion >= "2020-03-23" & fec_defuncion <="2020-09-26", 
                   .(covid_adip = sum(causa == "Covid-19 Confirmado o Sospecha", na.rm = TRUE),
                     covid_nuestro = sum(menciona_covid == 1, na.rm = T),
                     covid_o_neumonia_nuestro = sum(menciona_covid == 1 | menciona_neuatip == 1 | menciona_neuviral == 1, na.rm = T)), 
                   by = fec_defuncion]
n_covid_adip <- sum(df_adip$covid_adip, na.rm = T)
n_covid_nuestro <- sum(df_adip$covid_nuestro, na.rm = T)
n_covid_o_neumonia_nuestro <- sum(df_adip$covid_o_neumonia_nuestro, na.rm = T)

# DGE
df_dge <- fread("./datos/d_dge.csv")
df_dge <- df_dge[cve_ent == 9, ]
df_dge <- as.data.table(reshape2::melt(df_dge))
df_dge <- df_dge[-c(1, 2), -"nombre"]
names(df_dge) <- c("fec_defuncion", "covid_dge")
df_dge$fec_defuncion <- dmy(df_dge$fec_defuncion)
n_covid_dge <- sum(df_dge[fec_defuncion >= "2020-03-23" & fec_defuncion <="2020-09-26", "covid_dge"], na.rm = T)

# SEDESA
df_sedesa <- fread("./datos/a_sedesa.csv")
df_sedesa <- df_sedesa[, c("FECHADEFUNCION", "CIECAUSABASICA"), with = FALSE]
df_sedesa[, defuncion_covid := ifelse(grepl("U07", CIECAUSABASICA), yes = 1, no = 0)] # U07 es el código de covid-19 en la CIE10
df_sedesa$FECHADEFUNCION <- ymd(df_sedesa$FECHADEFUNCION)
df_sedesa <- df_sedesa[, .(covid_sedesa = sum(defuncion_covid == 1, na.rm = TRUE)), by = FECHADEFUNCION]
n_covid_sedesa <- sum(df_sedesa[FECHADEFUNCION >= "2020-03-23" & FECHADEFUNCION <="2020-09-26", "covid_sedesa"], na.rm = T)

# Exceso de mortalidad
df_exceso <- fread("./datos/weeks.csv")
setnames(df_exceso, old = names(df_exceso)[2:7], new = c("defunciones_2016", "defunciones_2017", "defunciones_2018", 
                                                         "defunciones_2019", "defunciones_2020", "defunciones_2021"))
df_exceso$media <- rowMeans(df_exceso[, c("defunciones_2016", "defunciones_2017", "defunciones_2018", "defunciones_2019"), with = F])
df_exceso[, exceso_2020 := defunciones_2020-media] 
n_exceso <- sum(df_exceso[week >= 14 & week <=40, "exceso_2020"], na.rm = T)

# Defunciones pot covid-19 totales spor fuente
df <-  data.table("fuente" = c("Dirección General\nde Epidemiología⁶",
                               "Secretaria de Salud (CIE10)⁵",
                               "Agencia Digital\nde Innovación Pública⁴",
                               "Clasificación de los autores³", 
                               "Clasificación de los autores\n(incluyendo neumonía atípica)²",
                               "Exceso de mortalidad¹"),
                  "n" = c(n_covid_dge, 
                          n_covid_sedesa, 
                          n_covid_adip, 
                          n_covid_nuestro, 
                          n_covid_o_neumonia_nuestro, 
                          n_exceso))
df$fuente <- factor(df$fuente, 
                    levels = unique(df$fuente), 
                    labels = unique(df$fuente))

df[, label := paste0(prettyNum(n, ",", scientific = F), "\n(", round(n/n_covid_dge, 1), ")")]

ggplot(df, 
       aes(x = fuente, y = n, fill = fuente, label =  label)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = c("#b6e2d4", "#7fccb4", "#66c2a5", "#49b694", "#3a9276", "#2c6d59")) +
  geom_text(color = "black", size = 4, position = position_stack(vjust = 0.5)) +
  coord_flip() +
  labs(title = "Distintas realidades",
       subtitle = "Comparativo entre exceso de mortalidad y total de defunciones por covid-19 reportadas por distintas fuentes de información.\nEntre paréntesis el múltiplo que cada estimado es del número reportado por la DGE.\n23 de feberero del 2020 - 26 de septiembre 2020, CDMX",
       caption = "Fuente: Elaboración propia con datos de:
       ¹Romero Zavala, Mario & Despeghel, Laurianne. (2020). Excess mortality data for Mexico City 2020.
       ²Actas de defunción que contienen términos (COV o CORONAVIRUS), (NEU y ATIP) o (NEU y VIRAL).
       ³Actas de defunción que contienen términos (COV o CORONAVIRUS).
       ⁴Actas de defuncíón clasificadas por la Agencia Digital de Innovación Pública.
       ⁵Actas de defunción clasificadas con el CIE10 y validadas por la Secretaria de Salud.
       ⁶Reportadas por la Dirección General de Epidemiología.",
       x = "Fuente de información",
       y = "Total de defunciones por covid-19") +
  guides(fill = FALSE) +
  theme_light() 