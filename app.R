library(shiny)
library(jsonlite)
library(DT)

# Define UI
ui <- fluidPage(
  titlePanel("GMDtables suppl table 1"),
  DTOutput("table")
)

# Define server logic
server <- function(input, output) {
  # Read the JSON file
  data <- reactive({
    json_data <- as.data.frame(fromJSON("s1_json.txt", flatten = TRUE))
    return(json_data)
  })
  
  # Render the table
  output$table <- renderDT({
    datatable(data(), 
              options = list(pageLength = 100, autoWidth = TRUE),
              filter = 'top')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
