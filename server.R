library(shiny)

library(dplyr)

library(leaflet)

library(DT)

shinyServer(function(input, output, session) {
    # Import Data and clean it
    
    bb_data <- read.csv("~/Documents/M2/Cours_Agro_J1_Programmation_R/archive/AB_NYC_2019.csv", stringsAsFactors = FALSE )
    bb_data <- data.frame(bb_data[1:100,]) # just 100 premiers pour pas bloquer l'ordi 
    bb_data$latitude <-  as.numeric(bb_data$latitude)
    bb_data$longitude <-  as.numeric(bb_data$longitude)
    bb_data=filter(bb_data, latitude != "NA") # removing NA values
    
    # new column for the popup label
    
    bb_data <- mutate(bb_data, cntnt=paste0('<strong>Name: </strong>',host_name,
                                            '<br><strong>Quartier:</strong> ', neighbourhood_group,
                                            '<br><strong>Prix par nuit:</strong> ', price)) 
    
    # create a color paletter for category type in the data file
    pal <- colorFactor(pal = c("#1b9e77", "#d95f02"), domain = c("Brooklyn", "Manhattan")) # changer couleurs et nom de groupes
    
    # create the leaflet map  
    output$bbmap <- renderLeaflet({
        leaflet(bb_data) %>% 
            addCircles(lng = ~longitude, lat = ~latitude) %>% 
            addTiles() %>%
            addCircleMarkers(data = bb_data, lat =  ~latitude, lng =~longitude, 
                             radius = 3, popup = ~as.character(cntnt), 
                             color = ~pal(neighbourhood_group),
                             stroke = FALSE, fillOpacity = 0.8)%>%
            addLegend(pal=pal, values=bb_data$host_name,opacity=1, na.label = "Not Available")%>%
            addEasyButton(easyButton(
                icon="fa-crosshairs", title="ME",
                onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
    })
    
    output$picture <-
        renderText({
            c('<img src="',
                "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.airbnb.fr%2Fd%2Fonlinehost&psig=AOvVaw3EZTjMkc-dIATykAqbk3wf&ust=1600939819917000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMD0qd37_usCFQAAAAAdAAAAABAD",
                '">'            )
        })
    
    #create a data object to display data
    
    output$data <-DT::renderDataTable(datatable(
        bb_data[,c(10)],filter = 'top',
        colnames = c("id", "name", "host_id", "host_name", "neighbourhood_group", "neighbourhood","latitude",
                     "longitude","room_type","price","minimum_nights", "number_of_reviews","last_review", "reviews_per_month",
                     "calculated_host_listings_count", "availability_365")
    ))
    
    
})
