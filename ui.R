library(highcharter)

shinyUI(tabsetPanel(
  tabPanel(
    "Treemap of PARV4 and other BBV prevalence in a multicentre African cohort",
    fluidPage(
      uiOutput("treemap_cohort_selection_UI"),
      uiOutput("treemap_categories_UI"),
      uiOutput("treemap_summary_UI"),
      highchartOutput("treemap_hc", height = "400px")
    )
  ),
  tabPanel("About",
           fluidPage(includeMarkdown(
             knitr::knit("tab_about.Rmd")
           ))),
  type = "tabs"
))