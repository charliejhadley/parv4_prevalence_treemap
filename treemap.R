make_truth_table <- function(data, columns) {
  grp_tally <- data %>%
    group_by_(.dots = columns)  %>%
    count() %>%
    ungroup()
  
  measure_columns <- select_if(grp_tally, is.character) %>%
    colnames()
  
  
  lbls <- as.character()
  for (i in 1:nrow(grp_tally)) {
    lbls <-
      append(lbls, paste(unlist(grp_tally[i, measure_columns], use.names = F), collapse = " <br> "))
  }
  
  grp_tally["label"] = lbls
  
  grp_tally
  
}

output$treemap_cohort_selection_UI <- renderUI({
  checkboxGroupInput(
    "treemap_cohort_selection",
    label = "Which cohorts should be included in the sample?",
    choices = unique(philippa_data$cohort.location),
    selected = unique(philippa_data$cohort.location),
    inline = TRUE
  )
})

output$treemap_categories_UI <- renderUI({
  checkboxGroupInput(
    "treemap_categories",
    label = "How should we split up the data?",
    choices = list(
      "sex" = "sex",
      "Adult or child" = "adult.child",
      "HIV status" = "hiv.status",
      "HBsAg status" = "hbsag.status",
      "HCV RNA status" = "hcv.rna.status",
      "PARV4 IgG" = "parv4.igg.status",
      "PARV4 DNA" = "parv4.dna.status"
    ),
    selected = c("hbsag.status", "parv4.igg.status"),
    inline = TRUE
  )
})

output$treemap_hc <- renderHighchart({
  
  if(is.null(input$treemap_cohort_selection)){
    return()
  }
  
  if(is.null(input$treemap_categories)){
    return()
  }
  
  philippa_data %>%
    filter(cohort.location %in% input$treemap_cohort_selection) %>%
    select(one_of(input$treemap_categories)) %>%
    na.omit() %>%
    make_truth_table(columns = input$treemap_categories) %>%
    hchart("treemap",
           hcaes(
             value = n,
             colorValue = n,
             name = label
           )) %>%
    hc_colorAxis(minColor = '#FFFFFF',
                 maxColor = JS("Highcharts.getOptions().colors[0]")) %>%
    hc_tooltip(
      formatter = JS(
        "function(){
        console.log(this);
        return this.point.label + 
        '<br/>' + 
        'Number of individuals: ' + this.point.value;
        }"
        
      ))
})

output$treemap_summary_UI <- renderUI({
  wellPanel(
      "There are",
      philippa_data %>%
        filter(cohort.location %in% input$treemap_cohort_selection) %>%
        select(one_of(input$treemap_categories)) %>%
        na.omit() %>%
        nrow(),
      "individuals in the currently selected sample.",
      br(),
      "Note that",
      philippa_data %>%
        filter(cohort.location %in% input$treemap_cohort_selection) %>%
        select(one_of(input$treemap_categories)) %>%
        data.table::as.data.table() %>%
        na.omit(invert = TRUE) %>%
        nrow(),
      "observations have been ommitted from the treemap below as they contain missing or indeterminate data.",
      br(),
      "Hover your cursor over the chart below for more information about each group."
  )
})
