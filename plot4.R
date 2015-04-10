# Check if data source exists. If not, download and extract the file to current working directory and subfolder "data". 
if(!file.exists("data/household_power_consumption.txt")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata-data-household_power_consumption.zip", mode='wb')
    unzip("exdata-data-household_power_consumption.zip", exdir = "data")
}

# Only read in the rows that represent dates from 2007-02-01 to 2007-02-02 with skip and nrows parameters.
data <- read.table("data/household_power_consumption.txt", header = FALSE, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), sep = ";", na.strings = "?", skip = 66637, nrows = 2880, stringsAsFactors = FALSE)

# Create new variable "DateTime" with POSIXlt data/time format based on concatenated Date and Time variable. 
data$DateTime <- paste(data$Date, data$Time)
data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")

# Ignore original Date and Time variables
data <- data[,c("DateTime", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")]

## Plot FOUR

# Create png file with transparent background and size 480 x 480 
png(file = "plot4.png", bg = "transparent", width = 480, height = 480)

par(mfcol = c(2,2))

Sys.setlocale("LC_ALL","C")

# Upper-left plot
plot(data$DateTime, data$Global_active_power, type="n", ylab = "Global Active Power", xlab="")
lines(data$DateTime, data$Global_active_power, type="l")

# Lower-left plot
plot(data$DateTime, data$Sub_metering_1, type="n", ylab = "Energy sub metering", xlab="")
lines(data$DateTime, data$Sub_metering_1, type="l")
lines(data$DateTime, data$Sub_metering_2, type="l", col="red")
lines(data$DateTime, data$Sub_metering_3, type="l", col="blue")
legend("topright",  bty = "n", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

# Upper-right plot
plot(data$DateTime, data$Voltage, type="n", ylab = "Voltage", xlab="datetime")
lines(data$DateTime, data$Voltage, type="l")

# Lower-right plot
plot(data$DateTime, data$Global_reactive_power, type="n", ylab = "Global_reactive_power", xlab="datetime")
lines(data$DateTime, data$Global_reactive_power, type="l")

dev.off()