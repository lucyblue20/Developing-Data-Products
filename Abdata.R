library(dplyr)
library(ggplot2)
library(leaflet)


#load sites dataset and reduce to only sites in Northern California
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

#Reduce Abs dataset to Northern California survey sites
northAbs <- abs[abs$site %in% site.names, ]

#Replace 'NA' in Size column by median of species for that year and site
northAbs$Size[is.na(northAbs$Size)] <- with(northAbs, ave(Size, Species, year,site,
                                         FUN = function(x) median(x, na.rm = TRUE)))[is.na(northAbs$Size)]

#replace remaining'NA' due to single obs for that species with zero.

northAbs$Size[is.na(northAbs$Size)] <- 0
saveRDS(northAbs,file="data/northAbs.rds")

#Create test plot  

#Site<-"Gerstle Cove"
#selectedData<- northAbs %>%
#        filter(site==Site) %>%
#        group_by(year,Species) %>%
#        summarise(total=n(), ave.size=mean(Size), stddev=sd(Size))


#        p1<-ggplot(selectedData,aes(x=Species,y=total, fill=factor(year)))+
#             geom_bar(stat='identity',position=position_dodge(width=0.9))+
#                guides(fill=guide_legend(title="Year"))+
#                ggtitle("Abalone Counts for Selected Site")
#        p1

        








