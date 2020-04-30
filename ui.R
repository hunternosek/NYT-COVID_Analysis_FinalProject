library(shinydashboard)
library(tidyverse)
library(leaflet)
library(reactable)
library(shinythemes)

load("data/nyt_counties.rda")
load("data/nyt_states.rda")

day <-
  nyt_counties %>% 
  pull(date) %>% 
  unique() %>% 
  sort(decreasing = TRUE) %>% 
  .[1]

shinyUI(
  dashboardPage(
    skin = "red",
    dashboardHeader(title = "COVID-19"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("County Table", tabName = "table", icon = icon("table")),
        menuItem("By-County Map", tabName = "plot", icon = icon("line-chart"))
      ),
      selectInput("date", "Date",
                  choices = c(
                    mydates <- seq(as.Date('2020-03-01'),day, by = 'day')
                  ),
                  selected = day),
      selectInput("state", "State",
                  choices = state.name,
                  selected = "Tennessee"),
      selectInput("choice", "Map variable",
                  choices = c("cases","deaths"),
                  selected = "cases")
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "table",
          fluidRow(
            htmlOutput("text"),
            reactableOutput("table")
          )
        ),
        tabItem(
          tabName = "plot",
          fluidRow(
            htmlOutput("maptext"),
            leafletOutput("mapplot")
          )
        )
      ) 
    )
  )
) 

