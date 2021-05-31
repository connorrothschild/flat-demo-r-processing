library(dplyr)
library(stringr)

raw_data <- readxl::read_excel("./raw.xlsx")

data <- raw_data %>% 
  rename("Date" = `Date of Incident (month/day/year)`,
         "Link" = `Link to news article or photo of official document`,
         "Armed Status" = `Armed/Unarmed Status`, 
         "Age" = `Victim's age` , 
         "Race" = `Victim's race`, 
         "Sex" = `Victim's gender`, 
         "Image" = `URL of image of victim`, 
         "Name" = `Victim's name`) %>% 
  mutate(Zipcode = as.character(Zipcode),
         `Body Camera (Source: WaPo)` = as.logical(`Body Camera (Source: WaPo)`),
         `WaPo ID (If included in WaPo database)` = as.logical(`WaPo ID (If included in WaPo database)`)) %>% 
  arrange(Date)

colnames(data)[str_detect(colnames(data), '(DRAFT)')] <- 
  str_replace(colnames(data)[str_detect(colnames(data), '(DRAFT)')], fixed(' (DRAFT)'), '')

clean_data <- data %>% 
  # For each grouping variable, normalize to Title Case
  mutate_at(vars('Armed Status', 'Race', 'Cause of death', 'Sex', 'Encounter Type'), stringr::str_to_title) %>% 
  mutate(Year = lubridate::year(Date),
         Sex = ifelse(is.na(Sex), 'Unknown', Sex),
         `Armed Status` = ifelse(`Armed Status` == 'Unarmed/Did Not Have An Actual Weapon', 'Unarmed', `Armed Status`),
         `Armed Status` = ifelse(`Armed Status` == 'Unarmed/Did Not Have Actual Weapon', 'Unarmed', `Armed Status`),
         ### AGENCY CLEANING
         `Agency responsible for death` = ifelse(is.na(`Agency responsible for death`), 'Unknown', `Agency responsible for death`),
         `Agencies responsible for death` = `Agency responsible for death`,
         `Agency responsible for death` = str_replace_all(
           `Agency responsible for death`, ", ", replacement = paste0(" (", State, "), ")),
         `Agency responsible for death` = paste0(`Agency responsible for death`, " (", State, ")"),
         `Cause of death` = str_replace(`Cause of death`, ",.*",""),
         `Cause of death` = str_replace_all(`Cause of death`, "/.*",""),
         ### ENCOUNTER TYPES
         `Encounter Type` = str_replace(`Encounter Type`, " \\(.+?\\)", ''),
         `Encounter Type` = str_replace(`Encounter Type`, "Distubance", 'Disturbance'),
         `Encounter Type` = str_replace(`Encounter Type`, "Person With Weapon", 'Person With A Weapon'),
         `Encounter Type` = str_replace(`Encounter Type`, "Domestic Disturbance\\-(.*)", 'Domestic Disturbance'),
         # Handling multiples (comma or slash separated) by preferring one over another
         `Encounter Type` = ifelse(str_detect(`Encounter Type`, 'Mental Health/Welfare Check'), 'Mental Health/Welfare Check', `Encounter Type`),
         `Encounter Type` = ifelse(str_detect(`Encounter Type`, 'Other Non-Violent Offense'), 'Other Non-Violent', `Encounter Type`),
         `Encounter Type` = ifelse(str_detect(`Encounter Type`, 'Part 1 Violent Crime'), 'Part 1 Violent Crime', `Encounter Type`),
         `Encounter Type` = ifelse(str_detect(`Encounter Type`, 'Other Crimes Against People'), 'Other Crimes Against People', `Encounter Type`),
         `Encounter Type` = ifelse(is.na(`Encounter Type`), 'None/Unknown', `Encounter Type`),
         # manually adding image of Shelly Porter III, per family request
         `Image` = ifelse(Name == "Shelly Porter III", "https://i.imgur.com/64RKdEw.jpg", Image),
         ID = row_number()
         )

readr::write_csv(clean_data, "./output.csv")