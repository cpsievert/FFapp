library(XML)
library(plyr)
pre <- "http://www.fantasypros.com/nfl/rankings/"
pos <- c("qb", "rb", "wr", "te", "flex", "qb-flex", "k", "dst", "idp", "dl", "lb", "db")
urls <- paste0(pre, pos, ".php")
dats <- NULL
experts <- NULL
for (i in seq_along(urls)) {
  dat <- readHTMLTable(urls[i], stringsAsFactors=FALSE)
  dats[[i]] <- cbind(dat$data, Category=pos[i])
  #if ("experts" %in% names(dat)) 
  experts[[i]] <- cbind(dat$experts, Category=pos[i])
}
names(dats[[6]]) <- names(dats[[5]]) #names are up messed on 6th df
df <- rbind.fill(dats)
df2 <- df[!is.na(df[,2]), ] # grab non defensive-special teams rankings
x <- strsplit(df2$Player, " \\(")
df2[,2] <- sapply(x, "[[", 1) #overwrite player column so that it just includes player names (without matchups)
df2[,9] <- sapply(x, "[[", 2) #Overwirte matchup (which be NA before this point)
final <- rbind(df2, df[is.na(df[,2]), ])
final[,9] <- gsub("\\(", "", final[,9])
final[,9] <- gsub("\\)", "", final[,9])
names(final)[1] <- "Rank"
names(final)[2] <- "Player"
names(final)[9] <- "Matchup"
write.csv(final, file="wk1.csv", row.names=FALSE)
str(final)
names(final) <- gsub(" ", "", names(final))
num <- c("Rank", "Best", "Worst", "Ave", "StdDev")
for (i in num) final[,i] <- as.numeric(final[,i])
