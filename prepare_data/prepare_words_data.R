library(dplyr)
library(tidytext)

df <- read.csv("combined.csv")

wd <- df %>% 
  filter(sender_name == "Michał Zajączkowski") %>% 
  unnest_tokens(word, content) %>% 
  group_by(word) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

write.csv(wd, "michalWords.csv", row.names = FALSE)
