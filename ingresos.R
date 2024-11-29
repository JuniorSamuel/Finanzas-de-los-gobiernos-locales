
ingresos_main <- function(){
  
  # Obtenar datos 
  url <- "https://www.one.gob.do/media/isyjdega/base-de-datos-ingresos-de-los-gobiernos-locales-2023.xlsx"
  archivoIngreso <- descargar_archivo(url, "ingreso-2023.xlsx")
  
  datosIngreso <- read_excel(archivoIngreso, sheet = 2)
  datosIngreso$PERCIBIDO <- as.numeric(datosIngreso$PERCIBIDO)
  resumenIngreso <- datosIngreso %>% group_by(CÓD_REGIÓN) %>% summarise(Ingreso = sum(PERCIBIDO, na.rm = TRUE))
  
  
  mapard <- mapard %>%
    left_join(resumenIngreso, by = c("CODREG" = "CÓD_REGIÓN"))
  
  
  # Grafico
  graficar_mapa(
    mapard,
    "Ingreso",
    "Ingresos por región",
    "Datos 2023",
    "Grupo 5 - Junior Samuel y Randy Benjamín - 11/29/24",
    fill_high = "#f2972b", 
    fill_low = "#3486bb")
  
  return(datosIngreso)
}




