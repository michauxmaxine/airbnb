library(shiny)
library(leaflet)
library(plotly)

shinyUI(navbarPage(theme = "style.css",
                    title = "Airbnb",
                   fluid = TRUE, 
                   collapsible = TRUE,
                   
                   #1
                   tabPanel("Home",
                            h1("New York n'attend que vous !",style = "font-family: 'Bookman, URW '; font-size : 20pt; color: #FF3399 ; text-align: center"),                             
                            div(span(img(src = "newyork.jpg",height = 200, width = 150*2.85*3))),
                   ),
                   
                   
                   
                   #3
                   tabPanel("Map",
                            textOutput("selected_var"),
                            selectInput("var", 
                                        label = "Choose a variable to display",
                                        choices = airbnb$neighbourhood_group,
                                        selected = "Percent White"),
                            h1("La carte ci dessous represente l'emplacement des airbnbs du jeu de donnees", style = "font-family: 'Bookman, URW '; font-size : 20pt; color: #FF3399 ; text-align: center"),
                            h5("Vous pouvez trouver lors du passage du curseur sur les points le nom de l'hote ainsi que le prix pour une nuit", style = "font-family: 'Bookman, URW '; font-size : 15pt; color: #FF3399 ; text-align: center"),
                            leafletOutput("bbmap", height=1000)
                            #neighborhoodDescription(),
                            #includeHTML("scrollToTop.html")
                   ),
                   #4
                   tabPanel("Analyse",
                            plotlyOutput("graph"),
                            plotlyOutput("graph_price"),
                            plotlyOutput("graph_nb_hote")
                            ),
                   #4
                   tabPanel("Nous",
                            includeHTML("footer.html")
                            )
                  )
                   
        )



