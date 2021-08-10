# Automate message creation for Carpentries teaching demos
# Jeff Oliver
# jcoliver@arizona.edu
# 2021-08-09

library(rmarkdown)
library(lubridate)

trainees <- read.csv(file = "data/trainees.csv")
demo_date <- as.POSIXct(x = "2021-08-12 20:00:00", tz = "GMT")


day_name <- lubridate::wday(x = demo_date, label = TRUE, abbr = FALSE)

# Going to print out the date of the demo for the time zone, here we want the 
# output to be like Thursday 12 August 2021 20:00 GMT
date_string <- paste(day_name, 
                     format(x = demo_date, "%d %B %Y %H:%M"),
                     lubridate::tz(demo_date))

# We also want to make sure to provide a link to a time zone converter, easiest 
# if we use GMT/UTC time, so converting to that time zone first
gmt_date <- lubridate::with_tz(demo_date, tzone = "GMT")
url_date <- paste0(format(x = gmt_date, "%Y%m%d"),
                   "T",
                   format(x = gmt_date, "%H%M"))

# Putting everthing together for that url that will show up in message
tzconvert_url <- paste0("https://www.timeanddate.com/worldclock/fixedtime.html?",
                        "msg=Carpentries+Teaching+Demo&iso=", 
                        url_date)

for (i in 1:nrow(trainees)) {
  first <- trainees$first[i]
  last <- trainees$last[i]
  email <- trainees$email[i]
  # Lesson specific snippet
  

  rmarkdown::render(input = "templates/e-mail-template.Rmd",
                    output_dir = "output",
                    output_file = paste0(last, "-", first, "-email.html"),
                    params = list(first = first,
                                  email = email,
                                  date_string = date_string,
                                  tzconvert_url = tzconvert_url))
}

# While we are here, make the md document for order, too?