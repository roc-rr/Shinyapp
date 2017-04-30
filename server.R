##Loading required libraries
library(shiny)
library(dplyr)
library(datasets)
require(rCharts)
require(DT)

##Defining inputs
hec <- as.data.frame(HairEyeColor)
sexlist <- c("Female", "Male")
allhair <- c('Black','Brown','Red','Blond')
alleyes <- sort(unique(hec$Eye))
FreqMax <- max(hec$Freq)
FreqMin <- min(hec$Freq)


shinyServer(function(input, output) {
    ##Reactive inputs
    output$Sexcontrol <- renderUI({
            checkboxGroupInput("sex", "Select Sex", 
                               choices = sexlist, selected = sexlist)
    })        
        
    output$Haircontrol <- renderUI({
            checkboxGroupInput('allhair', label = "Choose hair color",
                        choices = allhair, selected = allhair)
    }) 
    
    output$Eyecontrol <- renderUI({
            checkboxGroupInput('alleyes', label = "Choose eye color",
                               choices = alleyes, selected = alleyes)
    }) 
    
    output$Freqcontrol <- renderUI({
                sliderInput(inputId = "freq", 
                            label   = "Frequency", 
                            min     = FreqMin, 
                            max     = FreqMax, 
                            step    = 2,
                            value   = c(FreqMin, FreqMax),
                            ticks   = T,
                            sep     = "")
    })
    
    ## Reactive data
    hec.filtered <- reactive({ 
                    hec %>%
                    filter(Freq >= input$freq[1],
                           Freq <= input$freq[2],
                           Sex %in% input$sex,
                           Hair %in% input$allhair,
                           Eye %in% input$alleyes)
            
    })
    
    HairBySex <- reactive({
                    hec.filtered() %>%
                    group_by(Sex, Hair) %>%
                    summarize(totalfreq = sum(Freq))
    })            
    
    EyesByHair <- reactive({
                    hec.filtered() %>%
                    group_by(Hair, Eye) %>%
                    summarize(totalfreq = sum(Freq))
    }) 
    
    #Plotting with rCharts
    #Hair Color by Sex
    output$chart1 <- renderChart({ 
      
        p1  <- nPlot(
                    totalfreq ~ Hair,
                    group = "Sex",
                    data = HairBySex(),
                    type = "multiBarChart",
                    dom = "chart1",
                    width = 600)
        p1$chart(margin = list(left = 100))
        p1$yAxis(axisLabel = "Frequency", width = 80)
        p1$xAxis(axisLabel = "Hair color", width = 70)
        p1$chart(color=rainbow(4))
        p1$chart(stacked = T)
        return(p1)
    })            
    
    #Eyes Color by Sex  
    output$chart2 <- renderChart({ 
            
            p2  <- nPlot(
                    totalfreq ~ Hair,
                    group = "Eye",
                    data = EyesByHair(),
                    type = "multiBarHorizontalChart",
                    dom = "chart2",
                    width = 600)
            p2$yAxis(axisLabel = "Frequency", width = 80)
            p2$chart(stacked = T)
            return(p2)
    })     
    
    output$mytable <- DT::renderDataTable({hec.filtered()},
                                     options = list(searching = FALSE,
                                                    pageLength = 15))

    output$downloadData <- downloadHandler(
            filename = function() {
                    paste0('data_', Sys.Date(), '.csv')
            },
            content = function(file) {
                    write.csv(hec.filtered(), file, row.names=FALSE)
            }
    )
    
})

    