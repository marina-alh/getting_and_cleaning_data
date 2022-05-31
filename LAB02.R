# url where the data is located
url <- "https://dax-cdn.cdn.appdomain.cloud/dax-airline/1.0.1/lax_to_jfk.tar.gz"

# download the file
download.file(url, destfile = "lax_to_jfk.tar.gz")

# untar the file so we can get the csv only
# if you run this on your local machine, then can remove tar = "internal" 
untar("lax_to_jfk.tar.gz", tar = "internal")

# read_csv only 
sub_airline <- read_csv("lax_to_jfk/lax_to_jfk.csv",
                        col_types = cols('DivDistance' = col_number(), 
                                         'DivArrDelay' = col_number()))
head(sub_airline)


#Identify missing data
#Deal with missing data
#Correct data format

# counting missing values
sub_airline %>%
        summarize(count = sum(is.na(CarrierDelay)))
map(sub_airline, ~sum(is.na(.)))
# Check dimensions of the dataset
dim(sub_airline)


# How to deal with missing data?
#         
#         Drop data
# a. Drop the whole column
# b. Drop the whole row
# Replace data
# a. Replace it by mean
# b. Replace it by frequency
# c. Replace it based on other functions


drop_na_cols <- sub_airline %>% select(-DivDistance, -DivArrDelay)
dim(drop_na_cols)
head(drop_na_cols)
# Drop the missing values
drop_na_rows <- drop_na_cols %>% drop_na(CarrierDelay)
dim(drop_na_rows)
head(drop_na_rows)
# Replace the missing values in five columns
replace_na <- drop_na_rows %>% replace_na(list(CarrierDelay = 0,
                                               WeatherDelay = 0,
                                               NASDelay = 0,
                                               SecurityDelay = 0,
                                               LateAircraftDelay = 0))
head(replace_na)
# Replace the missing values in five columns
carrierD_mean <- mean(drop_na_rows$CarrierDelay)
replace_mean = drop_na_cols %>% replace_na(list(CarrierDelay = carrierD_mean))
head(replace_na)

# list the data type from each column
sub_airline %>% 
        summarize_all(class) %>% 
        gather(variable, class)

# reformating feature into 3 saparete columns

date_airline <- replace_na %>% 
        separate(FlightDate, sep = "-", into = c("year", "month", "day"))
date_airline %>%
        select(year, month, day) %>%
        mutate_all(type.convert) %>%
        mutate_if(is.character, as.numeric)
simple_scale <- sub_airline$DepDelay / max(sub_airline$DepDelay)
z_scale <- (sub_airline$DepDelay - mean(sub_airline$DepDelay)) / sd(sub_airline$DepDelay)
head(z_scale)

#Binning
ggplot(data = sub_airline, mapping = aes(x = ArrDelay)) +
        geom_histogram(bins = 100, color = "white", fill = "red") +
        coord_cartesian(xlim = c(-73, 682))

binning <- sub_airline %>%
        mutate(quantile_rank = ntile(sub_airline$ArrDelay,4))

head(binning)
ggplot(data = binning, mapping = aes(x = quantile_rank)) +
        geom_histogram(bins = 4, color = "white", fill = "red")



# Indicator variable method to turn categorical variables into numerical

sub_airline1=sub_airline %>%
        mutate(dummy = 1) %>% # column with single value
        spread(
                key = Reporting_Airline, # column to spread
                value = dummy,
                fill = 0) %>%
        slice(1:5)


sub_airline2=sub_airline %>% 
        spread(Reporting_Airline, ArrDelay) %>% 
        slice(1:5)
sub_airline %>% # start with data
        mutate(Reporting_Airline = factor(Reporting_Airline,
                                          labels = c("AA", "AS", "DL", "UA", "B6", "PA (1)", "HP", "TW", "VX")))%>%
        ggplot(aes(Reporting_Airline)) +
        stat_count(width = 0.5) +
        labs(x = "Number of data points in each airline")

sub_airline3=sub_airline %>%
        mutate(dummy = 1) %>% # column with single value
        spread(
                key = Month, # column to spread
                value = dummy,
                fill = 0) %>%
        slice(1:5)
sub_airline4=sub_airline %>%
        spread(
                key = Month, # column to spread
                value = DepDelay,
                fill = 0) %>%
        slice(1:5)
