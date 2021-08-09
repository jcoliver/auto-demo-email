# Automate message creation for Carpentries teaching demos
# Jeff Oliver
# jcoliver@arizona.edu
# 2021-08-09

library(rmarkdown)

trainees <- read.csv(file = "data/trainees.csv")

# Need also
# Date, with day of week?
# Link for time zone
#     + Could just get date, and remaining will be pulled out in Rmd file

for (i in 1:nrow(trainees)) {
  # Lesson specific snippet
}

# While we are here, make the md document for order, too?