# Loading required libraries
library(shiny)
library(ggplot2)
library(palmerpenguins)

# Create Input() UI 
ui <- fluidPage(
  titlePanel("Penguin Data Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("xvar", "X-axis variable:",
                  choices = c("Flipper Length" = "flipper_length_mm",
                              "Bill Length" = "bill_length_mm",
                              "Bill Depth" = "bill_depth_mm",
                              "Body Mass" = "body_mass_g")),
      selectInput("yvar", "Y-axis variable:",
                  choices = c("Body Mass" = "body_mass_g",
                              "Flipper Length" = "flipper_length_mm",
                              "Bill Length" = "bill_length_mm",
                              "Bill Depth" = "bill_depth_mm")),
      selectInput("colorvar", "Color by:",
                  choices = c("Species" = "species",
                              "Sex" = "sex",
                              "Island" = "island"))
    ),
    
    mainPanel(
      plotOutput("scatterPlot")   # Match Output with render in server 
    )
  )
)
# Server determine how to render outputs given inputs
server <- function(input, output) {
  
  output$scatterPlot <- renderPlot({
    ggplot(data = penguins, aes_string(x = input$xvar, y = input$yvar, color = input$colorvar)) +
      geom_point() +
      labs(title = paste(input$yvar, "vs", input$xvar),
           x = input$xvar,
           y = input$yvar) +
      theme_minimal()
  })  
}

shinyApp(ui, server)  # combination of UI and server logic