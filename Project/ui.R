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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  #theme = "bootstrapfile:///C:/Users/user/Desktop/R-github/Bioinformatics/Project/www/bootstrap-3.3.7-dist/css/bootstrap.css",
  
includeCSS("style.css"),
                  
  headerPanel("SM ARRAY"),
  # Application title
  
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel( id = "sidebar" ,
       img(src="yas.jpg", height = 300, width = 265)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(id= "main-panel",
      tabsetPanel(
        tabPanel("Home","Shiny is a free web app which allows to perform gene selection"),
        tabPanel("Preprocessing"),
        tabPanel("Gene Selection"),
        tabPanel("Output")
        )
        
    )
  )
))
