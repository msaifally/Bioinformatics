#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#load the shiny package
library(shiny)
library(shinyjs)

shinyUI(fluidPage(title="Testing", useShinyjs(),
                  navbarPage(id = "navbar",inverse=TRUE,title=div(img(src="logo.jpg")),
                            #panel Home
                             tabPanel(title ="Home",actionButton("btnPrepocessing", "Prepocessing")),
                            #panel Prepocessing 
                            tabPanel(title = "Prepocessing",value= "tabPreprocessing",actionButton("btnGeneSelection", "Gene Selection")),
                            #panel Gene- Selection
                            tabPanel("Gene Selection", value = "tabGeneSelection",actionButton("btnPlot", "Plot")),
                            #Panel Plot
                             tabPanel("Plot", value = "tabPlot",actionButton("btnBack", "Back"))
                             
                  )))
