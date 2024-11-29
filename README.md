# Proyecto final SIG

## Gastos vs Ingresos de gobiernos locales 2022 - 2023 por provincias

Proyecto final de Sistema de Informacion Geograficas, comparación de los ingresos y gastos de los gobiernos locales en 2023. Se destacan las diferencias por región y los principales conceptos que impulsan las finanzas públicas, ofreciendo un análisis visual y claro de los datos más relevantes.

# Funciones

## descargar_archivo

### Descripción
La función `descargar_archivo` descarga un archivo desde una URL especificada y lo guarda en un directorio local. Si el directorio no existe, se crea automáticamente. La función verifica si la descarga fue exitosa y devuelve la ruta completa del archivo descargado.

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
La función `getMapa` lee y devuelve un mapa en formato shapefile (.shx) desde un directorio local ./mapas. Permite obtener mapas de municipios, provincias o regiones, según se especifique.

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

## graficar_mapa 
### Descripción
Es una función `graficar_mapa` generar mapas temáticos utilizando datos geoespaciales con ggplot2. La función permite visualizar diferentes variables en mapas, asignando colores a las regiones según los valores de una variable específica y mostrando etiquetas de toponimia.

### Uso
``` r
  # Grafico
  graficar_mapa(
    mapard,
    "Ingreso",
    "Ingresos por región",
    "Datos 2023",
    "Grupo 5 - Junior Samuel y Randy Benjamín - 11/29/24",
    fill_high = "#f2972b", 
    fill_low = "#3486bb")
```
### Parámetros
- `mapard`: mapa shapefile, en muestro caso republica dominica.
- `title`: Titulo del mapa.
- `subtitle`: Subtitulo del mapa.
- `caption`: caption de la imagen.
- `fill_low`: Color de minimo.
- `fill_high`: Color de maximo.
- `na_fill`: Color sin datos.

### Ejemplo

### Código
``` r
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
```
