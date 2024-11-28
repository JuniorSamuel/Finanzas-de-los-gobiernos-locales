
descargar_archivo <- function(url, archivo) {

  download.file(url, archivo, mode = "wb")
  
  # Verificar si el archivo ha sido descargado
  if (file.exists(archivo)) {
    message("Archivo descargado exitosamente: ", archivo)
  } else {
    message("Error en la descarga del archivo.")
  }
}

descargar_archivo1 <- function(url, nombre_archivo) {
  # Definir la ruta completa del archivo
  # archivo <- file.path("./datos", nombre_archivo)
  archivo <- file.path(nombre_archivo)
  
  # Crear el directorio si no existe
  dir.create(dirname(archivo), showWarnings = FALSE)
  
  # Descargar el archivo
  download.file(url, archivo, mode = "wb")
  
  # Verificar si el archivo ha sido descargado
  if (file.exists(archivo)) {
    message("Archivo descargado exitosamente: ", archivo)
  } else {
    message("Error en la descarga del archivo.")
  }
}

graficar_mapa  <- function(map_reg_data) {
  ggplot(data = map_reg_data) +
    geom_sf(aes(fill = DEVENGADO), color = "black") +
    geom_sf_text(aes(label = ifelse(DEVENGADO >= 1e9, 
                                    paste0(round(DEVENGADO / 1e9, 1), "B"), 
                                    ifelse(DEVENGADO >= 1e6, 
                                           paste0(round(DEVENGADO / 1e6, 1), "M"), 
                                           paste0(round(DEVENGADO / 1e3, 1), "K")))), 
                 size = 3, color = "black") +
    scale_fill_gradient(
      name = "Devengado (RD$)",
      labels = scales::label_number(scale_cut = scales::cut_short_scale()), 
      low = "#fee8c8", high = "#e34a33", na.value = "grey50"
    ) +
    labs(
      title = "Gastos Devengados por Región - República Dominicana",
      subtitle = "Montos en pesos dominicanos",
      caption = "Fuente: Datos de gastos de los gobiernos locales, 2023"
    ) +
    theme_minimal()
}