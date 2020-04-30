library(tidyverse)
library(sf)
library(mapview)
library(leaflet.providers)



load("data/nyt_counties.rda")
load("data/nyt_states.rda")

counties_sf <- urbnmapr::get_urbn_map("counties", sf = TRUE)

server <- function(input, output, session) {
  output$table <- renderReactable({
    nyt_day <-
      nyt_counties %>% 
      filter(state == input$state, date == input$date) %>% 
      mutate(cases = ifelse(is.na(cases), 0, cases),
             deaths = ifelse(is.na(deaths), 0, deaths),
             mortalityRate = signif(deaths/cases, digits = 5))
    reactable::reactable(nyt_day, searchable = TRUE)
  })
  output$text <- renderText({
    paste0("Total Confirmed Cases and Deaths up to ", input$date, " in ", input$state," by county.")
  })
  output$mapplot <- renderLeaflet({
    p <-
      nyt_counties %>% 
      filter(state == input$state, date == input$date) %>% 
      mutate(cases = ifelse(is.na(cases), 0, cases),
             deaths = ifelse(is.na(deaths), 0, deaths),
             mortalityRate = signif(deaths/cases, digits = 5)) %>% 
      right_join(counties_sf %>% filter(state_name == input$state),
                 by = c("fips" = "county_fips")) %>% 
      sf::st_as_sf() %>% 
      mapview::mapview(zcol = input$choice, na.color = "white")
    p@map
    })
  output$maptext <- renderText({
    paste0("Total ", input$choice, " up to ", input$date, " in ", input$state," by county.")
  })
}