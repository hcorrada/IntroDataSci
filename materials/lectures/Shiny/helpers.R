library(lubridate)

if (!exists(".inflation")) {
  .inflation <- getSymbols("CPIAUCNS", src="FRED", auto.assign=FALSE)
}

month_data <- split(data)[[1]]
t <- ymd(time(month_data[1]))
date <- paste(year(t), month(t), sep="-")
