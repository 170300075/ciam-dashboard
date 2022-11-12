library(bs4Dash)                # Agregar estilo de Boostrap 4
library(mongolite)              # Añadir conectividad con MongoDB
library(toastui)                # Añadir elementos de toastui
library(highcharter)            # Añadir elementos visuales de highcharts
library(shiny)
library(DT)
library(dplyr)
library(shinycookie)


source("matriculaInput.R")
source("contraseñaInput.R")

# Barra de navegación
header <- dashboardHeader(
  title = "CIAM Dashboard",
  skin = "dark",
  status = "dark-light"
)


# Barra de navegación lateral
sidebar <- dashboardSidebar(
  skin = "dark", 
  elevation = 2, 
  status = "purple",
  expandOnHover = FALSE, 
  fixed = TRUE,
  
  sidebarMenu(
    menuItem(
      selected = TRUE, # Seleccionado al principio
      text = "Estadísticas",
      tabName = "estadisticas",
      icon = icon("line-chart")
    ),
    
    menuItem(
      text = "Resultados de encuesta",
      tabName = "resultados",
      icon = icon("table")
    )
  )
)

# Contenido de la página
body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "estadisticas",
      h2("Estadísticas"),
      uiOutput("graficas")
    ),
    
    tabItem(
      tabName = "resultados",
      h2("Tabla de resultados"),
      uiOutput("tabla_resultados")
    )
  )
)

# Pie de página
footer <- dashboardFooter()

########################################
#              Login UI
########################################
login <- div(
  id = "login", 
  tags$head(
    tags$link(rel="stylesheet", href = "hiddenScrollbar.css"),
    tags$script(src = "showPassword.js"),
    tags$link(rel = "stylesheet", type="text/css", href="matricula-style.css"),
    tags$script(src = "styling.js"),
    # Ya se importan con bslib pero el checkbox no funciona sin estos
    tags$script(src = "bootstrap.bundle.min.js"),
    tags$link(rel = "stylesheet", type="text/css", href="bootstrap.min.css")
  ),

  div(
    class = "bg-light",
    div(
      class = "container",
      div(
        class = "row vh-100 justify-content-center align-items-center",
        div(
          class = "col",
          div(
            class = "card mb-3 border-0 shadow-lg mx-auto",
            style = "max-width: 600px;",
            div(
              class = "row",
              div(
                class = "col-md-4",
                style = "background-image: url('./full_logo.png'); background-size: cover; background-repeat: no-repeat; background-position: center; background-attachment: scroll;"
              ),
              
              div(
                class = "col-md-8",
                div(
                  class = "card-body",
                  h5(
                    class = "card-title mt-3 mb-4 text-center lead fs-2", # nolint
                    span(
                      class="fst-italic fw-bold",
                      "CIAM Surveys"
                    )
                  ),
                  
                  # ID USER
                  tags$div(
                    class = "input-group has-validation px-3 mb-4",
                    matriculaInput(inputId = "id_user", label = "Correo electrónico")
                  ),

                  # PASSWORD
                  tags$div(
                    class = "input-group has-validation px-3 mb-4",
                    contraseñaInput(inputId = "password", label = "Contraseña")
                  ),
                    
                  # CHECKBOX
                  div(
                    class = "form-check px-5 mb-4",
                    tags$input(
                      type = "checkbox",
                      class = "form-check-input",
                      id = "exampleCheck1",
                      "onclick"="showPassword()",
                      tags$label(
                        class = "form-check-label user-select-none",
                        `for` = "exampleCheck1",
                        span("Mostrar contraseña", class = "lead fs-6")
                      )
                    )
                  ),
                  
                  # SUBMIT
                  actionButton(
                    inputId = "login",
                    label = "Acceder",
                    class = "btn btn-primary mx-3 mb-3"
                  ),
                )
              )
            )
          )
        )
      )   
    )
  )
)


# Interfaz de usuario del dashboard
dashboard <- dashboardPage(
  header, sidebar, body, footer = NULL
)

ui <- div(
  id = "container",
  initShinyCookie("token")
)

# Lógica del servidor
server <- function(input, output, session) {

  # Si el token cambia de valor
  observeEvent(input$login, {
    updateCookie(session, "access_token" = "true")
    session$reload()
  })

  tokenization <- eventReactive(input$token, {
    if(is.null(input$token$access_token)) {
      # session$reload()
    }

    else {
      updateCookie(session, "access_token" = "true")
    }
  })


  observe({
    tokenization()

    # Si token existe
    if(!is.null(input$token$access_token)) {
      # Eliminar el login de la página
      removeUI(selector = "#login")

      # Insertar el dashboard en la página
      insertUI(selector = "#container", where = "afterBegin", dashboard)
    } 
    
    # Si no existe token
    else {
      # Remover el wrapper de la página
      removeUI(selector = ".wrapper")
      # Insertar el login en la página
      insertUI(selector = "#container", where = "afterBegin", login)
    }
  })


  # Almacenamiento de valores reactivos
  datos <- reactiveValues()
  
  observe({
    # Procesamiento de los datos
    resultados_encuesta <- conn$find("{}")
    resultados_encuesta[is.na(resultados_encuesta)] <- "No aplica"
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

    datos$resultados_encuesta <- resultados_encuesta
  })

  # Nos conectamos a la base de datos
  conn <- mongo("encuesta", url = "mongodb+srv://170300075:Maripau01@cluster0.ynkmfoz.mongodb.net/ciam")
  
  output$graficas <- renderUI({
    box(
      title = "Principales gráficas",
      status = "purple",
      headerBorder = TRUE,
      solidHeader = TRUE,
      collapsible = FALSE,
      elevation = 1,
      width = 12,


      bs4Table(iris)
      # Gráfica por edades
      #hchart(datos$resultados_encuesta, type = "columns", hcaes(x = "Sexo") %>% 
      #hcaes(x = "Sexo", y = "Edad"))
    )
  })

  output$tabla_resultados <- renderUI({
    box(
      title = "Resultados de las encuestas",
      status = "purple",
      headerBorder = TRUE,
      solidHeader = TRUE,
      collapsible = FALSE,
      elevation = 1,
      width = 12,
      
      # Tabla con la información de las encuestas
      datagrid(
        datos$resultados_encuesta,
        sortable = TRUE,
        pagination = 10,
        filters = TRUE,
        theme = "striped",
        colwidths = "guess", # Tamaño de columnas adecuado
        align = "left",
        width = "100%"
      )
    )
  })
}

options(shiny.autoreload = TRUE)
shinyApp(ui, server)