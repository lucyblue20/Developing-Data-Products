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

# Define server code to create leaflet map and pulldowns for data
shinyServer(function(input, output) {

        output$Map1 <- renderLeaflet({
                leaflet(points) %>%
                        addTiles() %>%
                        setView(lng=-121.95000, lat=38.60000, zoom=6) %>%
                        addMarkers(~Lon, ~Lat, popup = ~site)
                         
        })
        
        # Create the data set depending on the selected survey site
        data <- reactive({
                northAbs %>%
                        filter(site == input$S) %>%
                        group_by(year,Species) %>%
                        summarise(total=n(), ave.size=mean(Size), stddev=sd(Size))
        })
        
        
        #create a plot of the total counts per species using ggplot2
        output$plot1 <- renderPlot({
                
                p1 <- ggplot(data(),aes(x=Species,y=total, fill=factor(year)))+
                        geom_bar(stat='identity',position = position_dodge(width=0.9))+
                        guides(fill=guide_legend(title="Year"))+
                        ggtitle("Total Abalone Counts for Selected Site")
                
                p1
                
        })
        
        
        #Show the selected data in table form
        output$table <- renderDataTable({
                        data()
        })
                        
        output$ref <- renderText("Data used were acquired, processed, archived, and 
                                 distributed by the Reef Check Foundation's California Program. ")
        
})

