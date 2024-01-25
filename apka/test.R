library(shiny)

ui <- fluidPage(
  titlePanel("Month Range Slider Example"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("monthSlider", "Choose a Month Range:", min = 1, max = 12, value = c(1, 6), step = 1)
    ),
    mainPanel(
      textOutput("selectedMonthRange")
    )
  )
)

server <- function(input, output) {
  output$selectedMonthRange <- renderText({
    # Use the selected month range values to display the corresponding month names
    month_names <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
    selected_months <- month_names[input$monthSlider[1]:input$monthSlider[2]]
    paste("You selected:", paste(selected_months, collapse = ", "))
  })
}

shinyApp(ui, server)