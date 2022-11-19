library(bs4Dash)                # Agregar estilo de Boostrap 4
library(mongolite)              # Añadir conectividad con MongoDB
library(toastui)                # Añadir elementos de toastui
library(highcharter)            # Añadir elementos visuales de highcharts
library(shiny)                  # Añadir los elementos de shiny
library(DT)                     # Añadir datatables
library(dplyr)                  # Añadir funcionalidad de manipulación de datos
library(shinycookie)            # Añadir cookies en shiny


# Importar componentes adicionales
source("matriculaInput.R")
source("contraseñaInput.R")
# Importar funciones para usar API
source("./config/api.R")


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
                    matriculaInput(inputId = "email", label = "Correo electrónico")
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

                  # REGISTER LINK
                  a(href = "#", "Crear una cuenta", 
                    class = "mx-3 mb-3 text-decoration-none text-end", 
                    style = "display: block",
                    `onclick` = "document.cookie='access_token=register'"
                  )
                )
              )
            )
          )
        )
      )   
    )
  )
)

register <- div(
  id = "register", 
  tags$head(
    tags$link(rel="stylesheet", href = "hiddenScrollbar.css"),
    tags$script(src = "showPassword.js"),
    tags$link(rel = "stylesheet", type="text/css", href="matricula-style.css"),
    tags$script(src = "styling.js"),

    # Estilizar botones para CIAM
    tags$link(rel="stylesheet", href = "custom_styles.css"),

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
                    matriculaInput(inputId = "email", label = "Correo electrónico")
                  ),

                  # PASSWORD
                  tags$div(
                    class = "input-group has-validation px-3 mb-4",
                    contraseñaInput(inputId = "password", label = "Escribe tu nueva contraseña")
                  ),
                    
                  # PASSWORD AGAIN
                  tags$div(
                    class = "input-group has-validation px-3 mb-4",
                    contraseñaInput(inputId = "password_match", label = "Escribe tu contraseña de nuevo")
                  ),
                  
                  # SUBMIT
                  actionButton(
                    inputId = "register",
                    label = "Registrarse",
                    class = "btn btn-primary mx-3 mb-3"
                  ),

                  # LOGIN LINK
                  a(href = "#", "Ya tengo una cuenta", 
                    class = "mx-3 mb-3 text-decoration-none text-end", 
                    style = "display: block",
                    `onclick` = "document.cookie='access_token=login'"
                  )
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

  # Lógica de la app
  observe({

    # Si el token de acceso existe
    if(!is.null(input$token$access_token)){
      # Si el token está para registro
      if(input$token$access_token == "register") {
        # Remover el UI del login
        removeUI(selector = "#login")

        div(id = "register_alert", style = "position: absolute; bottom: 0; right: 0;")
        
        # Insertar el register en la página
        insertUI(selector = "#container", where = "afterBegin", register)
      }

      else if(input$token$access_token == "login") {
        # Remover el UI del register
        removeUI(selector = "#register")

        # Insertar el login en la página
        insertUI(selector = "#container", where = "afterBegin", login)
      }

      else {
        # El token se valida para corroborar su validez
        # Insertar el dashboard en la página
        insertUI(selector = "#container", where = "afterBegin", dashboard)
      }
    }

    # Si el token es nulo
    else{
      updateCookie(session, "access_token" = "login")
      session$reload()
    }
  })

  # Si se presiona botón de login
  observeEvent(input$login, {
    updateCookie(session, "access_token" = "true")
    session$reload()
  })

  # Si se presiona botón de registro
  observeEvent(input$register, {
    if(input$password != input$password_match) {
      createAlert(
        id = "register_alert",
        options = list(
          title = "Error",
          closable = TRUE,
          width = 6,
          elevations = 4,
          status = "warning",
          content = "Las contraseñas proporcionadas no coinciden, intente de nuevo..."
        ),

        session = shiny::getDefaultReactiveDomain()
      )
    }
    # session$reload()
  })

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
        colwidths = "guess",
        align = "left",
        width = "100%"
      )
    )
  })
}

options(shiny.autoreload = TRUE)
shinyApp(ui, server)