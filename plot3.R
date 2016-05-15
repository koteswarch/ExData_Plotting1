##################################
#
# SUB METERING ENERGY LINE GRAPH
#
##################################

# Load the power usage data
powerUsage <- read.table("household_power_consumption.txt", header = TRUE,
                         sep = ";")

# loads the lubridate package
library(lubridate)

# loads dplyr package
library(dplyr)

# loads tidyr package
library(tidyr)

# create a combined date time variable
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

# reset the plot grid

par(mfrow = c(1,1))
par(mar = c(2,4,2,3))

# plot the line graph 
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
       lty = 1, bty = "o", cex = 0.75)

# copy the result to a file device
dev.copy(png, file="./ExData_Plotting1/plot3.png", width = 640, 
         height = 640)

# close the device connection
dev.off()