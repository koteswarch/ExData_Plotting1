##################################
#
# GLOBAL ACTIVE POWER LINE GRAPH
#
##################################

# Load the power usage data
powerUsage <- read.table("household_power_consumption.txt", header = TRUE,
                         sep = ";")

# loads the lubridate package
library(lubridate)

# loads dplyr package
library(dplyr)

# create a date time (combined) variable
powerUsage <- 
    mutate(powerUsage, datetime = paste(as.character(Date), as.character(Time)))

powerUsage <- 
    select(powerUsage, datetime, 3:9)

powerUsage$datetime <- dmy_hms(powerUsage$datetime)

# select data for the first two days of february 2007
febPowerUsage <- 
    filter(powerUsage, 
           date(datetime) == "2007-02-01" | date(datetime) == "2007-02-02" )

# convert factor variable to numeric
febPowerUsage$Global_active_power <- 
    as.numeric(as.character(febPowerUsage$Global_active_power))

# plotting the line graph
plot(febPowerUsage$datetime, febPowerUsage$Global_active_power, type = "n", 
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
lines(febPowerUsage$datetime, febPowerUsage$Global_active_power)

# copying the result to file device
dev.copy(png, file="./ExData_Plotting1/plot2.png")

# closing the device connection
dev.off()