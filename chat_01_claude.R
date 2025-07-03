# Initial LLM test ----
# same as chat_01.R except using Claude model
# load ellmer pkg for LLMs in R ----
library(ellmer)
library(tidyverse)

# Create new chat object ####
# - specify model, among many -> some may require API key
# - system prompt sets the tone for the conversation
# - need API key (for Anthropic in this case) -> have it saved it in .Renviron
# USE models_anthropic() to get list of available models
# - models list is regularly updated, and defaults to latest, so best to specify
client <- chat_anthropic(
  model = "claude-3-5-haiku-20241022",
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

# prompt in variable
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
  chat_prog <- chat_anthropic(
  model = "claude-3-5-haiku-20241022", 
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
  chat_prog <- chat_anthropic(
    model = "claude-3-5-haiku-20241022", 
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
  chat <- chat_anthropic(
    model = "claude-3-5-haiku-20241022", 
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

pop_geo <- 'France'
pop_prompt <- paste("What is the population of", pop_geo, "?")
chat_results <- ChatNumber(pop_prompt)

pop_geo <- 'Italy'
pop_prompt <- paste("What is the population of", pop_geo, "?")
chat_results <- ChatNumber(pop_prompt)

pop_geo <- 'Spain'
pop_prompt <- paste("What is the population of", pop_geo, "?")
chat_results <- ChatNumber(pop_prompt)

# Better way to retain conversation

client_n <- chat_anthropic(
  model = "claude-3-5-haiku-20241022",
  system_prompt = "You are a friendly but terse assistant. 
    For prompts that return a numerical or quantitative answer 
    please provide only the raw number in digits only, with no abbreviations, 
    no additional text.",
  echo = TRUE) # suppresses output in console if not needed

pop_prompt <- function(pop_geo) {
  pop_prompt <- paste("What is the population of", pop_geo, "?")
}

pop_geo <- 'Germany'
client_n$chat(pop_prompt(pop_geo))

pop_geo <- 'France'
client_n$chat(pop_prompt(pop_geo))

client_n
client_n$last_turn()
# shows all turns, numbered as:
#   [[odd number]] = questions
#   [[even number]] = answers
client_n$get_turns()
client_n$get_turns()[[1]]@contents[[1]]@text # question 1 prompt
client_n$get_turns()[[2]]@text # answer to question 1
client_n$get_turns()[[3]]@contents # second prompt with text object
client_n$get_turns()[[4]]@contents[[1]]@text # answer to second prompt
client_n$get_turns()[[4]]@text # answer to second prompt
