library(leaflet)
library(tidyverse)
library(geojsonio)

accidentes <- read.csv("US_Accidents.csv")
accidentes <- accidentes[c('ID','Severity','Start_Time','End_Time',
                           'Distance.mi.','Description','State','Side',
                           'Temperature.F.','Wind_Chill.F.','Humidity...',
                           'Visibility.mi.','Wind_Speed.mph.','Precipitation.in.',
                           'Weather_Condition','Traffic_Signal','Junction')]
acc_estado <- accidentes  %>%
                na.omit() %>%
                group_by(State) %>%
                summarise(Total = n())
estados <- geojson_read("USA_States.geojson", what = "sp")
estados_info <- sp::merge(estados, acc_estado, by.x = "STATE_ABBR", by.y="State")
paleta <- colorNumeric(palette = "YlOrBr", domain = estados_info$Total)

leaflet(estados_info) %>%
  setView(lng = -95.712891, lat = 37.09024, zoom = 3) %>%
  addTiles() %>%
  addPolygons(fillColor = ~paleta(Total),
              weight = 1,
              opacity = 1,
              color = "black",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 2,
                fillOpacity = 1
              ),
              label = sprintf("<strong>%s</strong><br/>Total de Accidentes: %g",
                              estados_info$STATE_NAME,estados_info$Total)%>%
              lapply(htmltools::HTML)) %>%
  addLegend(pal = paleta, values = estados_info$Total)