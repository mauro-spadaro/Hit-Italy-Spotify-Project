# -*- coding: utf-8 -*-
"""
Created on Mon Apr 18 11:08:39 2022

@author: spada
"""

import pandas as pd 

df = pd.read_csv("hits_database_raw.csv", usecols=["TrackID", "Genres"])


df2 = df.drop_duplicates(keep='first')
print(df2) 


df3= df2[~df2["Genres"].str.contains("unknown")]


list_of_genres = df3["Genres"].tolist()


print (list_of_genres)

print(type(list_of_genres[0]))

print(list_of_genres[0])


clean_list=[]

for i in range(len(list_of_genres)):
    list1=list_of_genres[i].split("'")
    try:
        list1.remove("[")
        list1.remove("]")
        list1.remove(", ")
        list1.remove(",")
        list1.remove(",  ")
    except: 
        clean_list.extend(list1)
print(clean_list)



def remove_items(test_list, item):
     
    # remove the item for all its occurrences
    c = test_list.count(item)
    for i in range(c):
            test_list.remove(item)
 
    return test_list


remove_items(clean_list, ", ")

print(clean_list)
 

unique_genres = [(i,clean_list.count(i)) for i in set(clean_list)]

print(unique_genres)


#Check of the genres count

summa =[]
for i in range(len(unique_genres)):
    i2=unique_genres[i][1]
    summa.append(i2)

print(sum(summa))
    
#Tuples to df for representation in Excel 

df5 = pd.DataFrame(unique_genres, columns=['Genre', 'Occurrencies'])

print(df5)

df5.to_csv("genres occurrencies.csv")



"""
genres = []
for i in list_of_genres:
    for a in range(len(i)):
        a2=a
        genres.append(a2)
print(genres)
"""