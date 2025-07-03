# Initial LLM test ----
# load ellmer pkg for LLMs in R ----
library(ellmer)
library(tidyverse)

# Create new chat object ####
# - specify model, among many -> some may require API key
# - system prompt sets the tone for the conversation
# - need API key (for Open AI in this case) -> have it saved it in .Renviron
# USE models_open() to get list of available models
# - models list is regularly updated, and defaults to latest, so best to specify
client <- chat_openai(
  model = "gpt-4.1",
  system_prompt = "You are a friendly but terse assistant.")

# USAGE ----

# > Simplest ----
# - chat in console - use with prompts in R Console:
# 1. in console: live_console(chat)
# 2. at >>> add prompt > enter
# 3. answer from LLM will be displayed in console
# 4. esc when done

# > More advanced ----
# - chat in R script - use with prompts in R script:
# - use 'chat' method directly in script
# - answers appear in console
client$chat("What is the capital of France?")

prompto <- "What is the population of Edmonton, Canada?"
client$chat(prompto)

# > Extracting results ----
# info accumulates in a chat object with the same name as chat and can be accessed there
# for example: chat$last_turn() will return results from the last prompt in the chat
# - can get full conversation by running:
client
# - last answer is in chat$last_turn(); not sure how best to isolate the answer, but this seems to work:
client_last <- client$last_turn()
client_last@text
# ...or just
client$last_turn()@text
# ...or alternatively ...
client$last_turn()@contents[[1]]@text

# > Programmatic ----
# set up function to feed prompts and get response
chat_function <- function(prompt) {
  chat_prog <- chat_openai(
  model = "gpt-4.1", 
  system_prompt = "You are a friendly but terse assistant.")
  chat_prog$chat(prompt)
}

# run prompt with function - answers appear in console, not stored anywhere
prompto <- "What is the population of Vancouver, BC, Canada?"
chat_function(prompto)

# > Store results ----
city <- "Penticton, BC, Canada"
prompto <- paste("What is the population of", city, "?")
# store results: answer saved in object, also written to console
chat_results <- chat_function(prompto)

# add echo = FALSE not prevent showing in console
chat_function <- function(prompt) {
  chat_prog <- chat_openai(
    model = "gpt-4.1", 
    system_prompt = "You are a friendly but terse assistant.",
    echo = FALSE) # suppresses output in console if not needed
  chat_prog$chat(prompt)
}

pop_geo <- 'Canada'
pop_prompt <- paste("What is the population of", pop_geo, "?")
chat_results <- chat_function(pop_prompt)
chat_results

# Numbers only ----
# Design a function/system prompt for returning only raw numbers
ChatNumber <- function(prompt) {
  chat <- chat_openai(
    model = "gpt-4.1", 
    system_prompt = "You are a friendly but terse assistant. 
    For prompts that return a numerical or quantitative answer 
    please provide only the raw number in digits only, with no abbreviations, 
    no additional text.",
    echo = TRUE) # suppresses output in console if not needed
  chat$chat(prompt)
}

pop_geo <- 'Germany'
pop_prompt <- paste("What is the population of", pop_geo, "?")
chat_results <- ChatNumber(pop_prompt)