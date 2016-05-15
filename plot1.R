##################################
#
# GLOBAL ACTIVE POWER HISTOGRAM
#
##################################

# Load the power usage data
powerUsage <- read.table("household_power_consumption.txt", header = TRUE,
                         sep = ";")

# loads the lubridate package
library(lubridate)

# loads dplyr package
library(dplyr)

# converts a factor variable to a date variable
powerUsage$Date <- as.character(powerUsage$Date)
powerUsage$Date <- dmy(powerUsage$Date)

# select data for the first two days of february 2007
febPowerUsage <- filter(powerUsage, 
                        Date == "2007-02-01" | Date == "2007-02-02")

# convert factor variable to numeric
febPowerUsage$Global_active_power <- 
                as.numeric(as.character(febPowerUsage$Global_active_power))

# plotting the histogram
with(febPowerUsage, hist(Global_active_power, col = "red", 
                    xlab = "Global Active Power (kilowatts)", 
                    ylab = "Frequency", 
                    main = "Global Active Power", 
                    font.main = 2,
                    xlim = c(0,6)))

# copying the result to a file device
dev.copy(png, file="./ExData_Plotting1/plot1.png")

# closing the device connection
dev.off()
