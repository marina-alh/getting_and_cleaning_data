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
