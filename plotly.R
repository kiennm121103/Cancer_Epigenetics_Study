# Loading required libraries
library(plotly)
library(dplyr)
library(palmerpenguins)

# Create a scatter plot of flipper_length_mm and body_mass_g
plot_ly(data = penguins, 
        x = ~flipper_length_mm, 
        y = ~body_mass_g, 
        type = 'scatter', 
        mode = 'markers',
        color = ~species,
        colors = c('Adelie' = 'blue', 'Chinstrap' = 'red', 'Gentoo' = 'green'),
        marker = list(size = 10, opacity = 0.7)) %>%
  layout(title = "Flipper Length vs Body Mass of Penguins",
         xaxis = list(title = "Flipper Length (mm)"),
         yaxis = list(title = "Body Mass (g)")
  )

# Create a box plot to compare body_mass_g by species
plot_ly(data = penguins,
        x = ~species,
        y = ~body_mass_g,
        type = 'box',
        color = ~species) %>%
  layout(title = "Body Mass Distribution by Penguin Species",
         xaxis = list(title = "Species"),
         yaxis = list(title = "Body Mass (g)")
  )

# Create a histogram of bill_length_mm
plot_ly(data = penguins,
        x = ~bill_length_mm,
        type = "histogram",
        marker = list(color = "steelblue")) %>%
  layout(title = "Distribution of Bill Length",
         xaxis = list(title = "Bill Length (mm)"),
         yaxis = list(title = "Count")
  )
# Create a bar plot of species count
plot_ly(data = penguins %>% count(species),
        x = ~species,
        y = ~n,
        type = "bar",
        color = ~species,
        colors = c('Adelie' = 'blue', 'Chinstrap' = 'red', 'Gentoo' = 'green')) %>%
  layout(title = "Number of Penguins by Species",
         xaxis = list(title = "Species"),
         yaxis = list(title = "Count")
  )
