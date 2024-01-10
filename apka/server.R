library(shiny)
library(dplyr)
library(networkD3)


words_Michal <- read.csv("michalWords.csv")


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
      fontSize = 12, 
    )
    
    htmlwidgets::onRender(
      forceGraph,
      'function(el, x) {
        d3.selectAll(".node text").style("fill", "black");
      }'
    )

  })
})
