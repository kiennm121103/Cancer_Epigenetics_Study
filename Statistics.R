# Loading required libraries
library(ggplot2)
library(dplyr)
library(palmerpenguins)
library(car)

# Determine the correctlation between body_mass_g and other variable
lm_model <- lm(body_mass_g ~ flipper_length_mm + year + bill_length_mm + bill_depth_mm + species + sex,
               data = penguins)
summary(lm_model)

# Remove rows with missing values
penguins_clean <- penguins %>% 
  filter(!is.na(body_mass_g), 
         !is.na(flipper_length_mm), 
         !is.na(bill_length_mm), 
         !is.na(bill_depth_mm),
         !is.na(species),
         !is.na(sex))

# Set seed for reproducibility
set.seed(123)

# Create training and test datasets (75% train, 25% test)
set.seed(123)


# Train the linear model on training data
lm_model <- lm(body_mass_g ~ flipper_length_mm + bill_length_mm + year + bill_depth_mm  + species + sex,
               data = train_data)
cat("=== Model Summary (Trained on Training Data) ===\n")
summary(lm_model)

# Make predictions on test data
test_predictions <- predict(lm_model, newdata = test_data)

# Calculate performance metrics on test set
test_residuals <- test_data$body_mass_g - test_predictions
test_rmse <- sqrt(mean(test_residuals^2))
test_mae <- mean(abs(test_residuals))
test_r_squared <- cor(test_data$body_mass_g, test_predictions)^2

cat("\n=== Model Performance on Test Set ===\n")
cat("RMSE (Root Mean Squared Error):", round(test_rmse, 2), "g\n")
cat("MAE (Mean Absolute Error):", round(test_mae, 2), "g\n")
cat("R-squared:", round(test_r_squared, 4), "\n\n")

# Create comparison plot: Actual vs Predicted on test data
test_comparison <- data.frame(
  Actual = test_data$body_mass_g,
  Predicted = test_predictions,
  Residual = test_residuals
)

# Plot: Actual vs Predicted
p1 <- ggplot(test_comparison, aes(x = Actual, y = Predicted)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Actual vs Predicted Body Mass (Test Set)",
       x = "Actual Body Mass (g)",
       y = "Predicted Body Mass (g)") +
  theme_minimal()

# Plot: Residuals
p2 <- ggplot(test_comparison, aes(x = Predicted, y = Residual)) +
  geom_point(alpha = 0.6, color = "darkgreen") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residual Plot (Test Set)",
       x = "Predicted Body Mass (g)",
       y = "Residuals (g)") +
  theme_minimal()

print(p1)
print(p2)

# Making a t-test to compare body_mass_g between species Adelie and Chinstrap
adelie_mass <- penguins_clean %>%
    filter(species == "Adelie") %>%
    pull(body_mass_g)
chinstrap_mass <- penguins_clean %>%
    filter(species == "Chinstrap") %>%
    pull(body_mass_g)
t_test_result <- t.test(adelie_mass, chinstrap_mass)
cat("\n=== T-Test: Adelie vs Chinstrap ===\n")
print(t_test_result)
# Making an ANOVA test to compare body_mass_g between all three species
cat("\n=== ANOVA: Body Mass across All Species ===\n")
anova_result <- aov(body_mass_g ~ species, data = penguins_clean)
summary(anova_result)

# Check assumptions for ANOVA
aov_residuals <- residuals(object = anova_result)

# Normality test: Shapiro-Wilk test on residuals
cat("\n=== Shapiro-Wilk Normality Test (ANOVA Residuals) ===\n")
shapiro_test <- shapiro.test(x = aov_residuals)
print(shapiro_test)

# Homogeneity of variance test: Levene's test
cat("\n=== Levene's Test for Homogeneity of Variance ===\n")
levene_test <- leveneTest(body_mass_g ~ species, data = penguins_clean)
print(levene_test) 
# Check outlier
cat("\n=== Outlier Detection using Boxplot Statistics ===\n")
boxplot_stats <- boxplot(body_mass_g ~ species, data = penguins_clean, plot = FALSE)
outliers <- boxplot_stats$out

# Making a Chi-squared test to see if there is an association between species and bill_length_mm categories
cat("\n=== Chi-Squared Test: Species vs Bill Length Categories ===\n")

# Create bill_length categories (short, medium, long based on quantiles)
penguins_clean <- penguins_clean %>%
  mutate(bill_length_category = cut(bill_length_mm, 
                                     breaks = quantile(bill_length_mm, probs = c(0, 0.33, 0.67, 1)),
                                     labels = c("Short", "Medium", "Long"),
                                     include.lowest = TRUE))

# Create contingency table
contingency_table <- table(penguins_clean$species, penguins_clean$bill_length_category)
print(contingency_table)

# Perform Chi-squared test
chi_squared_test <- chisq.test(contingency_table)
cat("\n")
print(chi_squared_test)
