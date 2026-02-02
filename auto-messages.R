# Automate message creation for Carpentries teaching demos
# Jeff Oliver
# jcoliver@arizona.edu
# 2021-08-09

library(rmarkdown)
library(lubridate)

# The only two lines you will likely need to change are these two:
#   + trainees: update with the location of your trainees file (example format 
#               is available at data/trainees.csv)
#   + demo_date: update the date and time of the demo
trainees <- read.csv(file = "~/Desktop/trainees.csv")
demo_date <- as.POSIXct(x = "2026-02-05 17:00:00", tz = "GMT")

# Shouldn't need to change anything below here
lesson_snippets <- read.csv(file = "data/lesson-snippets.csv")

# Let's be pedantic and ensure that https is always used over http
lesson_snippets$url <- gsub(pattern = "http://",
                            replacement = "https://",
                            x = lesson_snippets$url)
# Also, accommodate those URL links that might have trailing slash (by removing
# the trailing slash); start by identifying those URLs with trailing slashes
trailing_slash <- substr(x = lesson_snippets$url,
                         start = nchar(lesson_snippets$url),
                         stop = nchar(lesson_snippets$url)) == "/"
# With that logical vector, remove trailing slash from URLs as appropriate
lesson_snippets$url[trailing_slash] <- substr(x = lesson_snippets$url[trailing_slash],
                                              start = 1,
                                              stop = (nchar(lesson_snippets$url[trailing_slash]) - 1))

# Lots of effort here to get a nicely formated description of the day and time 
# of the teaching demo

# First, get the name of the day the demo occurs (e.g. "Thursday")
day_name <- lubridate::wday(x = demo_date, label = TRUE, abbr = FALSE)

# Going to print out the date of the demo for the time zone, here we want the 
# output to be like Thursday 12 August 2021 20:00 GMT
date_string <- paste(day_name, 
                     format(x = demo_date, "%d %B %Y %H:%M"),
                     lubridate::tz(demo_date)) # tz extracts the time zone info

# We also want to make sure to provide a link to a time zone converter, easiest 
# if we use GMT/UTC time, so converting to that time zone first
gmt_date <- lubridate::with_tz(demo_date, tzone = "GMT")
url_date <- paste0(format(x = gmt_date, "%Y%m%d"),
                   "T",
                   format(x = gmt_date, "%H%M"))

# Putting everything together for that url that will show up in message
tzconvert_url <- paste0("https://www.timeanddate.com/worldclock/fixedtime.html?",
                        "msg=Carpentries+Teaching+Demo&iso=", 
                        url_date)

# Iterate over each row in trainees data frame and create html file
for (i in 1:nrow(trainees)) {
  first <- trainees$first[i]
  last <- trainees$last[i]
  email <- trainees$email[i]
  
  # Want to get the lesson-specific snippet based on the URL the trainee 
  # provided

  # pull out the URL the trainee provided
  lesson_url <- trainees$lesson_url[i]
  
  # Trim off trailing slash (if it is there)
  if (substr(x = lesson_url, start = nchar(lesson_url), stop = nchar(lesson_url)) == "/") {
    lesson_url <- substr(x = lesson_url, start = 1, stop = (nchar(lesson_url) - 1))
  }
  
  # Pedantic https!
  lesson_url <- gsub(pattern = "http://", 
                     replacement = "https://", 
                     x = lesson_url)
  
  
  # See if we can get the snippet text based on URL
  snippet <- lesson_snippets$snippet[lesson_snippets$url == lesson_url]
  if (length(snippet) != 1) {
    warning(paste0("There was a problem identifying the corresponding snippet for ", 
                   first, " ", last, 
                   ". Either an entry does not exist in data/lesson-snippets.csv ",
                   "or the provided lesson URL is incorrect. Please add lesson ",
                   "specific snippet manually to e-mail message"))
    snippet <- "\n**insert lesson-specific snippet here**\n"
  }

  # Use the RMarkdown template to build message, passing information through 
  # the params list
  rmarkdown::render(input = "templates/e-mail-template.Rmd",
                    output_dir = "output",
                    output_file = paste0(last, "-", first, "-email.html"),
                    params = list(first = first,
                                  email = email,
                                  date_string = date_string,
                                  tzconvert_url = tzconvert_url,
                                  snippet = snippet))
}
