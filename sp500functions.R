# some utility functions

# calculates returns over specified period -> lag
instrumentRtn <- function(instrument, startDate, lag){
  
  # tseries financial data fetching function, default data provider Yahoo
  price         <- get.hist.quote(instrument, 
                                  quote="Adj", 
                                  start = startDate, 
                                  retclass = "zoo", 
                                  quiet = TRUE
                                  )
  monthlyPrice  <- aggregate(price, as.yearmon, tail, 1)
  monthlyReturn <- diff(log(monthlyPrice), lag)
  monthlyReturn <- exp(monthlyReturn) - 1
  return(monthlyReturn)
}


# returns instrument prices
instrumentPrice <- function(instrument, startDate){
  
  # tseries financial data fetching function, default data provider Yahoo
  price         <- get.hist.quote(instrument, 
                                  quote="Adj", 
                                  start = startDate, 
                                  retclass = "zoo", 
                                  quiet = TRUE
  )
  return(price)
}

# finds the position of date in sequence of dates
findDateValue <- function(x, theDate){
  pos <- match(as.yearmon(theDate), index(x))
  return(x[pos])
}
