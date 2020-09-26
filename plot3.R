# Load the necessary libraries to run this code
library(dplyr)
library(readr)

# Check if data folder exists. If not, creates one
if(!file.exists("./data")){
      dir.create("./data")
}

# Set the file URL, donwload it, unzip it to the data folder and get its full path/filename
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataurl, destfile = "./data/electric_power_consumption.zip", method = "curl")
unzip("./data/electric_power_consumption.zip", exdir = "./data")
filename <- dir("./data", full.names = TRUE)[2]

# Using dplyr and readr packages, the code below goes through the following steps:
## reads the dataset into a tibble, formatting the date column as date and setting "?" as NA's;
## filter only the necessary dates for the analysis,
powerconsumption <- filter(
      read_delim(filename, delim = ";", col_types = cols(Date = col_date(format = "%d/%m/%Y")), na = "?"),
      Date == "2007-02-01" | Date == "2007-02-02"
)

# With dplyr, creates another variable containing date and time, as POSIXct, into a single column
powerconsumption <- powerconsumption %>%
      mutate(DateTime = as.POSIXct(paste(Date, Time)))

# Prints the first 6 rows
head(powerconsumption)

# Set a png file with a line plot of the three Sub Metering variables by DateTime and save it to the working directory
png("plot3.png", width = 480, height = 480, bg = "transparent")
with(powerconsumption, plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering"))
with(powerconsumption, lines(DateTime, Sub_metering_1, col = "black"))
with(powerconsumption, lines(DateTime, Sub_metering_2, col = "red"))
with(powerconsumption, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", lty = 1,  col = c("black", "red", "blue"), legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))
dev.off()

#End of code