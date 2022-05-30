## Intro to data  acquisition using Tidyverse


# url where the data is located
url <- "https://dax-cdn.cdn.appdomain.cloud/dax-airline/1.0.1/lax_to_jfk.tar.gz"
# download the file
download.file(url, destfile = "lax_to_jfk.tar.gz")
# untar the file so we can get the csv only
untar("lax_to_jfk.tar.gz", tar = "internal")
# read_csv only 
sub_airline <- read_csv("lax_to_jfk/lax_to_jfk.csv",
                        col_types = cols(
                                'DivDistance' = col_number(),
                                'DivArrDelay' = col_number()
                        ))
# show the first n = 3 rows
head(sub_airline, 3)
# show the first 6 rows
head(sub_airline)
# show the last 6 rows
tail(sub_airline,10)


# url where the data is located
url <- "https://dax-cdn.cdn.appdomain.cloud/dax-airline/1.0.1/airline_2m.tar.gz"

# download the file
download.file(url, destfile = "airline_2m.tar.gz")

# untar the file so we can get the csv only
untar("airline_2m.tar.gz")

# read_csv only 
airlines <- read_csv("airline_2m.csv",
                     col_types = cols(
                             'DivDistance' = col_number(),
                             'Div1Airport' = col_character(),
                             'Div1AirportID' = col_character(),
                             'Div1AirportSeqID' = col_character(),
                             'Div1WheelsOn' = col_character(),
                             'Div1TotalGTime' = col_number(),
                             'Div1LongestGTime' = col_number(),
                             'DivReachedDest' = col_number(),
                             'DivActualElapsedTime' = col_number(),
                             'DivArrDelay' = col_number(),
                             'Div1WheelsOff'= col_character(),
                             'Div1TailNum' = col_character(),
                             'Div2Airport' = col_character(),
                             'Div2AirportID' = col_character(),
                             'Div2AirportSeqID' = col_character(),
                             'Div2WheelsOn' = col_character(),
                             'Div2TotalGTime' = col_number(),
                             'Div2LongestGTime' = col_number(),
                             'Div2WheelsOff' = col_character(),
                             'Div2TailNum' = col_character()
                     ))
# We are going to be focusing on flights from  LAX to JFK and we will exclude
# flights that got cancelled or diverted
# we are also going to get only useful columns
sub_airline <- airlines %>% 
        filter(Origin == "LAX", Dest == "JFK", 
               Cancelled != 1, Diverted != 1) %>% 
        select(Month, DayOfWeek, FlightDate, 
               Reporting_Airline, Origin, Dest, 
               CRSDepTime, CRSArrTime, DepTime, 
               ArrTime, ArrDelay, ArrDelayMinutes, 
               CarrierDelay, WeatherDelay, NASDelay,
               SecurityDelay, LateAircraftDelay, DepDelay, 
               DepDelayMinutes, DivDistance, DivArrDelay)

colnames(sub_airline)
write_csv(sub_airline, "lax_to_jfk.csv")
sapply(sub_airline, typeof) 

sub_airline %>% 
        filter(Month == 1) %>%
        group_by(Reporting_Airline) %>%
        summarize(avg_carrier_delay = mean(CarrierDelay, na.rm = TRUE))
# group_by / summarize workflow example
sub_airline %>%
        group_by(Reporting_Airline) %>%
        summarize(avg_carrier_delay = mean(CarrierDelay, na.rm = TRUE)) # use mean value
# group_by / summarise workflow example
sub_airline %>%
        group_by(Reporting_Airline) %>%
        summarize(sd_carrier_delay = sd(CarrierDelay, na.rm = TRUE)) # use standard deviation
sub_airline %>%
        group_by(Reporting_Airline) %>%
        summarise(avg_arr_delay = mean(ArrDelay, na.rm=TRUE))
glimpse(sub_airline)
