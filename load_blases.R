#
library(httr)

this_game <- "5947b5f0-7a90-4896-bfa6-fd011a36fba7"

rr <- GET("https://api.sibr.dev/chronicler/v1/games/updates?game=5947b5f0-7a90-4896-bfa6-fd011a36fba7&order=asc&count=1000")

cc <- lapply(content(rr)$data, `[[`, "data")
#cc <- lapply(cc, function(xx) as.data.frame(Filter(function(x) length(x)>0,xx)))
#cc <- do.call(rbind.data.frame, cc)

ii <- 1


write.table(cc[[i]]$homeTeamBatterCount, file="home_batter_count",
            col.names=FALSE, row.names=FALSE)

write.table(cc[[i]]$awayTeamBatterCount, file="away_batter_count",
            col.names=FALSE, row.names=FALSE)

write.table(cc[[i]]$homeScore, file="home_score",
            col.names=FALSE, row.names=FALSE)
write.table(cc[[i]]$awayScore, file="away_score",
            col.names=FALSE, row.names=FALSE)


write.table(length(cc[[i]]$basesOccupied), file="bases_occupied",
            col.names=FALSE, row.names=FALSE)
