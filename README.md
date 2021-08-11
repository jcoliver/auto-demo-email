# auto-demo-email

## Summary

R code for the generation of e-mail messages to send to trainees for teaching 
demonstrations that are part of the 
[Carpentries Instructor Training](https://carpentries.github.io/instructor-training/) 
checkout process. The e-mail is slightly modified from the [Carpentries-provided
template](https://carpentries.github.io/instructor-training/). Note this will 
_not_ send any e-mails, it will only create html files that you can use to copy 
and paste into e-mail messages to send to trainees.

## Dependencies

+ rmarkdown
+ lubridate

## Description

Briefly, users provide a data frame of trainees' information with the following 
columns (all type character):

+ last: last name
+ first: first name
+ email: email address
+ lesson_url: URL of the lesson the trainee intends to teach

The R script auto-messages.R should be updated to:

1. Set the value of the `trainees` data frame to match description above; this 
can be done by creating the data frame from scratch or by reading in a data 
file. Currently, auto-messages.R uses the latter approach; the file 
data/trainees.csv shows an example data file.
2. Set the date and time of the demo in the `demo_date` variable.

You can then either step through each line of this script (starting by loading 
in the libraries via the `library` commands) or run the entire script (after 
you save it with those updated variables, right?) via 
`source(file = "auto-messages.R")`. I'd recommend the former the first few 
times you try this.

Once the script has run, it will create one html file for each trainee in the 
output folder; the html includes the message to paste into an e-mail, as well 
as the e-mail address the trainee provided (it appears near the top of the 
output html page). By default, the html files in the output folder are ignored 
by Git; I suggest you leave it that way.

If you are using this for the first time, try running the R script 
auto-messages.R as-is first, to see the behavior. Once you see how it works, 
then update values for `trainees` and `demo_date` as appropriate.

## Caveats

+ The e-mail message includes a lesson-specific snippet based on the URL 
provided by the trainee. These snippets are ones that I have written for demos 
that I have run but are **not exhaustive**. That is, there are Carpentries 
lessons that lack lesson snippets in the file data/lesson-snippets.csv. If you 
have a trainee who provides a URL for one of those lessons missing a snippet, 
you will need to write and add this snippet yourself. If this occurs, a warning 
message will appear in the console, but the html file with the e-mail message 
will still be created. (there will be bold text in the e-mail message 
indicating where the snippet should go). If this happens to you, maybe consider 
[submitting a pull request](https://github.com/jcoliver/auto-demo-email/pulls) 
or [opening an issue](https://github.com/jcoliver/auto-demo-email/issues) with 
the snippet information, so that I can update the snippet data file?
+ Identifying the correct snippet to use is based on pattern matching of URLs. 
If an incorrect URL was provided, a match won't be found, and you'll need to 
add the snippet yourself. You can see the URLs for which snippets are provided 
by looking at the file data/lesson-snippets.csv.
+ Remember, this doesn't actually send any e-mails, you'll need to copy and 
paste them into your favorite e-mail client and do that part the old-fashioned 
way :)