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
source("ingresos.R")
source("gastos.R") 


#Cargar mapa.shp
mapard <- getMapa("regiones")

# Obtenar datos 
# url <- "https://www.one.gob.do/media/isyjdega/base-de-datos-ingresos-de-los-gobiernos-locales-2023.xlsx"
# archivoIngreso <- descargar_archivo(url, "ingreso-2023.xlsx") Descargar
archivoIngreso <- "./datos/ingreso-2023.xlsx"

datosIngreso <- read_excel(archivoIngreso, sheet = 2)
datosIngreso$PERCIBIDO <- as.numeric(datosIngreso$PERCIBIDO)
resumenIngreso <- datosIngreso %>% group_by(CÓD_REGIÓN) %>% summarise(Ingreso = sum(PERCIBIDO, na.rm = TRUE))


mapard <- mapard %>%
  left_join(resumenIngreso, by = c("CODREG" = "CÓD_REGIÓN"))

# Grafico Ingreso
graficar_mapa(
  mapard,
  "Ingreso",
  "Ingresos por región",
  "Datos 2023",
  "Grupo 5 - Junior Samuel y Randy Benjamín - 11/29/24",
  fill_high = "#f2972b", 
  fill_low = "#3486bb")

# Obtenar datos
# url <- "https://www.one.gob.do/media/yg4fohjt/base-de-datos-de-los-gastos-de-los-gobiernos-locales-2023.xlsx"
# archivoGasto <- descargar_archivo(url, "gasto-2023.xlsx")
archivoGasto <- "./datos/gasto-2023.xlsx"

datosGasto <- read_excel(archivoGasto, sheet = 2)
datosGasto$DEVENGADO <- as.numeric(datosGasto$DEVENGADO)
resumenGasto <- datosGasto %>% group_by(CÓD_MES) %>% summarise(gasto = sum(DEVENGADO, na.rm = TRUE))

resumenGasto <- datosGasto %>% group_by(CÓD_REGIÓN) %>% summarise(Gasto = sum(DEVENGADO, na.rm = TRUE))


mapard <- mapard %>%
  left_join(resumenGasto, by = c("CODREG" = "CÓD_REGIÓN"))


# Grafico Gasto
graficar_mapa(
  mapard,
  "Gasto",
  "Gastos por región",
  "Datos 2023",
  "Grupo 5 - Junior Samuel y Randy Benjamín - 11/29/24",
  fill_high = "#f2972b", fill_low = "#3486bb")


# Gastos e ingresos por mes
mesesGasto <-  datosGasto %>% group_by(MES) %>% summarise(gastos = sum(DEVENGADO, na.rm = TRUE))
mesesIngreso <- datosIngreso %>% group_by(MES) %>% summarise(ingresos = sum(PERCIBIDO, na.rm = TRUE))
gp <- mesesGasto %>%
  left_join(mesesIngreso, by = c("MES" = "MES"))

write.csv(gp, file = "./exportados/gastoIngresoMes.csv", row.names = FALSE)


#gastos e ingresos por Region
regionGasto <-  datosGasto %>% group_by(REGIÓN) %>% summarise(gastos = sum(DEVENGADO, na.rm = TRUE))
regionIngreso <- datosIngreso %>% group_by(REGIÓN) %>% summarise(ingresos = sum(PERCIBIDO, na.rm = TRUE))
rgi <- regionGasto %>%
  left_join(regionIngreso, by = c("REGIÓN" = "REGIÓN"))

rgi$PorcentajeGasto <- round( rgi$gastos / sum(rgi$gastos) * 100, 2 )
rgi$PorcentajeIngreso <- round( rgi$ingresos / sum(rgi$ingresos) * 100, 2) 

write.csv(rgi, file = "./exportados/gastoIngreoMes.csv", row.names = FALSE)

#Exportar datos por concepto
conceptoGasto <- datosGasto %>% group_by(CONCEPTO) %>% summarise(Gasto = sum(DEVENGADO, na.rm = TRUE))
conceptoIngreso <- datosIngreso %>% group_by(CONCEPTO) %>% summarise(Ingreso = sum(PERCIBIDO, na.rm = TRUE))

write.csv(conceptoGasto, file = "./exportados/conceptoGasto.csv", row.names = FALSE)
write.csv(conceptoIngreso, file = "./exportados/conceptoIngreso.csv", row.names = FALSE)



