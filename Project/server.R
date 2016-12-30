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



######maximum number of upload size
options(shiny.maxRequestSize=500*1024^2)
shinyServer(function(input, output,session) {
  celfiles=NULL
  celfiles.filtered=NULL
  count<-0;
  #########INput file in working directory
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
  
 ####### Input and reformat phenodata file
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
  
  observe({
    if (is.null(input$pheno)) return()
    updateTabsetPanel(session, "pa",selected = "a")
    output$phenoTable<-renderTable({filepheno()},bordered = TRUE)
    
    
  })
  
  observe({
    if (is.null(input$file)) return()
    updateTabsetPanel(session, "pa",selected = "b")
    output$fileTable<-renderTable({filedata()},bordered = TRUE)    
    
  })
  
  
  

  
  
  
  
  
  
  
  #hide tabs
  observe({
    
    #hide(selector = "#navbar li a[data-value=tabPreprocessing]")
    #hide(selector = "#navbar li a[data-value=tabGeneSelection]")
    #hide(selector = "#navbar li a[data-value=tabPlot]")
  })
  ############################################################################################################
  #button prepocesiing
  observeEvent(input$btnPrepocessing,{
 # Move to results page
    updateNavbarPage(session, "navbar", selected="tabPreprocessing")

    withProgress(message = "Status", detail = "fetching data", value = 0, {
      Sys.sleep(3)

      incProgress(0.1, detail = "Loading required library")
      library(affy)
      library(simpleaffy)
      library(RColorBrewer)
      library(affyPLM)


      incProgress(0.4, detail = "Normalising")
      celfiles <- read.affy(covdesc=input$pheno$name, path="data")
      celfiles.gcrma <- gcrma(celfiles)






      # # set colour palette


      incProgress(0.4, detail = "Plotting Boxplot ")

      cols <- brewer.pal(8, "Set1")
      # plot a boxplot of unnormalised intensity values

      output$boxPlot1 <- renderPlot({
        boxplot(celfiles, col=cols)
      })

      output$boxplot2 <- renderPlot({
        boxplot(celfiles.gcrma, col=cols)
      })
      
      
      # the boxplots are somewhat skewed by the normalisation algorithm
      # and it is often more informative to look at density plots
      # Plot a density vs log intensity histogram for the unnormalised data
      incProgress(0.7, detail = "Plotting Histogram ")

      output$histogram1 <- renderPlot({
        hist(celfiles, col=cols)
      })
      # Plot a density vs log intensity histogram for the normalised data
      output$histogram2 <- renderPlot({
        hist(celfiles.gcrma, col=cols)
      })
      
      incProgress(0.8, detail = "Plotting Quality control ")
      aqc<-qc(celfiles)
      output$qualitycontrolplot <- renderPlot({
        plot(aqc)
      })
      
      incProgress(0.8, detail = "Filtering")
      celfiles.filtered<-nsFilter(celfiles.gcrma, require.entrez=FALSE, remove.dupEntrez=FALSE)
      
    
    
    
  
    })#withprogress ends here
    
     toggle(selector = "#navbar li a[data-value=tabPreprocessing]")
     
     
   })
  ######################################button filtered data Download########################################
  observeEvent(input$btnDownloadFilteredData,
               {
                 write.table(celfiles.filtered, "Filtered.txt", sep="\t", quote=FALSE)
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
      
      toggle(selector = "#navbar li a[data-value=tabGeneSelection]")
      
    })
    
  })
  
  ############################################################################################################
  #SELECT annotation data
  x <- reactive({
    
    if(input$select == 'hgu133plus2'){
      
      library(hgu133plus2.db)
      library(annotate)
      
      
    } 
    else if(input$select == 'hgu95av2'){
     
    }
    
    
  })   
  output$state <- renderText(input$select)
  
  ############################################################################################################
  #Submit gene selection method
  r <- eventReactive(input$suBmit,{
    
    
    if(input$radio == 'SAM'){
   
    }
    if(input$radio == 'LIMMA'){
      source("https://bioconductor.org/biocLite.R")
      biocLite("hgu133plus2.db")
      
    }
    
  })
  output$lol <- renderText(input$radio)
  
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
      toggle(selector = "#navbar li a[data-value=tabPlot]")
      
    })
    
  })
  
  ####################################################################################
})
