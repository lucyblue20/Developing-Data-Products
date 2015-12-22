library(dplyr)
library(ggplot2)
library(leaflet)
library(rCharts)

#load sites dataset and reduce to only sites in Monterey County
sites<-read.csv("RCCA_SITES.csv",header=TRUE,stringsAsFactors = TRUE, 
                na.strings = c("NA", "#DIV/0!", ""))

northsites<-sites %>%
        filter(Lat > 36.00000, Lat < 40.00000)
site.names<-unique(northsites$site)

#create dataset of sites with respective latitude and longitude coordinates
points<-northsites %>%
        select(site,Lat,Lon)
points<-distinct(points)

saveRDS(points,file="data/points.rds")


#load abalone data
abs<-read.csv("RCCA_ABALONE.csv",header=TRUE,stringsAsFactors = TRUE, 
                na.strings = c("NA", "#DIV/0!", ""))
abs$site<-as.character(abs$site)

#Reduce Abs dataset to Monterey survey sites
northAbs <- abs[abs$site %in% site.names, ]
northAbs$Size[is.na(northAbs$Size)] <- with(northAbs, ave(Size, Species, year,site,
                                          FUN = function(x) median(x, na.rm = TRUE)))[is.na(northAbs$Size)]
northAbs$Size[is.na(northAbs$Size)] <- 0
saveRDS(northAbs,file="data/northAbs.rds")

#calculate totals per Species per year for each survey site
totalAbs<- northAbs %>%
        group_by(site,year,Species) %>%
        summarise(total=n())
totalAbs$year<-as.factor(totalAbs$year)
saveRDS(totalAbs,file="data/totalAbs.rds")

#Create plot test code

Site<-"Gerstle Cove"
selectedData<- northAbs %>%
        filter(site==Site) %>%
        group_by(year,Species) %>%
        summarise(total=n(), ave.size=mean(Size), stddev=sd(Size))

selectedData<-selectedData %>%
        
selectedData$ave.size<-round(selectedData$ave.size,2)
selectedData$stddev<-round(selectedData$stddev,2)


      
        p1<-ggplot(selectedData,aes(x=Species,y=total, fill=factor(year)))+
             geom_bar(stat='identity',position=position_dodge(width=0.9))+
                guides(fill=guide_legend(title="Year"))+
                ggtitle("Abalone Counts for Selected Site")
        p1

        

#Create map test code
map<-Leaflet$new() 
        map$setView(c(36.60000,-121.95000), zoom=6) 
        for (i in 1:nrow(points)) {
                map$marker(c(points[i, "Lat"], points[i, "Lon"]), bindPopup = points[i, "site"])
        }
map







