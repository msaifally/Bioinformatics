#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(R.utils)

shinyUI(fluidPage(title="Testing", useShinyjs(),
                  navbarPage(id = "navbar",inverse=TRUE,title=div(img(src="logo.jpg")),
                             #panel Home
                             tabPanel(title ="Home",
                                      #sidebar panel
                                      sidebarPanel(
                                        fileInput("file","Input zip cel files"),
                                        fileInput("pheno","Input phenodata file")
                                      )#sidebar panel ends here.
                                      #main panel 
                                      ,mainPanel(
                                        tabsetPanel(id="pa",
                                                    tabPanel("FILE", value="b",tableOutput("fileTable")),
                                                    tabPanel("Phenodata",value="a" ,tableOutput("phenoTable"))

                                        )
                                      )#main panel ends here
                                      
                                      
                                      ,  tags$footer(actionButton("btnPrepocessing", "Prepocessing",class="btn-info",icon = icon("mail-forward")),
                                                     align = "center", 
                                                     style = "position:absolute;
                                                     bottom:0;
                                                     width:100%;
                                                     height:50px;   /* Height of the footer */
                                                     color: white;
                                                     padding: 10px;
                                                     background-color: white;
                                                     z-index: 1000;")
                                      ),#panel home ends here
                             
                             #panel Prepocessing 
                             tabPanel(title = "Prepocessing",value= "tabPreprocessing",actionButton("btnGeneSelection", "Gene Selection"),
                                      tabsetPanel(
                                        tabPanel(title="Boxplot","Before Normalisation",plotOutput("boxPlot1"),
                                                 "After Normalisation", plotOutput("boxplot2")),
                                        tabPanel(title="Histogram","Before Normalisation",plotOutput("histogram1"),
                                                 "After Normalisation", plotOutput("histogram2"))
                                      )),
                             #panel Gene- Selection
                             tabPanel("Gene Selection", value = "tabGeneSelection",actionButton("btnPlot", "Plot")),
                             #Panel Plot
                             tabPanel("Plot", value = "tabPlot",actionButton("btnBack", "Back"))
                             
                                      )))