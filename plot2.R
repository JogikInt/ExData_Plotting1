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


## Plotting.
# Empty axes.
with(consumptionData, plot(x = DateAndTime, y = Global_active_power, type = "n", xlab = "",
                           ylab = "Global Active Power (kilowatts)"))
# The lines.
with(consumptionData, lines(Global_active_power ~ DateAndTime))

# Saving plot from screen to png file
dev.copy(device = png, filename = "plot2.png", width = 480, height = 480)
dev.off()
