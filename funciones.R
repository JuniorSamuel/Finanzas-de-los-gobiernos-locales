
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
