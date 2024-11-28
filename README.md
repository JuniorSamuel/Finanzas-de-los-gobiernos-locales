# Proyecto final SIG

## Gastos vs Ingresos de gobiernos locales 2022 - 2023 por provincias



# Funciones

## descargar_archivo

### Descripción
La función descargar_archivo descarga un archivo desde una URL especificada y lo guarda en un directorio local. Si el directorio no existe, se crea automáticamente. La función verifica si la descarga fue exitosa y devuelve la ruta completa del archivo descargado.

### Uso
``` r
descargar_archivo(url, nombre_archivo)
```
### Parámetros
- `url`: La URL desde la cual se descargará el archivo.

- `nombre_archivo`: El nombre del archivo (incluyendo extensión) que se guardará en el directorio local `./datos/`.

### Ejemplo
``` R
url <- "https://www.one.gob.do/media/isyjdega/base-de-datos-ingresos-de-los-gobiernos-locales-2023.xlsx"
nombre_archivo <- "ingreso-2022.xlsx"
ruta_completa <- descargar_archivo(url, nombre_archivo)
print(ruta_completa)
```

### Código
```r
descargar_archivo <- function(url, nombre_archivo) {
  archivo <- file.path("./datos", nombre_archivo)
  
  dir.create(dirname(archivo), showWarnings = FALSE)
  
  download.file(url, archivo, mode = "wb")
  
  if (file.exists(archivo)) {
    message("Archivo descargado exitosamente: ", archivo)
  } else {
    message("Error en la descarga del archivo.")
  }
  
  return(archivo)
}

```

## getMapa
### Descripción
La función getMapa lee y devuelve un mapa en formato shapefile (.shx) desde un directorio local ./mapas. Permite obtener mapas de municipios, provincias o regiones, según se especifique.

### Uso
```r
getMapa(mapa)
```
### Parámetros
- `mapa`: Un valor de texto que especifica el tipo de mapa a leer. Los valores válidos son "municipios", "provincias", y "regiones".

### Ejemplo
``` r
# Obtener el mapa de municipios
mapa_municipios <- getMapa("municipios")

# Obtener el mapa de provincias
mapa_provincias <- getMapa("provincias")

# Obtener el mapa de regiones
mapa_regiones <- getMapa("regiones")
```

### Código
``` r
getMapa <- function(mapa) {
  root <- "./mapas"
  
  if(mapa == "municipios") {
    return(st_read(file.path(root, "municipios/municipios.shx")))
  }
  
  if(mapa == "provincias") {
    return(st_read(file.path(root, "provincias/provincias.shx")))
  }
  
  if(mapa == "regiones"){
    return(st_read(file.path(root, "regiones/region.shx")))
  } else {
    message("Mapa no se encuentra")
  }
}
```