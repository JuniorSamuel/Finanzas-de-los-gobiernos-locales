

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


graficar_mapa <- function(data, fill_var = "DEVENGADO", title = "", 
                          subtitle = "", 
                          caption = "",
                          fill_low = "#fee8c8", 
                          fill_high = "#e34a33", 
                          na_fill = "grey50") {
  #Remover la palabras REGION y O METROPOLITANA
  m <- data;
  m$TOPONIMIA <- gsub("^REGION ", "", m$TOPONIMIA)
  m$TOPONIMIA <- gsub(" O METROPOLITANA", "", m$TOPONIMIA)
    
  ggplot(data = m) +
    geom_sf(aes_string(fill = fill_var), color = "black") +
    geom_sf_text(
      aes_string(label = "TOPONIMIA"), 
      size = 4, color = "black", 
      check_overlap = TRUE) +
    scale_fill_gradient(
      name = paste(fill_var, "(RD$)"),
      labels = function(x) { 
        ifelse(x >= 1e9, 
               paste0(round(x / 1e9, 1), " Mil Millones"), 
               ifelse(x >= 1e6, paste0(round(x / 1e6, 1), " Millones"), x)) 
        }, 
      low = fill_low, high = fill_high, na.value = na_fill
    ) +
    labs(
      title = title,
      subtitle = subtitle,
      caption = caption
    ) + 
    theme_void()
}
