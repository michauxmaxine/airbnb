library(shiny)
library(leaflet)

shinyUI(navbarPage(theme = "bootstrap.css",
                      # Application title.
                      title = div(span(img(src = "airBnb.gif",height = 175, width = 50*2.85*3),
                                       "airbnb",
                                       style = "font-family: 'American Typewriter'; font-size : 60pt; color: #cd469c")),
                   #1
                   tabPanel("Home",
                            h1("Nous allons etudier les airbnb de New York.", style =  "font-family: 'Bookman, URW '; font-size : 20pt; color: #FF3399;text-align: center"),
                            h1("Les donnees utilisees sont fournies par Airbnb. L'ensemble des airbnbs presents a New York y sont repertories. ",style = "font-family: 'Bookman, URW '; font-size : 20pt; color: #FF3399 ; text-align: center"),                             
                            div(span(img(src = "newyork.jpg",height = 200, width = 150*2.85*3)))
            
                   ),
                   
                   #2
                   tabPanel("Data",
                            DT::dataTableOutput("data"),
                   ),
                   
                   #3
                   tabPanel("Map",
                            h1("La carte ci dessous represente l'emplacement des airbnbs du jeu de donnees", style = "font-family: 'Bookman, URW '; font-size : 20pt; color: #FF3399 ; text-align: center"),
                            h5("Vous pouvez trouver lors du passage du curseur sur les points le nom de l'hote ainsi que le prix pour une nuit", style = "font-family: 'Bookman, URW '; font-size : 15pt; color: #FF3399 ; text-align: center"),
                            leafletOutput("bbmap", height=1000)
                            #neighborhoodDescription(),
                            #includeHTML("scrollToTop.html")
                   ),
                   #4
                   tabPanel("Analyse",
                            plotlyOutput("graph")
                            
                            )
                  )
                   
        )



