require(rCharts)
options(RCHART_LIB = 'polycharts')

shinyUI(pageWithSidebar(
  headerPanel("Fantasy Football Rankings Visualization App"),
  
  sidebarPanel(
    selectInput(inputId = "position",
                label = "Select a category/position of interest",
                choices = pos,
                selected = pos[1])
  ),
  
  mainPanel(
    showOutput("chart1", "polycharts")
    #verbatimTextOutput("check")
  )
))