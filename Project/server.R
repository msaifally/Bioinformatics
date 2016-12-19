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
shinyServer(function(input, output,session) {
  
  
  filedata <- reactive({
    infile <- input$file
    if (is.null(infile)){
      return(NULL)      
    }
    
    untar(input$file$datapath,exdir="data")
    cels <- list.files("data/", pattern = "[gz]")
    sapply(paste("data", cels, sep="/"), gunzip)
    celfiles<-cels
     
  })
  output$fileTable<-renderTable({filedata()})
  
  filepheno <- reactive({
    infile <- input$pheno
    if (is.null(infile)){
      return(NULL)      
    }
    
    sapply(1:nrow(input$pheno), 
                      FUN=function(i) {
                       file.copy(input$pheno$datapath[i], paste0("data", sep ="/",
                                                                   input$pheno$name[i]))
                      })
               
               read.table(file = input$pheno$datapath,sep = "", fill=TRUE)
               
               
    
  })
  output$phenoTable<-renderTable({filepheno()},bordered = TRUE)

  output$ui.action <- renderUI({
    if (is.null(input$file) || is.null(input$pheno) ) return()
    actionButton("btnPrepocessing", "Prepocessing",class="btn-info",icon = icon("mail-forward"))
  })

  
  # observe({
  # 
  #   if (!is.null(input$file) && !is.null(input$pheno) )
  # 
  #   {
  #     library(simpleaffy)
  #     celfiles
  #     celfiles <- read.affy(covdesc="phenodata.txt", path="data")
  #     celfiles.gcrma <- gcrma(celfiles)
  #     library(RColorBrewer)
  #     # set colour palette
  #     cols <- brewer.pal(8, "Set1")
  #     # plot a boxplot of unnormalised intensity values
  # 
  #     output$mpgPlot <- renderPlot({
  #       boxplot(celfiles, col=cols)
  #     })
  # 
  #   }
  # })
 
      
  
  
  
  #plot a boxplot of normalised intensity values, affyPLM is required to interrogate celfiles.gcrma
  #library(affyPLM)
  #boxplot(celfiles.gcrma, col=cols)
  # the boxplots are somewhat skewed by the normalisation algorithm
  # and it is often more informative to look at density plots
  # Plot a density vs log intensity histogram for the unnormalised data
  #hist(celfiles, col=cols)
  #Plot a density vs log intensity histogram for the normalised data
  #hist(celfiles.gcrma, col=cols)
  
  
  
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


