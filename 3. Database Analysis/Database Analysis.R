
#load stringdist package
install.packages("stringdist")
library(stringdist)

all_hits = read.csv("hits_database_raw.csv")


TrackName = all_hits[['TrackName']]
print(TrackName)

"""
#Creating the matrix with the similarity measures
x= adist(TrackName,all_hits$TrackName)

#Creating a matrix and a csv with the most problematic combinations of songs
positions = which(x > 0 & x < 3, arr.ind = TRUE)

write.csv(positions,"Positions.csv")
"""


#Importing both databases 

all_non_hits = read.csv("Non-hits_cleaned.csv")
all_hits = read.csv("hits_database_clean.csv")

#Naming hits with 1
all_hits$hit = 1

#Creating the complete database
all_songs = rbind(all_non_hits, all_hits)

#Checking once again for duplicates
all_songs[!duplicated(all_songs$TrackID),]

#Summary descriptive stats

all_hits[ , c("TrackID", "playlistID", "TrackName", "SampleURL", "ReleaseYear", 
               "Genres", "Popularity")] = list(NULL)

all_non_hits[ , c("TrackID", "playlistID", "TrackName", "SampleURL", "ReleaseYear", 
              "Genres", "Popularity")] = list(NULL)

install.packages("psych")
library(psych)

descriptive1 = describe(all_hits)
descriptive2= describe(all_non_hits)

write.csv(descriptive1,"Descriptive_Measures_HITS.csv")
write.csv(descriptive2,"Descriptive_Measures_NO_HITS.csv")








#OTHER - DO NOT CONSIDER 

#z= distances[which(distances$"2" == 10), ]

#print(z)

#write.csv(x,"Distances.csv")

#distances = read.csv("Distances.csv")


#amatch(TrackName,all_hits$TrackName, maxDist = 3)


#install.packages("dplyr")
#library(dplyr)

# across all columns:
#distances %>% filter_all(any_vars(. %in% c('2', '3')))


#y = all_hits[amatch(TrackName, all_hits$TrackName, maxDist = 3),]


#calculate Levenshtein distance
#stringdist(data$a, data$b, method='lv')
