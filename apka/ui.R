library(shiny)
library(shinydashboard)
library(networkD3)

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

plotKiedyUI <- fluidPage(
  fluidRow(
    titlePanel("Kiedy najczęściej piszemy?"),
    radioButtons("time",
                 "Wybierz dla jakiej zmiennej chcesz poznać rozkład",
                 choices = c("Month", "Day Of Month", "Hour"),
                 selected = "Hour"),
    
    plotOutput("plotKiedy")
  )
)

plotZKimUI <- fluidPage(
  fluidRow(
    radioButtons("zKim",
                 "",
                 choices = c("Groups", "People", "All"),
                 selected = "All"),
    titlePanel("Do kogo najwięcej piszemy?"),
    plotlyOutput("plotZKim")
  )
)
plotOdKogoUI <- fluidPage(
  fluidRow(
    radioButtons("odKogo",
                 "",
                 choices = c("Groups", "People", "All"),
                 selected = "All"),
    titlePanel("Kto do nas najwięcej pisze?"),
    plotlyOutput("plotOdKogo")
  )
)

shinyUI(
  dashboardPage(
    dashboardHeader(title = tags$a(tags$img(src="messengerLogo.png", height=40, width=40),
                                   "MENELIZER", class = "white-text")),
    
    dashboardSidebar(
      sidebarMenu(
        id = 'tabs',
        
        menuItem("Z kim piszemy?", icon = icon("users"),
                 menuSubItem("Do kogo piszemy", tabName = "wykres1"),
                 menuSubItem("Kto do nas pisze", tabName = "wykres2")),
        menuItem("Ile piszemy", icon = icon("clock"), tabName = "wykres5"),
        menuItem("Co piszemy?", icon = icon("comment-dots"), tabName = "wykres3"),
        
        menuItem(selectInput("user",
                             "Wybierz osobę: ",
                             c("Mateusz",
                               "Kornel",
                               "Michał"),
                             selected = 'Michał'),
                 icon = icon("user")
        ),
        class = "fa-2x"
      )
    ),
    
    dashboardBody(tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
                  ),
      tabItems(
        tabItem("wykres3", grafUI),
        tabItem("wykres5", plotKiedyUI),
        tabItem("wykres2", plotOdKogoUI),
        tabItem("wykres1", plotZKimUI)
      )
    ),
  )
)
