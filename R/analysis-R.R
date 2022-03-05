################
#Processing Data
################

#load libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

#read dataset
jan_2021 <- read_csv("202101-divvy-tripdata.csv")
feb_2021 <- read_csv("202102-divvy-tripdata.csv")
mar_2021 <- read_csv("202103-divvy-tripdata.csv")
apr_2021 <- read_csv("202104-divvy-tripdata.csv")
may_2021 <- read_csv("202105-divvy-tripdata.csv")
jun_2021 <- read_csv("202106-divvy-tripdata.csv")
jul_2021 <- read_csv("202107-divvy-tripdata.csv")
aug_2021 <- read_csv("202108-divvy-tripdata.csv")
sep_2021 <- read_csv("202109-divvy-tripdata.csv")
oct_2021 <- read_csv("202110-divvy-tripdata.csv")
nov_2021 <- read_csv("202111-divvy-tripdata.csv")
dec_2021 <- read_csv("202112-divvy-tripdata.csv")

#combine all the datasets into a single dataset
data_2021 <- bind_rows(jan_2021, feb_2021, mar_2021, 
                       apr_2021, may_2021, jun_2021,
                       jul_2021, aug_2021, sep_2021,
                       oct_2021, nov_2021, dec_2021)

#renaming columns
data_2021 <- rename(data_2021,
                    ride_type = rideable_type,
                    user_type = member_casual)

#find dimensions of dataset
dim(data_2021)

#see the structure of dataset
str(data_2021)

##############
#Data Cleaning 
##############

#remove duplicates
data_2021 <- distinct(data_2021)

#remove rows with missing values in start_station_name_column
data_2021 <- data_2021[!is.na(data_2021$start_station_name),]

#remove rows with invalid start and end times
data_2021 <- data_2021[!(data_2021$ended_at < data_2021$started_at),]

#add a new column which calculates the length of the ride 
data_2021$ride_length <- round(difftime(data_2021$ended_at,data_2021$started_at,units="mins"), digits = 2)

#add a new column which finds the weekday the ride started
data_2021$weekday <- wday(data_2021$started_at, label = TRUE)

#add a new column which finds the month the ride started
data_2021$month <- month(data_2021$started_at, label = TRUE)

#see the amount of na values in each column
colSums(is.na(data_2021))

#see the updated dimension of the dataset
dim(data_2021)

#see dataset
View(data_2021)

#####################
#Descriptive Analysis
#####################

#find avg, min and max statistics
mean(data_2021$ride_length)
min(data_2021$ride_length)
max(data_2021$ride_length)

#get summary statistics
summary(data_2021$ride_length)

#change order of day of week
data_2021$weekday <- ordered(data_2021$weekday, 
                             levels=c("Mon",
                                      "Tue",
                                      "Wed",
                                      "Thu",
                                      "Fri",
                                      "Sat",
                                      "Sun"))

#aggregrate data of ride_length by user type and day of week
aggregate(data_2021$ride_length ~ data_2021$user_type + data_2021$weekday, FUN=mean)
aggregate(data_2021$ride_length ~ data_2021$user_type + data_2021$weekday, FUN=min)
aggregate(data_2021$ride_length ~ data_2021$user_type + data_2021$weekday, FUN=max)


##############
#Visualization
##############

#visualize number of rides in each weekday
data_2021 %>% 
  group_by(user_type, weekday) %>%
  summarise(number_of_rides = n()) %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = user_type)) + 
  geom_col(position = "dodge") + 
  theme(axis.text.x = element_text(angle = 45)) +
  scale_y_continuous(labels = scales::comma)

#visualize average ride length in each weekday
data_2021 %>% 
  group_by(user_type, weekday) %>%
  summarise(avg_duration = mean(ride_length)) %>% 
  ggplot(aes(x = weekday, y = avg_duration, fill = user_type)) + 
  geom_col(position = "dodge") + 
  theme(axis.text.x = element_text(angle = 45)) +
  scale_y_continuous(labels = scales::comma) 

#visualize number of rides in each month
data_2021 %>% 
  group_by(user_type, month) %>%
  summarise(number_of_rides = n()) %>% 
  ggplot(aes(y = month, x = number_of_rides, fill = user_type)) + 
  geom_col(position = "dodge") + 
  theme(axis.text.x = element_text(angle = 45)) +
  scale_x_continuous(labels = scales::comma) + 
  scale_y_discrete(limits=rev)

#visualize the popularity of different bike types
data_2021 %>% 
  group_by(user_type, ride_type) %>% 
  summarise(number_of_rides = n()) %>% 
  ggplot(aes(x = ride_type, y = number_of_rides, fill = user_type)) + 
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma)
  
###############
#Export Summary
###############

#Export number of rides in each weekday
output1 <- data_2021 %>% 
  group_by(user_type, weekday) %>%
  summarise(avg_duration = mean(ride_length))

write.csv(output1, file='num_of_rides_weekday.csv')

#Export average ride duration in each weekday
output2 <- data_2021 %>% 
  group_by(user_type, weekday) %>%
  summarise(avg_duration = mean(ride_length))

write.csv(output2, file='ride_length_weekday.csv')

#Export number of rides in each month
output3 <- data_2021 %>% 
  group_by(user_type, month) %>%
  summarise(number_of_rides = n())

write.csv(output3, file='num_of_rides_month.csv')

#Export popularity of different ride types
output4 <- data_2021 %>% 
  group_by(user_type, ride_type) %>% 
  summarise(number_of_rides = n())

write.csv(output4, file='ride_type_popularity.csv')