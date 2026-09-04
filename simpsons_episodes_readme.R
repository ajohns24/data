# code: https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-02-04/readme.md
# this code pulls from Kaggle: https://www.kaggle.com/datasets/prashant111/the-simpsons-dataset

library(httr)
library(tidyverse)
library(jsonlite)
library(withr)

# Define the metadata URL and fetch it
metadata_url <- "www.kaggle.com/datasets/prashant111/the-simpsons-dataset/croissant/download"
response <- httr::GET(metadata_url)

# Ensure the request succeeded
if (httr::http_status(response)$category != "Success") {
  stop("Failed to fetch metadata.")
}

# Parse the metadata
metadata <- httr::content(response, as = "parsed", type = "application/json")

# Locate the ZIP file URL
distribution <- metadata$distribution
zip_url <- NULL

for (file in distribution) {
  if (file$encodingFormat == "application/zip") {
    zip_url <- file$contentUrl
    break
  }
}

if (is.null(zip_url)) {
  stop("No ZIP file URL found in the metadata.")
}

# Download the ZIP file. We'll use the withr package to make sure the downloaded
# files get cleaned up when we're done.
temp_file <- withr::local_tempfile(fileext = ".zip") 
utils::download.file(zip_url, temp_file, mode = "wb")

# Unzip and read the CSV
unzip_dir <- withr::local_tempdir()
utils::unzip(temp_file, exdir = unzip_dir)

# Locate the CSV file within the extracted contents
csv_file <- list.files(unzip_dir, pattern = "\\.csv$", full.names = TRUE)

if (length(csv_file) == 0) {
  stop("No CSV file found in the unzipped contents.")
}

# Read the CSV into a dataframe
simpsons_characters <- read_csv(csv_file[1])
simpsons_episodes <- read_csv(csv_file[2])
simpsons_locations <- read_csv(csv_file[3])
simpsons_script_lines <- read_csv(csv_file[4])

# Step 5: Explore the data
glimpse(simpsons_characters)
glimpse(simpsons_episodes)
glimpse(simpsons_locations)
glimpse(simpsons_script_lines)
