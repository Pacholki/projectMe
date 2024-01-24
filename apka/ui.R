library(shiny)
library(shinydashboard)
library(networkD3)

grafUI <- fluidPage(
  fluidRow(
    tags$div(
      tags$div(
        tags$div(
          "",
          class = "activity-status"
        ),
        "",
        class = "profile-picture"
      ),
      tags$div(
        tags$div(
          "What words are constantly longing our attention?",
          class = "title-text"
        ),
        tags$div(
          "Active now",
          class = "status-text"
        ),
        class = "title-box"
      ),
      tags$div(
        icon("phone"),
        icon("video"),
        icon("circle-info"),
        class = "icon-box fa-3x"
      ),
      class = "title-bar white-text"
    ),
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
    tags$div(
      tags$div(
        tags$div(
          "",
          class = "activity-status"
        ),
        "",
        class = "profile-picture"
      ),
      tags$div(
        tags$div(
          "When did we feel most lonely this year",
          class = "title-text"
        ),
        tags$div(
          "Active now",
          class = "status-text"
        ),
        class = "title-box"
      ),
      tags$div(
        icon("phone"),
        icon("video"),
        icon("circle-info"),
        class = "icon-box fa-3x"
      ),
      class = "title-bar white-text"
    ),
    radioButtons("time",
                 "Wybierz dla jakiej zmiennej chcesz poznać rozkład",
                 choices = c("Month", "Day Of Month", "Hour"),
                 selected = "Hour"),
    
    plotOutput("plotKiedy")
  )
)

plotZKimUI <- fluidPage(
  fluidRow(
    tags$div(
      tags$div(
        tags$div(
          "",
          class = "activity-status"
        ),
        "",
        class = "profile-picture"
      ),
      tags$div(
        tags$div(
          "These are the people that we like the most",
          class = "title-text"
        ),
        tags$div(
          "Active now",
          class = "status-text"
        ),
        class = "title-box"
      ),
      tags$div(
        icon("phone"),
        icon("video"),
        icon("circle-info"),
        class = "icon-box fa-3x"
      ),
      class = "title-bar white-text"
    ),
    radioButtons("zKim",
                 "",
                 choices = c("Groups", "People", "All"),
                 selected = "All"),
    plotlyOutput("plotZKim")
  )
)
plotOdKogoUI <- fluidPage(
  fluidRow(
    tags$div(
      tags$div(
        tags$div(
          "",
          class = "activity-status"
        ),
        "",
        class = "profile-picture"
      ),
      tags$div(
        tags$div(
          "Those people were constantly thinking about us this year",
          class = "title-text"
        ),
        tags$div(
          "Active now",
          class = "status-text"
        ),
        class = "title-box"
      ),
      tags$div(
        icon("phone"),
        icon("video"),
        icon("circle-info"),
        class = "icon-box fa-3x"
      ),
      class = "title-bar white-text"
    ),
    radioButtons("odKogo",
                 "",
                 choices = c("Groups", "People", "All"),
                 selected = "All"),
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
        menuItem("Kiedy piszemy", icon = icon("clock"), tabName = "wykres5"),
        menuItem("Co piszemy?", icon = icon("comment-dots"), tabName = "wykres3"),
        
        menuItem(selectInput("user",
                             "Wybierz osobę: ",
                             c("Mateusz",
                               "Kornel",
                               "Michał"),
                             selected = 'Kornel'),
                 icon = icon("user"),
                 class = "siema"
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
