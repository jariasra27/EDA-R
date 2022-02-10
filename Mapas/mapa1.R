library(leaflet)
library(tidyverse)
library(lubridate)

accidentes <- read.csv("US_Accidents.csv")
accidentes <- accidentes[c('ID','Severity','Start_Time','End_Time',
                           'Distance.mi.','Description','State','Side',
                           'Temperature.F.','Wind_Chill.F.','Humidity...',
                           'Visibility.mi.','Wind_Speed.mph.','Precipitation.in.',
                           'Weather_Condition','Traffic_Signal','Junction',
                           'Start_Lng','Start_Lat')]
diciembre <- accidentes %>%
                na.omit() %>%
                mutate(Start_Time = ymd_hms(Start_Time),
                       Mes = month(Start_Time, label = TRUE),
                       Dia = mday(Start_Time)) %>%
                filter(Mes == "dic" & Dia == 31)
paleta <- colorNumeric(palette = "Set1", domain = diciembre$Severity)

leaflet(diciembre) %>%
  addTiles() %>%
  addCircleMarkers(~Start_Lng, ~Start_Lat, 
                   popup = paste(
                      "<b>Clima:</b>",
                     diciembre$Weather_Condition,
                     "<br><b>Severity:<b>",
                     diciembre$Severity,
                     "<br><b>Distance:</b>",
                     diciembre$Distance.mi.),
                   stroke = F, color = ~paleta(diciembre$Severity),
                   radius = ~Distance.mi.* 4,
                   fillOpacity = 0.4, clusterOptions = markerClusterOptions()) 
  
