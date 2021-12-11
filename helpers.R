### Application name : CA1 B9DA101 - Statistics for Data Analytics
### Course : MSc (Data Analytics) - Sep 2019 - Group A 
### Developed by : Koyel Saha (10521711) / Monil Modi (10521306) / Parth Thakur (10520930)
### College : Dublin Business School 
### URL : https://parth-thakur.shinyapps.io/EOD_Analysis/


####>>>>BEGIN>>>> Monil Modi (10521306) >>>>

main_url <- "https://www.quandl.com/api/v3/datasets/WIKI/"
api_key <- readtext('secrets.txt')$text

my_read_csv <- function (path) {
  df <- read.csv(path)
  df$Date <- as.Date(df$Date)
  
  return(df)
}

get_final <- function(df) {
  df$daily_ret <- Delt(df$Close)
  df <- na.omit(df)
  
  df_daily_ret <- df[, c('Date', 'Close', 'daily_ret')]
  df_daily_ret$Date <- as.Date(df_daily_ret$Date)
  
  final <- 
    df_daily_ret %>%
    group_by(yer = year(Date), mon = month(Date)) %>%
    summarise(average = (sd(daily_ret)^2 * 12))
  
  final$date <- as.Date(paste(final$yer, final$mon, '01'), "%Y %m %d")
  
  return(final)
}

get_final_2 <- function(final){
  final_2 <- 
    final %>%
    mutate(rank = order(average)) %>%
    group_by(Month_ = mon) %>%
    summarise(rank_average = mean(rank)) %>%
    mutate(max_dev = abs(rank_average - mean(rank_average))) %>%
    mutate(max_dev = ifelse(max_dev == max(max_dev), T, F))
  
  return(final_2)
}

####<<<<END<<<< Monil Modi (10521306) <<<<

####>>>>BEGIN>>>> Parth Thakur (10520930) >>>>

hypothesis_result <- function(final_2) {
  x <- final_2[final_2$max_dev, ]
  xbar = x$rank_average
  
  t_stat = (xbar - mean(final_2$rank_average)) * sqrt(12) / sd(final_2$rank_average)
  
  test_statement <- paste('c-value at 5% sicnificance level: -2.81 <br>',
                          'We consider absolute value of c for a two tailed test. <br>',
                          'The value of test statistic (t-value) is:',  round(t_stat, 2), '<br>')
  
  if (abs(t_stat) >= 2.81) {
    result <- 'Since the absolute t-value is higher than absolute c-value, we reject the null hypothesis for this company. <br>
               Hence we can say that the highlighted month has a statistically different volatility than the rest.'
    
  } else {
    result <- 'Since the absolute t-value is lower than absolute c-value, we don\'t reject the null hypothesis for this company. <br>
               Hence we can say that the highlighted month does not have a statistically different volatility than the rest.'
  }
  
  return(paste(test_statement, result))
}

####<<<<END<<<< Parth Thakur (10520930) <<<<

####>>>>BEGIN>>>> Koyel Saha (10521711) >>>>

get_glm <- function(df) {
  
  indexes = sample(1:nrow(df), nrow(df) * .1)
  trainset = df[indexes, ] 
  testset = df[-indexes, ]
  
  model_ <- glm(Close~High+Low+Open, data = trainset, family="gaussian")
  
  model_summary_ <- summary(model_)
  
  predicted_ <- predict(model_, testset)
  
  rmse_ <- sqrt( (sum(predicted_ - testset$Close)^2) / (nrow(testset)) )
  
  predicted_df_ <- data.frame('Date' = testset$Date, 'Close' = testset$Close, 'predicted' = predicted_)
  
  return (list(model_summary = model_summary_,
              predicted_df = predicted_df_,
              rmse = rmse_))
}
####<<<<END<<<< Koyel Saha (10521711) <<<<