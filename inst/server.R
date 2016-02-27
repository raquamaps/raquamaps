library(raquamaps)
s <- as.character(default_species_list()$species)

shinyServer(function(input, output) {
  
  output$species_list <- renderUI({
    choices <- s
    if (is.null(s)) return()    
    selectInput("species", "Choose species: ", choices, choices[1])
  })  
  
  output$table <- DT::renderDataTable({
    data.frame(a = "Boho", b = "Blaha")
  }, options = list(lengthChange = FALSE, rownames = FALSE))  
  
  output$dl <- downloadHandler("birdytotals.csv", 
    contentType = "text/csv", content = function(file) {
    write.csv(df, file, row.names = FALSE)
  })    
   
})
