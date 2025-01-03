
library(ellmer)
library(tidyverse)

chat <- chat_openai(
  model = "gpt-3.5-turbo", 
  system_prompt = "You are a friendly but terse assistant.")
