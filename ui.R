library(shiny)

shinyUI(navbarPage(title = "Airbnb",
                
                   #1
                   tabPanel("Home",
            
                   ),
                   
                   #2
                   tabPanel("Data",
                            DT::dataTableOutput("data"),
                            #propertyComparison()
                   ),
                   
                   #3
                   tabPanel("Map",
                            leafletOutput("bbmap", height=1000),
                            #neighborhoodDescription(),
                            #includeHTML("scrollToTop.html")
                   ),
                   #4
                   tabPanel("Analyse",
                            
                            )
                   
        )

)





# navbarPage("Location of airbnb", id="main",
#            tabPanel("Map", leafletOutput("bbmap", height=1000)),
#            tabPanel("Data", DT::dataTableOutput("data"))
#            )
# 
