#Loading data.table package
library(data.table)

# Loading data to data.table with fread(), replacing "?" with NA.
dataFile <- "household_power_consumption.txt"
consumptionData <- fread(dataFile, na.strings = "?")

# Setting data.table key and subsetting required dates. 
setkey(consumptionData, Date)
consumptionData <- consumptionData[c("1/2/2007", "2/2/2007")]

# Plotting histogram in screen device
with(consumptionData, hist(x = Global_active_power, main = "Global Active Power",
                           xlab = "Global Active Power (kilowatts)",
                           col = "red"))

# Saving plot from screen to png file
dev.copy(device = png, filename = "plot1.png", width = 480, height = 480)
dev.off()