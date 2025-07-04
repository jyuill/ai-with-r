# Querychat for Shiny!
# copied directly from
# https://github.com/posit-dev/querychat
# detailed documentation: https://github.com/posit-dev/querychat/blob/main/pkg-r/README.md
# querychat is a drop-in component for Shiny that allows users
#  to query a data frame using natural language. 
# The results are available as a reactive data frame, 
# so they can be easily used from Shiny outputs, 
# reactive expressions, downloads, etc.


library(shiny)
library(bslib)
library(querychat) # install if needed: pak::pak("posit-dev/querychat/pkg-r")
# - includes ellmer, no need for ellmer!

# 1. CONFIGURE querychat. This is where you specify the dataset and can also
#    add/edit options like:
#    - greeting message
#    - system prompt ('extra instructions')
#    - model (uses system from ellmer)
#    - API key if needed
#    - data description
querychat_config <- querychat_init(mtcars)

ui <- page_sidebar(
  # 2. Use querychat_sidebar(id) in a bslib::page_sidebar.
  #    Alternatively, use querychat_ui(id) elsewhere if you don't want your
  #    chat interface to live in a sidebar.
  sidebar = querychat_sidebar("chat"),
  DT::DTOutput("dt")
)

server <- function(input, output, session) {

  # 3. Create a querychat object using the config from step 1.
  querychat <- querychat_server("chat", querychat_config)

  

  output$dt <- DT::renderDT({
    # 4. Use the filtered/sorted data frame anywhere you wish, via the
    #    querychat$df() reactive.
    DT::datatable(querychat$df())
  })
}

shinyApp(ui, server)