# Cargar las librerías necesarias
library(readxl)
library(sf)
library(ggplot2)
library(dplyr)

# Definir las rutas del archivo Excel y el shapefile
descargar_archivo("https://www.one.gob.do/media/isyjdega/base-de-datos-gastos-de-los-gobiernos-locales-2023.xlsx", "./datos/gastos-2023.xlsx")
shapefile_reg_path <- "./regiones/regiones.shp"

# Leer los datos del archivo Excel
excel_data <- read_excel(excel_path,sheet = "Gastos 2023") %>%
  select(`CÓD_REGIÓN`, REGIÓN, DEVENGADO) %>%
  mutate(`CÓD_REGIÓN` = trimws(`CÓD_REGIÓN`))

# Sumar los valores de "DEVENGADO" por región
devengado_por_region <- excel_data %>%
  group_by(`CÓD_REGIÓN`, REGIÓN) %>%
  summarise(DEVENGADO = sum(DEVENGADO, na.rm = TRUE))

# Leer el shapefile del mapa de regiones
map_reg_data <- st_read(shapefile_reg_path)

# Asegurarse de que los códigos de región en el shapefile coincidan
map_reg_data$REG <- trimws(as.character(map_reg_data$REG))

# Unir los datos del Excel con el shapefile de regiones
map_reg_data <- map_reg_data %>%
  left_join(devengado_por_region, by = c("CODREG" = "CÓD_REGIÓN"))

# Reemplazar valores NA por 0 en la columna de DEVENGADO
map_reg_data$DEVENGADO[is.na(map_reg_data$DEVENGADO)] <- 0

# Graficar el mapa con los datos de DEVENGADO por región
graficar_mapa( map_reg_data)