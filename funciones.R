

descargar_archivo <- function(url, nombre_archivo) {
  # Definir la ruta completa del archivo
  # archivo <- file.path("./datos", nombre_archivo)
  archivo <- file.path("./datos", nombre_archivo)
  
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
  
  return(archivo)
}

getMapa <- function(mapa) {
  root <- "./mapas"
  
  if(mapa == "municipios") {
    return(st_read(file.path(root, "municipios/municipios.shx")))
  }
  
  if(mapa == "provincias") {
    return(st_read(file.path(root, "provincias/provincias.shx")))
  }
  
  if(mapa == "regiones"){
    return(return(st_read(file.path(root, "regiones/region.shx"))))
  }
  else {
    message("Mapa no se encuentra")
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

library(ggplot2)

plot_devengado <- function(data, fill_var = "DEVENGADO", title = "Gastos Devengados por Región - República Dominicana", 
                           subtitle = "Montos en pesos dominicanos", 
                           caption = "Fuente: Datos de gastos de los gobiernos locales, 2023",
                           fill_low = "#fee8c8", fill_high = "#e34a33", na_fill = "grey50") {
  
  ggplot(data = data) +
    geom_sf(aes_string(fill = fill_var), color = "black") +
    geom_sf_text(aes(label = ifelse(!!as.name(fill_var) >= 1e9, 
                                    paste0(round(!!as.name(fill_var) / 1e9, 1), "B"), 
                                    ifelse(!!as.name(fill_var) >= 1e6, 
                                           paste0(round(!!as.name(fill_var) / 1e6, 1), "M"), 
                                           paste0(round(!!as.name(fill_var) / 1e3, 1), "K")))), 
                 size = 3, color = "black") +
    scale_fill_gradient(
      name = fill_var + "(RD$)",
      labels = scales::label_number(scale_cut = scales::cut_short_scale()), 
      low = fill_low, high = fill_high, na.value = na_fill
    ) +
    labs(
      title = title,
      subtitle = subtitle,
      caption = caption
    ) +
    theme_minimal()
}


