shinyUI(fluidPage(
  theme = shinythemes::shinytheme("spacelab"),
  tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),
  #titlePanel("raquamaps"),
  sidebarLayout(
    sidebarPanel(
      
      img(src = "logo.png", width = 250),
      img(src = "raquamaps.png", width = 250),
      hr(),
      uiOutput("species_list"),
      # selectizeInput("name", label = "Species:",
      #  choices = output$species_list,
      #  multiple = TRUE,
      #  options = list(maxItems = 20, placeholder = "Choose species...")#,
      # ),
      
      sliderInput("range", "Interval for species preferences: ",
        round = TRUE, post = "%",
        min = 1, 
        max = 100, 
        value = c(10, 90)
      ),
      
      radioButtons("series", label = "Route:",
        choices = c("Standard", "Sommar", "Vinter", "Natt"), #unique(birdtotals$Series),
        selected = c("Standard")
      ),
      
      checkboxGroupInput("significance", label = "Significance:", 
        inline = TRUE,
        choices = c("***", "**", "*")
      )      
  
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Map", 
          textOutput("totalsPlot")
        ),
        tabPanel("Table", 
          helpText("Current selection:"),
          br(), 
          DT::dataTableOutput("table")
        ),
        tabPanel("Source", 
          helpText("Download data in CSV:"),
          fluidRow(p(class = "text-center", 
            downloadButton("dl", label = "Get all data"))
          )
        )      
      )    
    )
  )
))
