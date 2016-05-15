##################################
#
# LINE GRAPHS SHOWN IN A GRID
#
##################################


# Load the power usage data
powerUsage <- read.table("household_power_consumption.txt", header = TRUE,
                         sep = ";")

# loads the lubridate package
library(lubridate)

# loads dplyr package
library(dplyr)

# create a combined date time variable
powerUsage <- 
    mutate(powerUsage, datetime = paste(as.character(Date), as.character(Time)))

powerUsage <- 
    select(powerUsage, datetime, 3:9)

powerUsage$datetime <- dmy_hms(powerUsage$datetime)

# select date for the first two days of February 2007
febPowerUsage <- 
    filter(powerUsage, 
           date(datetime) == "2007-02-01" | date(datetime) == "2007-02-02" )

# convert factor variables to numeric ones
febPowerUsage$Global_active_power <- 
    as.numeric(as.character(febPowerUsage$Global_active_power))

febPowerUsage$Global_reactive_power <- 
    as.numeric(as.character(febPowerUsage$Global_reactive_power))

febPowerUsage$Voltage <- 
    as.numeric(as.character(febPowerUsage$Voltage))

# set a 2 x 2 grid to show line graphs
par(mfrow = c(2,2))
par(mar=c(4,4,2,2))

# Global Active Power
plot(febPowerUsage$datetime, febPowerUsage$Global_active_power, type = "n", 
     xlab = "datetime",
     ylab = "Global Active Power (kilowatts)")
lines(febPowerUsage$datetime, febPowerUsage$Global_active_power)

# Voltage
plot(febPowerUsage$datetime, febPowerUsage$Voltage, type = "n", 
     xlab = "datetime",
     ylab = "Voltage")
lines(febPowerUsage$datetime, febPowerUsage$Voltage)

#Energy Sub metering
# convert factor variable to numeric
febPowerUsage$Sub_metering_1 <- 
    as.numeric(as.character(febPowerUsage$Sub_metering_1))
febPowerUsage$Sub_metering_2 <- 
    as.numeric(as.character(febPowerUsage$Sub_metering_2))
febPowerUsage$Sub_metering_3 <- 
    as.numeric(as.character(febPowerUsage$Sub_metering_3))

# Tidying up data
gather(febPowerUsage, sub_meter, active_energy, 
       Sub_metering_1:Sub_metering_3) %>%
    mutate(sub_meter = extract_numeric(sub_meter)) -> tidyFebUsage

# plotting the sub metering data
plot(tidyFebUsage$datetime, 
     tidyFebUsage$active_energy,
     type = "n", 
     xlab = "",
     ylab = "Energy sub metering")

sub1 <- subset(tidyFebUsage, sub_meter == 1)
lines(sub1$datetime, sub1$active_energy, col = "black")
sub2 <- subset(tidyFebUsage, sub_meter == 2)
lines(sub2$datetime, sub2$active_energy, col = "red")
sub3 <- subset(tidyFebUsage, sub_meter == 3)
lines(sub3$datetime, sub3$active_energy, col = "blue")

legend("topright", col = c("black", "red", "blue"),
       legend = c("meter_1", "meter_2", "meter_3"), 
       lty = 1, bty = "o", cex = 0.5)

# plotting Global Reactive Power data
plot(febPowerUsage$datetime, febPowerUsage$Global_reactive_power, type = "n", 
     xlab = "datetime",
     ylab = "Global Reactive Power (kilowatts)")
lines(febPowerUsage$datetime, febPowerUsage$Global_reactive_power)

# writing the result to a file device
dev.copy(png, file="./ExData_Plotting1/plot4.png", width = 640, 
         height = 640)

# closing the device connection
dev.off()
