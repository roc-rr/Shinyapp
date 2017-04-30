##Loading required libraries
library(shiny)
library(shinythemes)
library(markdown)
library(devtools)
require(rCharts)
require(DT)

shinyUI(navbarPage(
        title = "HairEyeColor Relation",
        theme = shinytheme("flatly"),
        
        # Analysis tab panel -----------------------------------
        tabPanel(title="Analysis",

   sidebarPanel(width=3,
       h3("Reactive inputs", align = "center"),
       h6("Select features to play around with data", align="center"),
       uiOutput("Sexcontrol"),
       uiOutput("Haircontrol"),
       uiOutput("Eyecontrol"),
       uiOutput("Freqcontrol")
       ),
   
   mainPanel(
      tabsetPanel(
        # Analysis2 Tab -----------------------------------------      
        tabPanel(
           p(icon("area-chart"), "Plotting"), 
           
           fluidRow(h3("Distribution of Hair and Eye color", align="center")),
           fluidRow(
                    column(8, align="center",
                           h4("Hair Color grouped By Sex", align="center"), 
                           p(showOutput("chart1", "nvd3"), align="center"))
                    ,
                    column(9, h4("Eye and Hair color relation", align="center"),
                           p(showOutput("chart2", "nvd3"), align = "center"))
                   )), # End Analysis2 Tab
                 
        tabPanel(
           p(icon("table"), "Table"),
           fluidRow(
                   column(6, h3("Filter & Download Data", align='left')),
                   column(6, downloadButton('downloadData', 'Download', class="pull-right"))    
                   ),
           hr(),
           fluidRow(
                   dataTableOutput(outputId="mytable")
                   )
                ) # End Data Tab
        )
      )
   ), # End Analysis Tab Panel       


   #About Tab Panel ------------------------------------------------------   
   tabPanel("About the App",
      mainPanel(
         includeMarkdown("info.md")
         )
   ) # End About Tab Panel
 )# End navbarPage
)# End shinyUI   