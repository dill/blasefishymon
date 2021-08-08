#
library(httr)


rr <- GET("https://api.sibr.dev/chronicler/v1/games/updates?limit=1")

cc <- lapply(content(rr)$data, `[[`, "data")
#cc <- lapply(cc, function(xx) as.data.frame(Filter(function(x) length(x)>0,xx)))
#cc <- do.call(rbind.data.frame, cc)

write.table(cc[[1]]$homeTeamBatterCount, file="home_batter", col.names=FALSE, row.names=FALSE)


