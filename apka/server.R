library(shiny)
library(dplyr)
library(networkD3)
library(lubridate)
library(ggplot2)
library(tidytext)
library(stringi)
library(plotly)


words_Michal <- read.csv("michalWords.csv")
words_Mateusz <- read.csv("mateuszWords.csv")
words_Kornel <- read.csv("kornelWords.csv")
data_Mateusz <- read.csv("mateuszCombinedNoContent.csv")
data_Michal <- read.csv("michalCombinedNoContent.csv")
data_Kornel <- read.csv("kornelCombinedNoContent.csv")


shinyServer(function(input, output, session){
  # po tym reactive pracujemy na data i word_data jak na normalnych 
  # ramkach tylko trzeba pisac data() - z nawiasami
  data <- reactive({
    if(input$user == "Mateusz") {
      data_Mateusz
    }
    else if(input$user == "Kornel") {
      data_Kornel
    }
    else {
      data_Michal
    }
  })
  
  word_data <- reactive({
    if(input$user == "Mateusz") {
      words_Mateusz
    }
    else if(input$user == "Kornel") {
      words_Kornel
    }
    else {
      words_Michal
    }
  })
    
  # pierwszy wykres
  output$plot <- renderForceNetwork({
    df <- word_data() %>%
      filter(nchar(word) %in% input$charNr)
    
    df2 <- df %>% 
      arrange(desc(count)) %>% 
      head(input$wordsNr)

    Links <- data.frame(
      source = rep(0, nrow(df2)),  # Źródło krawędzi
      target = 1:nrow(df2),        # Cel krawędzi
      value = df2$count             # Wartość (liczba wystąpień słowa)
    )
    
    # Tworzenie węzłów (Nodes) - użyj kolumny word jako nazwy węzłów
    Nodes <- data.frame(
      name = c(input$user, df2$word),     # Nazwy węzłów
      size = c(20, df2$count*5),   # Rozmiar węzłów
      group = c(0, rep(1, nrow(df2)))  # Grupa węzłów
      # group = c(" ", word_data$count)
    )

    # Skala kolorów
    ColourScale <- 'd3.scaleOrdinal()
            .domain(["me", "Word Group"])
            .range(["#213423", "#ff0050"]);'
    
    # Tworzenie grafu siłowego
    forceGraph <- forceNetwork(
      Links = Links,
      Nodes = Nodes,
      Source = "source",
      Target = "target",
      Value = "value",
      NodeID = "name",
      Group = "group",
      opacity = 1,
      zoom = TRUE,
      Nodesize = "size",
      linkDistance = 100,
      linkWidth = 2,
      charge = -200,
      opacityNoHover = 1,
      legend = TRUE,
      fontFamily = "Arial",
      fontSize = 12
    )
    
    htmlwidgets::onRender(
      forceGraph,
      'function(el, x) {
        d3.selectAll(".node text").style("fill", "black");
      }'
    )

  })
  
  #drugi wykres
  output$plotKiedy <- renderPlot({
    
    df <- data() %>%
      mutate(timestamp =  as.POSIXct(timestamp / 1000, origin="1970-01-01"))%>%
      filter(sender_name == ifelse(input$user == "Mateusz", "Mati Deptuch", ifelse(input$user == "Kornel", "Kornel Tłaczała", "Michał Zajączkowski"))) %>%
      mutate(Date = as.Date(timestamp),
             Time = format(timestamp, "%H:%M:%Y"),
             Hour = hour(timestamp),
             Month = month(timestamp),
             Day = day(timestamp))
    
    if(input$time == "Hour"){
      plotdata <- df %>% 
        group_by(Hour) %>% 
        summarise(n = n())
      plotdata$n <- plotdata$n / 365
      
    p <- ggplot(plotdata, aes(x = Hour, y = n)) + 
      geom_col(fill = "#0594ff")+
      labs(x = "Hour", y = "Average Number of Sent Messages") +
      scale_x_continuous(breaks = seq(0, 23, 1))
    }
    if(input$time == "Day Of Month"){
      plotdata <- df %>% 
        group_by(Day) %>% 
        summarise(n = n())
      plotdata$n <- plotdata$n / 12
      p <- ggplot(plotdata, aes(x = Day, y = n)) + 
        geom_col(fill = "#0594ff")+
        labs(x = "Day Of Month", y = "Average Number of Sent Messages") +
        scale_x_continuous(breaks = seq(1, 31, 1))
    }
    if(input$time == "Month"){
      p <- ggplot(df, aes(x = factor(Month)))+ 
        geom_bar(fill = "#0594ff")+
        labs(x = "Month", y = "Number of Sent Messages") + 
        scale_x_discrete(name = "Month", labels = month.abb) 
    }
    p + theme(
      plot.background = element_rect(fill = "transparent"),
      panel.background = element_rect(fill = "transparent"),
      axis.text = element_text( size = rel(1.5), family = "Helvetica Neue"),
      axis.title = element_text( size = rel(1.5), family = "Helvetica Neue"))
    
    
  })
  
  #kolejny wykres
  # output$plotGrupy <- renderPlot({
  #   data() %>% 
  #     filter(sender_name == ifelse(input$user == "Mateusz", "Mati Deptuch", ifelse(input$user == "Kornel", "Kornel Tłaczała", "Michał Zajączkowski"))) %>% 
  #     group_by(is_group) %>% 
  #     summarise(n = n()) %>% 
  #     mutate(is_group = ifelse(is_group == "False", "Not in Groups", "In Groups")) %>%
  #     ggplot(aes(x = is_group, y= n))+
  #     geom_col(fill = "#0594ff") +
  #     labs(x = "",
  #          y = "Number of Messages")+
  #     theme(
  #            plot.background = element_rect(fill = "transparent"),
  #            panel.background = element_rect(fill = "transparent"),
  #            axis.text = element_text( size = rel(1.5), family = "Arial Black"),
  #            axis.title = element_text( size = rel(1.5), family = "Arial Black"))
  # })
  
  #i nastepny, do kogo najwiecej
output$plotZKim <- renderPlot({
  who <- case_when(
    input$zKim == "Groups" ~ c("True"),
    input$zKim == "People" ~ c("False"),
    input$zKim == "All" ~ c("True", "False")
  )
  
  plotdata <- data() %>%
    filter(
      sender_name == ifelse(
        input$user == "Mateusz", "Mati Deptuch",
        ifelse(input$user == "Kornel", "Kornel Tłaczała", "Michał Zajączkowski")
      )
    ) %>% 
    filter(is_group %in% who)%>%
    group_by(receiver_name) %>%
    summarise(n = n()) %>%
    arrange(desc(n)) %>%
    head(10)
  
  ggplot(plotdata, aes(x = reorder(receiver_name, n), y = n)) +
    geom_col(fill ="#0594ff" ) +
    coord_flip() +
    theme(
      plot.background = element_rect(fill = "transparent"),
      panel.background = element_rect(fill = "transparent"),
      axis.text = element_text( size = rel(1.5), family = "Arial Black"),
      axis.title = element_text( size = rel(1.5), family = "Arial Black")) +
    labs(x = "Person/Group Name",
         y = "Number of sent messages")
})

output$plotOdKogo <- renderPlot({
  who <- case_when(
    input$odKogo == "Groups" ~ c("True"),
    input$odKogo == "People" ~ c("False"),
    input$odKogo == "All" ~ c("True", "False")
  )
  
  plotdata <- data() %>%
    filter(
      sender_name != ifelse(
        input$user == "Mateusz", "Mati Deptuch",
        ifelse(input$user == "Kornel", "Kornel Tłaczała", "Michał Zajączkowski")
      )
    ) %>% 
    filter(is_group %in% who)%>%
    group_by(sender_name) %>%
    summarise(n = n()) %>%
    arrange(desc(n)) %>%
    head(10)
  
  ggplot(plotdata, aes(x = reorder(sender_name, n), y = n)) +
    geom_col(fill ="#0594ff" ) +
    coord_flip() +
    theme(
      plot.background = element_rect(fill = "transparent"),
      panel.background = element_rect(fill = "transparent"),
      axis.text = element_text( size = rel(1.5), family = "Arial Black"),
      axis.title = element_text( size = rel(1.5), family = "Arial Black")) +
    labs(x = "Person/Group Name",
         y = "Number of sent messages")
})
  
})
