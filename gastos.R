
gastos_main <- function() {
  
  # Obtenar datos 
  url <- "https://www.one.gob.do/media/yg4fohjt/base-de-datos-de-los-gastos-de-los-gobiernos-locales-2023.xlsx"
  archivoGasto <- descargar_archivo(url, "gasto-2023.xlsx")
  
  datosGasto <- read_excel(archivoGasto, sheet = 2)
  datosGasto$DEVENGADO <- as.numeric(datosGasto$DEVENGADO)
  resumenGasto <- datosGasto %>% group_by(CÓD_MES) %>% summarise(gasto = sum(DEVENGADO, na.rm = TRUE))
  
  resumenGasto <- datosGasto %>% group_by(CÓD_REGIÓN) %>% summarise(Gasto = sum(DEVENGADO, na.rm = TRUE))
  
  
  mapard <- mapard %>%
    left_join(resumenGasto, by = c("CODREG" = "CÓD_REGIÓN"))
  
  
  # Grafico
  graficar_mapa(
    mapard,
    "Gasto",
    "Gastos por región",
    "Datos 2023",
    "Grupo 5 - Junior Samuel y Randy Benjamín - 11/29/24",
    fill_high = "#f2972b", fill_low = "#3486bb")
  
  return(datosGasto)
}