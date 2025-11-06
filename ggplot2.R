# Loading required library
library(ggplot2)
library(dplyr)
library(palmerpenguins)
library(ggbeeswarm) # For beeswarm plots
head(penguins)

# Basic plotting

# Scatter plot
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_point() +
    labs(title = "Flipper Length ~ Body Mass",
            x = "Flipper Length(mm)", 
            y = "Body Mass(g)") +
    theme_minimal() + # Themes modify the non-data components of your plot
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_smooth(method = "lm", se = FALSE, color = "blue")


ggplot(data = penguins,mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +  # nolint
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) 

# Boxplot
penguins %>%
    ggplot(mapping = aes(x = species, y = body_mass_g)) +
    geom_boxplot() +
    labs(title = "Body Mass by Species",
            x = "Species",
            y = "Body Mass(g)") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_jitter(width = 0.2, alpha = 0.5)

ggplot(data = penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot() +
  labs(title = "Body Mass by Species", x = "Species", y = "Body Mass (g)")

# Histogram
ggplot(data = penguins, aes(x = flipper_length_mm)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black") +
  labs(title = "Distribution of Flipper Lengths", x = "Flipper Length (mm)", y = "Frequency")

# Bar plot
ggplot(data = penguins, aes(x = species, fill = species)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Number of Penguins by Species", x = "Species", y = "Count")

# Violin plot 
ggplot(data = penguins, aes(x = species, y = body_mass_g, fill = species)) +
  geom_violin() +
  labs(title = "Body Mass Distribution by Species", x = "Species", y = "Body Mass (g)") +
  theme_minimal() +

# Heat map
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_bin2d(bins = 30) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(title = "Heatmap of Bill Dimensions", x = "Bill Length (mm)", y = "Bill Depth (mm)") +
  theme_minimal()

# Dot plots and beeswarm plots
ggplot(data = penguins, mapping = aes(x = species, y = body_mass_g, fill = species)) +
  geom_dotplot(binaxis = 'y', binwidth = 50, stackdir = "center", stackratio = 1.5) +
  labs(title = "Dot Plot of Body Mass by Species",
       x = "Species",
       y = "Body Mass (g)") +
  theme_minimal()

ggplot(data = penguins, mapping = aes(x = species, y = body_mass_g)) +
  geom_beeswarm(size = 1.5, alpha = 0.7, aes(color = species)) +
  labs(title = "Beeswarm Plot of Body Mass by Species",
        x = "Species",
        y = "Body Mass (g)") +
  theme_minimal()

# Density plot
ggplot(data = penguins, aes(x = flipper_length_mm, fill = species)) +
  geom_density(alpha = 0.6) +
  theme_minimal()
  
# Mapping color and shape aesthetics
ggplot(data = penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = sex)) +
  geom_point()


# Labels and titles
ggplot(data = penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  labs(
    title = "Bill Length vs. Bill Depth",
    subtitle = "Palmer Penguins Dataset",
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    caption = "Data source: palmerpenguins R package"
  )

# Facting by species
ggplot(data = penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  facet_wrap(~ species) # Faceting creates multiple plots based on a categorical variable

ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  facet_grid(sex ~ species) # Facting with sex and species categorical variables


# Saving plots

# Create the plot
p <- ggplot(data = penguins,mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +  # nolint
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) 

# Save the plot
ggsave('penguins_scatterplot.png', plot = p, width = 8, height = 6, dpi = 300)


# Pipe operator(%>%)
# Visulizing Adelie penguins flipper length vs body mass with linear
penguins %>% 
  filter(species == "Adelie") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs (title = "Adelie Pengiuns: Flipper_length ~ Body Mass",
        x = "Flipper_length(mm)",
        y = "Body_Mass(g)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

penguins %>%
  group_by(species) %>%
  mutate(
    avg_body_mass = mean(body_mass_g, na.rm = TRUE),
    avg_flipper_length = mean(flipper_length_mm, na.rm = TRUE)
  ) %>% 
  filter(species == "Chinstrap") %>%
  ggplot (mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") 


# Description statistics
penguins %>%
  group_by(species) %>%
  summarise(
    count = n(),
    avg_body_mass = mean(body_mass_g, na.rm = TRUE),
    sd_body_mass = sd(body_mass_g, na.rm = TRUE),
    min_body_mass = min(body_mass_g, na.rm = TRUE),
    max_body_mass = max(body_mass_g, na.rm = TRUE)
  )

penguins %>%
  filter(species == "Adelie") %>%
  summarise(
    iqr = IQR(body_mass_g, na.rm = TRUE))
