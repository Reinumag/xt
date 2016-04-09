library(tseries)
library(quantmod)
library(httr)
library(XML)
library(ggplot2)

source("sp500functions.R")


# Get tickers
sp        <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies#S.26P_500_Component_Stocks"
page      <- GET(sp, user_agent("httr"))
tables    <- readHTMLTable(content(page, as = 'text'), as.data.frame=TRUE)
tickers   <- as.matrix(tables[[1]]["Ticker symbol"])

# alternatively, use own tickers.. 9 out of 11 spdr SPY sectors. + SPY itself
# The other two sectors are really subsectors with too short histories 
tickers   <- c("XLY", "XLP", "XLE", "XLF", "XLV", "XLI", "XLB", "XLK" ,"XLU", "SPY")

# Build timeline
startDate <- "2000-01-01"
theDates    <- as.yearmon(seq(as.Date(startDate), to = Sys.Date(), by = "month"))


dataFactor <- list()
dataRtn    <- list()
dataPrice  <- list()
number.of.stocks <- 10 # length(tickers)

for (i in 1:number.of.stocks) {
  #print(tickers[i])
  dataPrice[[i]]  <- instrumentPrice(tickers[i], startDate)
  #dataFactor[[i]] <- instrumentRtn(tickers[i], startDate, lag = 12)
  #dataRtn[[i]]    <- instrumentRtn(tickers[i], startDate, lag = 1)
}

p1 <-

# # Old information criterion calulation part from web - I'm not really interested in that atm
# factorStats <- NULL
# for (i in 1:(length(theDates) - 1)){
#   
#   factorValue <- unlist(lapply(dataFactor,
#                                findDateValue,
#                                theDate = as.yearmon(theDates[i])
#                                )
#                         )
#   
#   if (length(which(!is.na(factorValue))) > 1){
#     #print(theDates[i])
#     bucket   <- cut(factorValue, 
#                     breaks = quantile(factorValue, probs = seq(0,1,0.2), na.rm = TRUE),
#                     labels = c(1:5),
#                     include.lowest = TRUE)
#     rtnValue <- unlist(lapply(dataRtn, findDateValue, theDate = as.yearmon(theDates[i+1])))
#     
#     ##IC
#     ic       <- cor(factorValue, rtnValue, method = "spearman", use = "pairwise.complete.obs")
#     
#     ##QS
#     quantilesRtn <- NULL
#     
#     for (j in sort(unique(bucket))){
#       pos          <- which(bucket == j)
#       quantilesRtn <- cbind(quantilesRtn, median(rtnValue[pos], na.rm = TRUE))
#     }
#     factorStats <- rbind(factorStats, cbind(quantilesRtn, ic))
#   }
#   
# }
# 
# colnames(factorStats) <- c("Quant1","Quant2","Quant3","Quant4","Quant5","IC")
# 
# qs <- apply(factorStats[,c("Quant1","Quant2","Quant3","Quant4","Quant5")], 2, median, na.rm = TRUE)
# ic <- round(median(factorStats[,"IC"], na.rm = TRUE), 4)
# 
# 
# # Plotting
# par(cex = 0.8, mex = 0.8)
# bplot <- barplot(qs,
#                  border = NA,
#                  col    = "royal blue",
#                  ylim   = c(0,max(qs)+0.005),
#                  main   = "S&P500 Universe \n 12 Months Momentum Return - IC and QS")
# abline(h = 0)
# legend("topleft",
#        paste("Information Coefficient = ", ic, sep=""),
#        bty = "n")