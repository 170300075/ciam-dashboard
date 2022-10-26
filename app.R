library(bs4Dash)
library(mongolite)
library(toastui)

header <- dashboardHeader(
  title = "CIAM Dashboard",
  skin = "light",
  status = "white"
)

sidebar <- dashboardSidebar(
  skin = "dark", 
  elevation = 2, 
  status = "lime",
  expandOnHover = FALSE, 
  fixed = TRUE,
  
  sidebarMenu(
    menuItem(
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


body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "estadisticas",
      h2("Estadísticas")
    ),
    
    tabItem(
      tabName = "resultados",
      h2("Tabla de resultados"),
      datagridOutput(outputId = "tabla")
    )
  )
)

footer <- dashboardFooter()

ui <- dashboardPage(
  header, sidebar, body, footer = NULL
)

server <- function(input, output, session) {
  # Almacenamiento de valores reactivos
  datos <- reactiveValues()
  
  # Nos conectamos a la base de datos
  conn <- mongo("encuesta", url = "mongodb+srv://170300075:Maripau01@cluster0.ynkmfoz.mongodb.net/ciam")
  
  # Leemos los datos
  observe({
    datos$resultados_encuesta <- conn$find("{}")
  })
  
  
  output$tabla <- renderDatagrid({
    datagrid(datos$resultados_encuesta, colwidths = "guess", theme = "striped")
  })
}

options(shiny.autoreload = TRUE)
shinyApp(ui, server)