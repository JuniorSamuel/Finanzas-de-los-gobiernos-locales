
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
url <- "https://www.one.gob.do/media/isyjdega/base-de-datos-ingresos-de-los-gobiernos-locales-2023.xlsx"
archivo <- "./datos/ingreso-2022.xlsx"  
descargar_archivo(url, archivo)


datos <- read_excel(archivo, sheet = 2)

datos$PERCIBIDO <- as.numeric(datos$PERCIBIDO)
resumen <- datos %>% group_by(CÓD_PROVINCIA) %>% summarise(total_percibido = sum(PERCIBIDO, na.rm = TRUE))

#Cargar mapa.shp
ruta_archivo <- "./provincias/provincias.shx"
mapard <- st_read(ruta_archivo)

mapard <- mapard %>%
  left_join(resumen, by = c("PROV" = "CÓD_PROVINCIA"))

#Graficar el mapa con los datos
ggplot() + geom_sf(data = mapard, aes(fill = total_percibido)) + 
  scale_fill_gradientn( 
    colors = c("yellow", "orange", "red"), 
    values = c(0, 0.33, 0.66, 1), 
    name = "Ingreso" 
  ) + 
  geom_sf_text(data = mapard, 
               aes(label = total_percibido), 
               size = 2, color = "black",
               check_overlap = TRUE) + ggtitle("Ingreso por provincia") + theme_minimal()







