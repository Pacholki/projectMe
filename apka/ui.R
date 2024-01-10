library(shiny)
library(shinydashboard)

grafUI <- fluidPage(
  fluidRow(
    titlePanel("Jakich słów najczęściej używamy?"),
    sliderInput("charNr",
                "Wybierz liczbe znakow",
                step = 1,
                min = 1,
                max = 20,
                value = c(4, 20)),
    sliderInput("wordsNr",
                "Wybierz liczbe slow",
                step = 1,
                min = 1,
                max = 10,
                value = 5),
                
    forceNetworkOutput("plot")
  )
)


shinyUI(
  dashboardPage(
    # dashboardHeader(title = span("Messenger",style = "color:#ff6967")),
    dashboardHeader(title = tags$a(tags$img(src="messengerLogo.png", height=40, width=40),
                                   "Messenger", style="color:white")),
    
    
    dashboardSidebar(
      sidebarMenu(
        id = 'tabs',
        
        menuItem("Z kim piszemy?", icon = icon("users"),
                 menuSubItem("Wykres1",
                             tabName = "wykres1"),
                 menuSubItem("Wykres2",
                             tabName = "wykresdrugi")
                 ),
                
        menuItem("Co piszemy?", icon = icon("comment-dots"),
                 menuSubItem("Wykres1",
                             tabName = "wykres3"),
                 menuSubItem("Wykres2",
                             tabName = "Wykres4")
                 ),
        
        menuItem("Czas", icon = icon("clock"),
                 menuSubItem("Wykres1",
                             tabName = "wykres5"),
                 menuSubItem("Wykres2",
                             tabName = "Wykres6")
                 ),
        menuItem("Cos", icon = icon("clock"), tabName = "costam"
        ),
        
        
        menuItem(selectInput("user",
                             "Wybierz osobę: ",
                             
                             c("Mateusz",
                               "Kornel",
                               "Michał"),
                             selected = 'Michał'),
                 icon = icon("user")
        )
      )
    ),
    
    dashboardBody("Body",
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
                  ),
      tabItems(
        tabItem("wykres1", grafUI),
        tabItem("wykresdrugi", h4("000000000000000000000")),
        tabItem("costam", h4("fsefswefwsefwsedfsf"))
        
       
      )
    ),
    
    
  )
)