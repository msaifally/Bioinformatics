#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinyjs)
library(R.utils)




options(shiny.maxRequestSize=500*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
  output$table <- renderTable(
    {
      
      
      if (is.null(input$file)){
        return(NULL)
      }
      untar(input$file$datapath,exdir="data")
      
      
      cels <- list.files("data/", pattern = "[gz]")
      sapply(paste("data", cels, sep="/"), gunzip)
      cels
      
      
    }
  )
  output$table1 <- renderTable(
    {
      
      
      if(is.null(input$pheno)){
        return(NULL)
      }
      
      
      
      sapply(1:nrow(input$pheno), 
             FUN=function(i) {
               file.copy(input$pheno$datapath[i], paste0("data", sep ="/",
                                                         input$pheno$name[i]))
             })
      
      read.table(file = input$pheno$datapath,sep = "|", fill=TRUE)
      
    }
  )
  
  
  #hide tabs
  observe({
    
    hide(selector = "#navbar li a[data-value=tabPreprocessing]")
    hide(selector = "#navbar li a[data-value=tabGeneSelection]")
    hide(selector = "#navbar li a[data-value=tabPlot]")
  })
  ############################################################################################################
  #button prepocesiing
  observeEvent(input$btnPrepocessing,{
    # Move to results page
    updateNavbarPage(session, "navbar", selected="tabPreprocessing")
    
    withProgress(message = "Computing results", detail = "fetching data", value = 0, {
      
      Sys.sleep(3)
      incProgress(0.5, detail = "computing results")
      # Perform lots of calculations that may take some time
      Sys.sleep(4)
      incProgress(0.5, detail = "part two")
      Sys.sleep(2)
      show(selector = "#navbar li a[data-value=tabPreprocessing]")
      
    })
    
  })
  
  ############################################################################################################
  #button geneselection
  observeEvent(input$btnGeneSelection,{
    # Move to results page
    updateNavbarPage(session, "navbar", selected="tabGeneSelection")
    
    withProgress(message = "Computing results", detail = "fetching data", value = 0, {
      
      Sys.sleep(3)
      incProgress(0.5, detail = "computing results")
      # Perform lots of calculations that may take some time
      Sys.sleep(4)
      incProgress(0.5, detail = "part two")
      Sys.sleep(2)
      
      show(selector = "#navbar li a[data-value=tabGeneSelection]")
      
    })
    
  })
  
  ############################################################################################################
  #button plot
  observeEvent(input$btnPlot,{
    # Move to results page
    updateNavbarPage(session, "navbar", selected="tabPlot")
    
    withProgress(message = "Computing results", detail = "fetching data", value = 0, {
      
      Sys.sleep(3)
      incProgress(0.5, detail = "computing results")
      # Perform lots of calculations that may take some time
      Sys.sleep(4)
      incProgress(0.5, detail = "part two")
      Sys.sleep(2)
      show(selector = "#navbar li a[data-value=tabPlot]")
      
    })
    
  })
  
  ####################################################################################
})


