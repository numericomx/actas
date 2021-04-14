library(data.table)
library(lubridate)
library(ggplot2)
library(patchwork)

df <- fread("./datos/defunciones_semanales.csv")

# Defunciones por causa y semana en formato largo
df_largo <- melt(df, id.vars = "semana", variable.name = "fuente", value.name = "total_defunciones")

p1 <- ggplot(df_largo[fuente %in% c("covid_actas_acum", "covid_o_neumonia_actas_acum", "covid_dge_acum", "exceso_acum"), ], 
             aes(x = semana, y = total_defunciones, colour = fuente)) +
  geom_line(size = 1) + 
  geom_point(size = 1.5) +
  scale_x_date(date_breaks = "months" , date_labels = "%b %Y") + 
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("#66c2a5", "#8da0cb", "#b58f5bff", "#c14350ff")) +
  labs(title = "Una curva alternativa",
       subtitle = "23 de febrero del 2020 - 20 de febrero del 2021, CDMX\n\nCifras acumuladas semanales",
       x = "",
       y = "") +
  guides(fill = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

p2 <- ggplot(df_largo[fuente %in% c("covid_actas", "covid_o_neumonia_actas", "covid_dge", "exceso"), ], 
             aes(x = semana, y = total_defunciones, colour = fuente)) +
  geom_line(size = 1) + 
  geom_point(size = 1.5) +
  scale_x_date(date_breaks = "months" , date_labels = "%b %Y") + 
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = c("#66c2a5", "#8da0cb", "#b58f5bff", "#c14350ff")) +
  labs(subtitle = "Cifras semanales",
       caption = "La línea rayada en la segunda gráfica representa el día con mayor número de defunciones.
       Fuente: Elaboración propia con datos de: 
       Romero Zavala, Mario & Despeghel, Laurianne. (2020). Excess mortality data for Mexico City 2020,
       la Agencia Digital de Innovación Pública y la Dirección General de Epidemiología.
       *Contienen términos (COV o CORONAVIRUS).\n**Contienen términos (COV o CORONAVIRUS), (NEU y ATIP) o (NEU y VIRAL).",
       x = "", 
       y = "") +
  geom_vline(xintercept = as.Date("2021-01-17"), color = "#555555", linetype = "dashed", size = 0.5) +
  guides(fill = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")

p <- p1/p2

plot(p)