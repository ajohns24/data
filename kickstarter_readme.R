#https://www.kaggle.com/datasets/sripaadsrinivasan/kickstarter-campaigns-dataset
# From Kaggle:
# Kickstarter is an online crowdfunding platform aimed at helping people get their ideas funded while building a community of fans to support their ideas. 
# While Kickstarter publishes many advice and best-practices articles on their blog, over half of campaigns still fail.
# Why does this matter? Well unlike their competitor, Indiegogo, Kickstarter campaign projects follow an "all or nothing" funding model.
# This means that if a Kickstarter campaign fails, both the project creators and backers are disappointed, as well as the people who did contribute because the project will not be completed in any capacity.

kickstarter_data_full <- read.csv("kickstarter_data_full.csv")
kickstarter <- kickstarter_data_full |>
  filter(state %in% c("successful", "failed")) |>
  rename(name_length = name_len_clean, blurb_length = blurb_len_clean) |> 
  mutate(
    success = as.factor(state == "successful"),
    
    # Convert dates
    launched_at = as_datetime(launched_at),
    deadline = as_datetime(deadline),
    created_at = as_datetime(created_at),
    duration = as.numeric(difftime(deadline, launched_at, units = "days")),
    
    # Timing variables
    launch_month   = month(launched_at, label = TRUE),
    launch_weekday = wday(launched_at, label = TRUE),
    launch_hr      = hour(launched_at),
  ) |>
  select(
    # outcome
    success,
    
    # numerical predictors
    goal,
    duration,
    name_length,
    blurb_length,
    launch_hr,
    deadline_hr,
    created_at_hr,
    
    #NEW
    deadline_weekday,
    created_at_weekday,
    
    # categorical predictors
    category,
    country,
    currency,
    launch_month,
    launch_weekday
  ) |>
  drop_na() |> 
  filter(category %in% c("Gadgets", "Musical", "Plays", "Web")) 

write.csv(kickstarter, "kickstarter.csv", row.names = FALSE)