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


shinyUI(fluidPage(title="Testing", 
                  navbarPage(inverse=TRUE,title=div(img(src="3.jpg")),
                             tabPanel("Home ",helpText("Tsssesting")),
                             tabPanel("Prepocessing",helpText("Testidsadng")),
                             tabPanel("Gene Selection", helpText("Testing")),
                             tabPanel("Plot", helpText("Testiasdasng"))
                             
                  )))