library(httr)
library(jsonlite)
library(dplyr)
library(mongolite)

get <- function(endpoint = ""){
    # URI root de la API
    root = "http://20.230.44.223:8000/"
    # Construimos la uri de consulta
    uri <- paste0(root, endpoint)
    # Obtenemos el resultado de la API
    res <- GET(uri)
    # Convertimos a lista
    result <- fromJSON(rawToChar(res$content))
    # Retornamos el resultado
    return(result)
}

post <- function(endpoint = ""){
    # URI root de la API
    root = "http://20.230.44.223:8000/"
    # Construimos la uri de consulta
    uri <- paste0(root, endpoint)
    # Obtenemos el resultado de la API
    res <- POST(uri)
    # Convertimos a lista
    result <- fromJSON(rawToChar(res$content))
    # Retornamos el resultado
    return(result)
}

# Nos conectamos a la base de datos
conn <- mongo("encuesta", url = "mongodb+srv://170300075:Maripau01@cluster0.ynkmfoz.mongodb.net/ciam")

resultados <- function() {
    # Obtener los datos de la base de datos
    resultados_encuesta <- conn$find("{}")
    # Asignar un valor por default a observaciones nulas
    resultados_encuesta[is.na(resultados_encuesta)] <- "No aplica"
    # Renombrar columnas de la tabla a equivalentes en Español
    resultados_encuesta <- resultados_encuesta %>% rename(
      "Nombre completo" = nombre,
      "Correo electrónico" = correo,
      "Edad" = edad,
      "Sexo" = sexo,
      "Estado civil" = estado_civil,
      "Habla lengua indigena" = habla_lengua_indigena,
      "Cuál lengua indigena" = cual_lengua_indigena,
      "Ingresos mensuales del hogar" = ingresos_mensuales_hogar,
      "Personas que viven en la misma vivienda" = viven_misma_vivienda,
      "Cantidad personas trabajan" = cuantas_personas_trabajan,
      "Principal ingreso económico" = principal_ingreso_economico,
      "Sector económico del principal ingreso económico" = sector_economico,
      "Horas laborales" = horas_laborales,
      "Minutos en llegar al trabajo" = minutos_llegar_trabajo,
      "Cantidad de menores (femenino)" = cantidad_menores_femenino,
      "Cantidad de menores (masculino)" = cantidad_menores_masculino,
      "Quién cuida a los menores" = quien_cuida_menores,
      "Menores que asisten a la escuela" = menores_asisten_escuela,
      "Rango de edad de menores" = rango_edad_menores,
      "Servicio médico" = servicio_medico,
      "Lugar de residencia" = lugar_residencia,
      "Ultimo grado de estudios (principal ingreso)" = ultimo_grado_estudios_principal_ingreso,
      "Último grado de estudios (encuestado)" = ultimo_grado_estudios_encuestado,
      "Principales necesidades" = principales_necesidades,
      "Otra principal necesidad" = cual_principal_necesidad,
      "Conoce el CIAM" = conoce_ciam,
      "Actividades que recomienda" = actividades_recomendadas,
      "Hora de la encuesta" = hora_encuesta
    )

    # Retornamos el marco de datos
    return(resultados_encuesta)
}