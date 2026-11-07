# Federal Funds Matchmaker: Azure proof. Display only: no scoring, ranking or LLM.
library(shiny)
library(data.table)
library(DT)

mode <- Sys.getenv("MODE", "app")
opp <- fread("data/opportunities.csv")
n_total <- nrow(opp)
by_status <- opp[, .N, by = status]
by_status <- by_status[order(-N)]
fmt <- function(x) format(x, big.mark = ",")

# long text columns are left out of the table
show_cols <- setdiff(names(opp), c("summary", "eligibility_text"))
tbl <- as.data.frame(opp[, ..show_cols])

ui <- fluidPage(
  titlePanel("Federal Funds Matchmaker: Azure proof"),
  p(paste0("MODE = ", mode)),
  p("Display only: no scoring or ranking. Snapshot of opportunities.csv."),
  p(a(href = "/tool.html", "Open the qualifier tool (grant triage)")),
  h4(paste0("Total rows: ", fmt(n_total))),
  tags$ul(lapply(seq_len(nrow(by_status)), function(i)
    tags$li(paste0(by_status$status[i], ": ", fmt(by_status$N[i]))))),
  DTOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- renderDT(
    datatable(tbl, filter = "top", rownames = FALSE, options = list(pageLength = 10, scrollX = TRUE)),
    server = TRUE
  )
}

shinyApp(ui, server)
