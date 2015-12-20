library(shiny)
library(leaflet)
library(ggplot2)
library(dplyr)


#Load data files
northAbs <- readRDS("data/northAbs.rds")
points<-readRDS("data/points.rds")
points<-distinct(points)
#List of survey sites
siteNames<-unique(northAbs$site)




shinyUI(fluidPage(
        titlePanel("Abalone Counts and Sizes at Selected Sites off Northern California Coast, 2007-2011"),
               
        sidebarLayout(
                sidebarPanel(
                        h2("Survey Data"),
                        helpText("Choose a survey site from the drop down menu to create a plot of the
                                 total of each abalone species by year. Refer to the map to help select a survey 
                                 site. Click on a map marker to see the site name.  A table of the data is 
                                 created with computed average sizes for each species.  
                                 View the Plot and Table in their respective tabs.  An average size reported as 'zero'
                                 indicates the size was not obtained by the diver."),
                        selectInput('S', 'Survey Site', siteNames, selected=siteNames[[1]])),
                        
           
                
                
                mainPanel(
                        tabsetPanel(
                                tabPanel("Map", leafletOutput('Map1')),
                                tabPanel("Plot", plotOutput("plot1")),
                                tabPanel("Table", dataTableOutput('table')),
                                tabPanel("Reference", textOutput("ref"))
                        )
                                        
                        
                )
        )
)
)

