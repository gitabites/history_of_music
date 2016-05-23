library(reshape2)
pop <- read.csv('/Users/cwillet1/Downloads/evolution_pop_tags.csv', header=TRUE)
View(pop)

#We want to aggregate the songs into topics. This could also be done in d3 itself, with a nest
#First we have to transform our wide data into long data, using "genre" as our timevar
l <- reshape(pop, 
             varying = c("tags_POP", "tags_ROCK", "tags_SOUL", "tags_OLDIES", "tags_CLASSICROCK","tags_DANCE","tags_HIPHOP","tags_ALTERNATIVE","tags_INDIE","tags_COUNTRY","tags_RAP","tags_NEWWAVE","tags_DISCO","tags_HARDROCK","tags_SINGERSONGWRITER","tags_JAZZ","tags_MOTOWN", "tags_BLUES", "tags_SOFTROCK", "tags_FOLK"), 
             v.names = "score",
             timevar = "genre", 
             times = c("tags_POP", "tags_ROCK", "tags_SOUL", "tags_OLDIES", "tags_CLASSICROCK","tags_DANCE","tags_HIPHOP","tags_ALTERNATIVE","tags_INDIE","tags_COUNTRY","tags_RAP","tags_NEWWAVE","tags_DISCO","tags_HARDROCK","tags_SINGERSONGWRITER","tags_JAZZ","tags_MOTOWN", "tags_BLUES", "tags_SOFTROCK", "tags_FOLK"), 
             new.row.names = 1:1000000,
             direction = "long")

View(l)

#since there are so many genres, we might want to reduce to the more common ones. 
#First, we'll do an agg function without the year to see which genres are the most common
pop_agg_noyear <- aggregate(score~genre, data=l, sum)
View(pop_agg_noyear)

#now we can rerun the reshape using just the 10 top tags
top_tags <- reshape(pop, 
                    varying = c("tags_POP", "tags_ROCK", "tags_SOUL", "tags_OLDIES", "tags_CLASSICROCK","tags_COUNTRY","tags_HIPHOP", "tags_RAP", "tags_DANCE", "tags_ALTERNATIVE"), 
                    v.names = "score",
                    timevar = "genre", 
                    times = c("tags_POP", "tags_ROCK", "tags_SOUL", "tags_OLDIES", "tags_CLASSICROCK","tags_COUNTRY","tags_HIPHOP", "tags_RAP", "tags_DANCE", "tags_ALTERNATIVE"), 
                    new.row.names = 1:1000000,
                    direction = "long")

View(top_tags)
#now we can aggregate genre by year + score
pop_agg <- aggregate(score ~ year+genre, data=top_tags, sum)
View(pop_agg)

#Now we can export this as a csv 
write.csv(pop_agg, "history_of_music/data/history_of_music.csv")


