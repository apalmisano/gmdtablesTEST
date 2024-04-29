library(shiny)
library(jsonlite)
library(DT)

# Define UI
ui <- fluidPage(
  
  titlePanel("GMDtables various tables"),
  
  # Sidebar with a slider input for number of observations
  sidebarLayout(
    sidebarPanel(
      br(),
      hr(style ="border: 1px solid red;"),
      selectInput("n", "Select supplementary table to show", choices = c("S1", "S3")),
      hr(style ="border: 1px solid red;"),
      br()
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      br(),
      hr(),
      p("Supplementary material to the publication in Clinical Epigenetics",
         style="color:black; font-size: 1.4em; font-weight: bold;"),
      p("Association of expression of epigenetic molecular factors with DNA methylation and sensitivity to chemotherapeutic agents in cancer cell lines",
         style="color:black; font-size: 2.4em; font-weight: bold;"),
      br(),
      br(),
      p("Check the side bar for the list of all the available Supplementary tables", 
         style="padding: 15px; margin: 0px;border-style:solid; border-color: #e9e9e9; color:red; font-weight: bold;"),
      br(),
      br(),
      p("Web resource developed by: Computational and Systems Biology Branch (Biometric Research Program, DCTD/NCI)" ),
      br(),
      br(),
      DTOutput("table"),
      hr(),
      br()
    )
  )
  
  
  
  
 
)

# Define server logic
server <- function(input, output) {
  
  values <- reactiveValues(
    colnames_data = 0
  )
  # Read the JSON file
  data <- reactive({
    if (input$n == "S1") {
      json_data <- as.data.frame(fromJSON("s1_json.txt", flatten = TRUE))
      values$colnames_data = c("GMD", "Synonyms", "Full name", "Mechanisms of effect on DNA methylation levels")
    } else {
      json_data <- as.data.frame(fromJSON("s3_json.txt", flatten = TRUE))
      values$colnames_data = c("GMD", "Agent", "Source", "Spearman", "pFDR", "Sample size")
    }
    return(json_data)
  })
  
  # Render the table
  output$table <- renderDT({
    datatable(data(), 
              colnames = values$colnames_data,
              extensions = "Buttons",
              selection = "none",
              autoHideNavigation = FALSE,
              options = list(paging = TRUE,
                             searching = TRUE,
                             ordering = TRUE,
                             dom = 'fltpB',
                             buttons = c('csv', 'excel'),
                             pageLength=10),
              #options = list(pageLength = 10, autoWidth = TRUE),
              filter = 'top')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
