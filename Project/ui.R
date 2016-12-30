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

shinyUI(fluidPage(title="MICROARRAY", useShinyjs(),
                  includeCSS("style.css"),
                  navbarPage(id = "navbar",inverse=TRUE,title=div(img(src="logo.jpg")),
                             #panel Home
                             tabPanel(title ="Home",icon = icon("home"),
                                      #sidebar panel
                                      sidebarPanel(id = "sidebar",
                                        fileInput("file","Input zip cel files"),
                                        fileInput("pheno","Input phenodata file")
                                      )#sidebar panel ends here.
                                      #main panel 
                                      ,mainPanel(id = "mainpanel",
                                                 h3( strong("SmArray"), "is a web-based application supporting analysis,
                                             visualization, and stratification of large genomic data, 
                                             particularly microarray data."),
                                                 img(src='rsz_myimage.jpg', align = "center"),
                                                 
                                        tabsetPanel(id="pa",
                                                    tabPanel("FILE", value="b",tableOutput("fileTable")),
                                                    tabPanel("Phenodata",value="a" ,tableOutput("phenoTable"))
                                                    
                                        )
                                      )#main panel ends here
                                      
                                      
                                      ,  tags$footer(actionButton("btnPrepocessing", "Prepocessing",class="btn-secondary",icon = icon("mail-forward")),
                                                     align = "center"
                                                    )
                                      ),#panel home ends here
                             
                             #panel Prepocessing 
                             tabPanel(title = "Prepocessing",value= "tabPreprocessing",
                                      icon = icon("cogs"),
                                      tabsetPanel(
                                        tabPanel(style = "background-color: #ffffff;",title="Boxplot","Before Normalisation",plotOutput("boxPlot1"),
                                                 tags$hr(style="color = #000000"),
                                                  "After Normalisation", plotOutput("boxplot2")),
                                        tabPanel(style = "background-color: #ffffff;",title="Histogram","Before Normalisation",plotOutput("histogram1"),
                                                 "After Normalisation", plotOutput("histogram2")),
                                        tabPanel(style = "background-color: #ffffff;",title="Quality Control","Stats",plotOutput("qualitycontrolplot"),
                                                 tags$hr(style="color = #000000"))
                                      ),
                                      tags$footer(actionButton("btnGeneSelection", "Gene Selection",class="btn-secondary",icon = icon("mail-forward")),
                                                  align = "center")
                                      ),
                             #panel Gene- Selection
                             tabPanel("Gene Selection",icon = icon("line-chart"), value = "tabGeneSelection",
                                      sidebarPanel( id = "sidebar",
                                                    h5("GENE SELECTION ANALYSIS"),
                                                    tags$hr(),
                                                    selectInput("select", h5("Annotation:"), 
                                                                
                                                                c("SELECT","hgu133plus2", "hgu95av2"),selected = "SELECT"
                                                    ),
                                                    verbatimTextOutput("state"),
                                                    tags$hr(),
                                                    radioButtons("radio", label = h5("Feature Selection method"),
                                                                 c("SAM", "LIMMA") 
                                                    ),
                                                    
                                                    verbatimTextOutput("lol"),
                                                    tags$hr(),
                                                    actionButton("suBmit","SUBMIT")
                                                    
                                      ),
                                      mainPanel(id = "mainpanel",
                                                h3("Gene Selection allows to differentially expressed genes for microarray label data"),
                                                br(),
                                                tabsetPanel(
                                                  tabPanel(title="Table","Selected genes Table",renderTable("table")),
                                                  
                                                  tabPanel(title="Heatmap","Data visualization",plotOutput("heatmap")
                                                           
                                                  )
                                                )
                                                
                                                
                                      ), tags$footer(actionButton("btnclassification", "Classification",class="btn-secondary",icon = icon("mail-forward")),
                                                     align = "center")
                                      ),
                             #Panel Plot
                             tabPanel("Classification",icon = icon("bar-chart"), value = "tabPlot",actionButton("btnBack", "Back"))
                             
                                      )))