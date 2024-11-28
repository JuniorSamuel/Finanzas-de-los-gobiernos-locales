
#instalar paquetes 
install.packages("ggplot2") 
install.packages("sf") 
install.packages("readr")
install.packages("dplyr")
install.packages("readxl")

# Cargar la bibliotecas 
library(ggplot2) 
library(sf) 
library(readr)
library(dplyr)
library(readxl)

source("funciones.R")



# Obtenar datos 
#url <- "https://www.one.gob.do/media/isyjdega/base-de-datos-ingresos-de-los-gobiernos-locales-2023.xlsx"
#archivo <- descargar_archivo(url, "ingreso-2023.xlsx")

datos <- read_excel(archivo, sheet = 2)
datos$PERCIBIDO <- as.numeric(datos$PERCIBIDO)
resumen <- datos %>% group_by(CÓD_REGIÓN) %>% summarise(total_percibido = sum(PERCIBIDO, na.rm = TRUE))

#Cargar mapa.shp

mapard <- getMapa("regiones")

mapard <- mapard %>%
  left_join(resumen, by = c("CODREG" = "CÓD_REGIÓN"))

# Grafico
graficar_mapa(mapard,"total_percibido", "Total de ingresos por Provincia", "", "")


