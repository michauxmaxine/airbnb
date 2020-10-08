library(shiny)

library(dplyr)

library(leaflet)

library(DT)

library(data.table)

library("RColorBrewer")

library(shinyWidgets)
shinyServer(function(input, output, session) {
    # Etape 1 : nettoyage des données
    
            bb_data <- read.csv("~/Documents/M2/Cours_Agro_J1_Programmation_R/archive/AB_NYC_2019.csv", stringsAsFactors = FALSE )
            bb_data$latitude <-  as.numeric(bb_data$latitude)
            bb_data$longitude <-  as.numeric(bb_data$longitude)
            bb_data=filter(bb_data, latitude != "NA") # removing NA values
           
            # vérification que les prix sont strictement supérieur à 0
            price_zero=bb_data[(which(bb_data$price==0)),]
            price_zero
            
            # apres verif des prix sur airbnb correction
            bb_data[25434,10] <- 55
            bb_data[25795,10] <- 40
            bb_data[25796,10] <- 35
            bb_data[25797,10] <- 40
            
            #pour ceux qui ne sont pas corrigibles suppression
            bb_data <- bb_data[-c(23162,25635,25754,25779,26260,26842,26867),]
            
            # just 100 premiers pour pas bloquer l'ordi 
            bb_data <- data.frame(bb_data[1:100,]) 
            
            # Etiquette qui s'affiche qd on clique sur un point de la carte
            
            bb_data <- mutate(bb_data, cntnt=paste0('<strong>Name: </strong>',host_name,
                                                    '<br><strong>Quartier:</strong> ', neighbourhood_group,
                                                    '<br><strong>Prix par nuit:</strong> ', price)) 
            
            # create a color paletter for category type in the data file
            pal <- colorFactor(pal = c("#330033", "#33FF00", "#FF6600", "#990000", "#33FFFF"), domain = c("Brooklyn", "Manhattan", "Bronx", "Queens","Staten Island")) 
            
    # CARTE 
            #Sélection
            output$selected_var <- renderText({ 
                paste("You have selected", input$var)
            })
            pickerInput("level_select", "Level:",   
                        choices =bb_data$neighbourhood_group, 
                        selected = c("Bronx"),
                        multiple = FALSE)
            #MAP
            output$bbmap <- renderLeaflet({
                leaflet(bb_data) %>% 
                    addCircles(lng = ~longitude, lat = ~latitude) %>% 
                    addTiles() %>%
                    addCircleMarkers(data = bb_data, lat =  ~latitude, lng =~longitude, 
                                     radius = 3, popup = ~as.character(cntnt), 
                                     color = ~pal(neighbourhood_group),
                                     stroke = FALSE, fillOpacity = 0.8)%>%
                    addLegend(pal=pal, values=input$var,opacity=1, na.label = "Not Available")%>%
                    addEasyButton(easyButton(
                        icon="fa-crosshairs", title="ME",
                        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
            })
    
    
    #VISUALISATION DU JEU
    
        output$data <-DT::renderDataTable(datatable(
            bb_data[,c(10,11)],filter = 'top',
            colnames = c("id", "name", "host_id", "host_name", "neighbourhood_group", "neighbourhood","latitude",
                         "longitude","room_type","price","minimum_nights", "number_of_reviews","last_review", "reviews_per_month",
                         "calculated_host_listings_count", "availability_365")
        ))
        
      # VISUALISATION DU DIAGRAMME TYPE DE CHAMBRE PAR QUARTIERS
        output$graph <- renderPlotly({
            
            airbnb <- fread("~/Documents/M2/Cours_Agro_J1_Programmation_R/archive/AB_NYC_2019.csv")
            airbnb <-airbnb[1:100]
            entire_room <- (airbnb[room_type == "Entire home/apt", .N])
            private_room <- (airbnb[room_type == "Private room", .N])
            shared_room <- airbnb[room_type == "Shared room", .N]
            stats <- airbnb[, list("room-entier" = mean(entire_room),
                                   "chbr_privee" = mean(private_room), "chambre partagee" = mean(shared_room)), by = neighbourhood_group]
            
            fig <- plot_ly(stats, x = airbnb$neighbourhood_group, y = entire_room, type = 'bar', name = 'entire room', marker = list(color ="FF99CC"))
            fig <- fig %>% add_trace(y = private_room, name = 'private room',marker = list(color = "#900033"))
            fig <- fig %>% add_trace(y = shared_room, name = 'shared room',marker = list(color = "#FF0000"))
            fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'stack')
            fig
                })
        
        output$graph_price <- renderPlotly({
                    count_ <- (airbnb[, .N])
                    fig_price <-plot_ly(airbnb, x=bb_data$price,y=count_, type = "bar",color = "#900033 ")
                    suppressWarnings(print(fig_price))
                    
                 })
        
        output$graph_nb_hote <- renderPlotly({
            count_ <- (airbnb[, .N])
            nb_bronx <- (airbnb[neighbourhood_group == "Bronx", .N])
            nb_man <- (airbnb[neighbourhood_group == "Manhattan", .N])
            nb_Brooklyn <- (airbnb[neighbourhood_group == "Brooklyn", .N])
            nb_queens <- (airbnb[neighbourhood_group == "Queens", .N])
            nb_staten <- (airbnb[neighbourhood_group == "Staten Island", .N])
            fig_nb_hote <-plot_ly(airbnb, x=bb_data$neighbourhood_group, y= nb_queens, type = "bar",marker = list(color = "#FFFFFF "))
            fig_nb_hote <- fig_nb_hote %>% add_bars(x=airbnb$neighbourhood_group , y= nb_staten, type = "bar",marker = list(color = "#900033 "))
            fig_nb_hote
        })
        
        # test de Krustal pour déterminer s'il y a un effet du type de chambre
        kruskal.test(price~room_type, data= bb_data) # il semblerait que oui...
    
        
})

