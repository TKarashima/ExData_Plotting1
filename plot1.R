# The file household_power_consumption.txt must be in the working directory.

## FIRST PART ##

        ## READING THE DATA

power_consumpt_0 <- read.table("household_power_consumption.txt", sep = ";",
                               header = TRUE, na.strings = "?", nrows = 5, 
                               colClasses = "character", comment.char = "")

var.names <- names(power_consumpt_0)
rm(power_consumpt_0)

power_consumpt <- read.table("household_power_consumption.txt", sep = ";",
                             header = FALSE, na.strings = "?", nrows = 10000, 
                             colClasses = "character", comment.char = "",
                             skip = 66500, col.names = var.names)
rm(var.names)

        ## ADJUSTING THE COLUMN CLASSES

for(i in 3:9) {
        power_consumpt[ , i] <- as.numeric(power_consumpt[ , i])
}

power_consumpt_DateTime <- paste(power_consumpt$Date, power_consumpt$Time)
power_consumpt <- cbind(power_consumpt, 
                        power_consumpt_DateTime)[ ,c(1, 2, 10, 3:9)]
power_consumpt <- power_consumpt[ , c(-1, -2)]
names(power_consumpt)[1] <- "DateTime"
power_consumpt$DateTime <- as.character(power_consumpt$DateTime)
power_consumpt$DateTime <- strptime(power_consumpt$DateTime, 
                                    format = "%e/%m/%Y %T")
rm(power_consumpt_DateTime)

        ## SUBSETING THE DATA 2007-02-01 TO 2007-02-02

date_vect <- (power_consumpt$DateTime >= "2007-02-01 00:00:00" &
                      power_consumpt$DateTime <= "2007-02-02 23:59:59")
power_consumpt <- power_consumpt[date_vect, ]
rm(date_vect)

        ## VERIFYING THE DATA

str(power_consumpt)
head(power_consumpt[ ,1:2], 3)
tail(power_consumpt[ ,1:2], 3)

## SECOND PART ##
        ## PLOTING THE DATA

hist(power_consumpt$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()
