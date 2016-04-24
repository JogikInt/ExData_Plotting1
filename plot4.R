#Loading data.table package
library(data.table)

# Loading data to data.table with fread(), replacing "?" with NA.
dataFile <- "household_power_consumption.txt"
consumptionData <- fread(dataFile, na.strings = "?")

# Setting data.table key and subsetting required dates. 
setkey(consumptionData, Date)
consumptionData <- consumptionData[c("1/2/2007", "2/2/2007")]

# Converting date and time to POSIXct and adding in separate data.table column.
DateAndTime <- with(consumptionData, as.POSIXct(strptime(sprintf("%s %s", Date, Time),
                                                         '%d/%m/%Y %H:%M:%S')))
consumptionData[, DateAndTime := as.POSIXct(DateAndTime)]

# Finding min and max of which Sub_metering to be used for axes drawing
index <- which.max(with(consumptionData, c(max(Sub_metering_1),
                                           max(Sub_metering_2), max(Sub_metering_3))))
# Creating expression to call that Sub_metering by eval()
call <- parse(text = sprintf("consumptionData$Sub_metering_%d",index))

# There is issue with copying legend from screen to png, so this time 
# I'm plotting straight to png()
png(filename = "plot4.png", width = 480, height = 480)

## Plotting.
par(mfcol = c(2,2))

# First plot
with(consumptionData, plot(x = DateAndTime, y = Global_active_power, type = "n", xlab = "",
                           ylab = "Global Active Power (kilowatts)"))
with(consumptionData, lines(Global_active_power ~ DateAndTime))

# Second plot
with(consumptionData, plot(x = DateAndTime, y = eval(call), type = "n", xlab = "",
                           ylab = "Energy sub metering"))
with(consumptionData, lines(Sub_metering_1 ~ DateAndTime))
with(consumptionData, lines(Sub_metering_2 ~ DateAndTime, col = "red"))
with(consumptionData, lines(Sub_metering_3 ~ DateAndTime, col = "blue"))
legend("topright", lty = c(1,1,1), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n")

# 3rd plot
with(consumptionData, plot(x = DateAndTime, y = Voltage, type = "n", ylab = "Voltage"))
with(consumptionData, lines(Voltage ~ DateAndTime))

# 4th plot
with(consumptionData, plot(x = DateAndTime, y = Global_reactive_power, type = "n",
                           ylab = "Global_reactive_power"))
with(consumptionData, lines(Global_reactive_power ~ DateAndTime))

dev.off()
