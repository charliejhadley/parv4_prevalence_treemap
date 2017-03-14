library(tidyverse)
library(highcharter)
library(data.table)
library(rfigshare)

source("data-processing.R", local = TRUE)

shinyServer(function(input, output, session) {
  source("treemap.R", local = TRUE)
  
  observeEvent(
    c(input$treemap_cohort_selection),
    {
      if (is.null(input$treemap_cohort_selection))
      {
        updateCheckboxGroupInput(session, "treemap_cohort_selection", selected = "Gaborone, Botswana")
      }
    },
    ignoreNULL = FALSE,
    ignoreInit = TRUE
  )
  
  observeEvent(c(input$treemap_categories),
               {
                 if (is.null(input$treemap_categories))
                 {
                   updateCheckboxGroupInput(session, "treemap_categories", selected = "hiv.status")
                 }
               },
               ignoreNULL = FALSE,
               ignoreInit = TRUE)
  
  
})