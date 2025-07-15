library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Load your data
# Replace 'your_data.csv' with your actual dataset
inventory_data <- read.csv("wholeInventory.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Inventory and Production Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("species", "Select Species:", 
                  choices = unique(inventory_data$species), 
                  selected = unique(inventory_data$species)[1]),
      
      selectInput("site", "Select Site:", 
                  choices = unique(inventory_data$site), 
                  selected = unique(inventory_data$site)[1]),
      
      dateRangeInput("date_range", "Select Date Range:",
                     start = min(inventory_data$date),
                     end = max(inventory_data$date))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary Table", DTOutput("summary_table")),
        tabPanel("Production Trends", plotOutput("trend_plot"))
      )
    )
  )
)

# Define Server
server <- function(input, output) {
  filtered_data <- reactive({
    inventory_data %>%
      filter(species == input$species,
             site == input$site,
             date >= input$date_range[1],
             date <= input$date_range[2])
  })
  
  output$summary_table <- renderDT({
    datatable(filtered_data())
  })
  
  output$trend_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = date, y = production)) +
      geom_line() +
      geom_point() +
      labs(title = "Production Trends", x = "Date", y = "Production")
  })
}

# Run App
shinyApp(ui, server)
