library(tidyverse) 
library(ggplot2) 
library(readr)

daily_sac <- read.csv('Data/NCEI_GHCNDaily_2008720.csv', header=TRUE,
                              na.strings = c("NA", " ", "-999")) #read Sac Airport data
ggplot(daily_sac, aes(x = DATE, y = TMAX)) +
  geom_point() +
  labs(title = "Maximum temperature data for Sac Airport")

daily_anti <- read.csv('Data/NCEI_GHCNDaily_2008744.csv', header=TRUE,
                      na.strings = c("NA", " ", "-999")) #read Antioch Pumping Plant data
ggplot(daily_anti, aes(x = DATE, y = TMAX)) +
  geom_point() +
  labs(title = "Maximum temperature data for Antioch Pumpning Plant #3")

daily_stock <- read.csv('Data/NCEI_GHCNDaily_2008746.csv', header=TRUE,
                       na.strings = c("NA", " ", "-999")) #read Stockton data
ggplot(daily_stock, aes(x = DATE, y = TMAX)) +
  geom_point() +
  labs(title = "Maximum temperature data for Stockton Airport")

precip_plot <- ggplot(daily_sac,  aes(x = DATE, y = PRCP)) 

precip_plot + geom_point(alpha = 0.9, aes(color = PRCP)) +
  labs(x = "Date",
       y = "Precipitation (Inches)",
       title = "Daily Precipitation (inches)",
       subtitle = "Sacramento Executive Airport, 1970-2020") +
        theme_bw()
precip_plot + geom_bar(stat = "identity")

precip_plot <- ggplot(daily_stock,  aes(x = DATE, y = PRCP)) 

precip_plot + geom_point(alpha = 0.9, aes(color = PRCP)) + #stockton data
  labs(x = "Date",
       y = "Precipitation (Inches)",
       title = "Daily Precipitation (inches)",
       subtitle = "Stockton Airport, 1970-2020") +
  theme_bw()

precip_plot + geom_line(aes(group=1))


precip_plot + facet_grid(. ~ year)
