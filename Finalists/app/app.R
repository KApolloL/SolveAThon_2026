# Federal Funds Matchmaker: Azure hello skeleton.
# MODE=app serves the Shiny page; MODE=job is a stub for the daily refresh.
library(shiny)

mode <- Sys.getenv("MODE", "app")

if (mode == "job") {
  message("MODE=job: refresh stub ran at ", format(Sys.time(), tz = "UTC"), " UTC")
  quit(save = "no", status = 0)
}

ui <- fluidPage(
  titlePanel("Federal Funds Matchmaker: hello from Azure"),
  p("MODE = ", strong(mode)),
  p("Skeleton only. No data, scoring or AI yet.")
)

server <- function(input, output, session) {}

shinyApp(ui, server)
