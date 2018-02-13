library(shiny)
library(DT)
shinyUI(fluidPage(
  
  titlePanel("Slovenske občine"),
  
  tabsetPanel(
      tabPanel("Velikost družine",
               DT::dataTableOutput("druzine")),
      
      tabPanel("Število naselij",
               sidebarPanel(
                  uiOutput("pokrajine")
                ),
               mainPanel(plotOutput("naselja")))
    )
))
