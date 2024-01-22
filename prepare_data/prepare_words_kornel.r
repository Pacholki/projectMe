library(dplyr)
library(tidytext)

df <- read.csv("csv_data/combined.csv")

wd <- df %>% 
  filter(sender_name == "Kornel Tłaczała") %>% 
  unnest_tokens(word, content) %>% 
  group_by(word) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

write.csv(wd, "kornelWords.csv", row.names = FALSE)