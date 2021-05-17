# suggested libraries and options
library(tidyverse)
options(digits = 3)

# load brexit_polls object
library(dslabs)
data(brexit_polls)

p <- 0.481    # official proportion voting "Remain"
d <- 2*p-1    # official spread

#Sample size
N <- 1500

##Q1. 
#Expected total number of voters in the sample choosing "Remain"
exp <- p*N
#Standard error of the total number of voters in the sample choosing "Remain"
sqrt(N * p * (1 - p))
#Expected value of  X^ , the proportion of "Remain" voters
x_hat <- p
#Standard error of  X^ , the proportion of "Remain" voters
standard_error_x_hat <- sqrt(x_hat * (1-x_hat)/N)
#Expected value of ???? , the spread between the proportion of "Remain" voters and "Leave" voters
d <- 2*x_hat -1
#Standard error of ???? , the spread between the proportion of "Remain" voters and "Leave" voters
se_d <- 2 * standard_error_x_hat


##Q2
head(brexit_polls)
#add variable x_hat to the brexit_polls
brexit_polls <- brexit_polls %>% mutate(x_hat = (spread + 1) /2)
#mean of the observed spreads
mean(brexit_polls$spread)
#standard deviation of the observed spreads
sd(brexit_polls$spread)
#average of x_hat, the estimates of the parameter  p
mean(brexit_polls$x_hat)
#standard deviation of x_hat
sd(brexit_polls$x_hat)


##Question 3: Confidence interval of a Brexit poll
brexit_temp <- brexit_polls %>% mutate(se_xhat = sqrt(x_hat*(1-x_hat)/samplesize))
#lower bound of the 95% confidence interval of x_hat of YouGov poll
brexit_temp[1,]$x_hat - qnorm(0.975)*brexit_temp[1,]$se_xhat
#upper bound
brexit_temp[1,]$x_hat + qnorm(0.975)*brexit_temp[1,]$se_xhat


##Question 4: Confidence intervals for polls in June
june_polls <- brexit_polls %>% 
  filter(enddate >= "2016-06-01") %>% 
  mutate(se_x_hat = sqrt(x_hat*(1-x_hat)/samplesize))

#num of polls in june_polls
nrow(june_polls)
#calc CI of spread
june_polls <- june_polls %>% 
  mutate(se_spread = 2*se_x_hat, lower = spread - qnorm(0.975)*se_spread, upper = spread + qnorm(0.975)*se_spread, hit = (june_polls$lower <= d & june_polls$upper >= d))
#proportion of polls have a confidence interval that covers the value 0
mean(june_polls$lower <= 0 & june_polls$upper >= 0)
#proportion of polls predict "Remain" (confidence interval entirely above 0)
mean(june_polls$lower > 0)
#proportion of polls have a confidence interval covering the true value of  d
mean(june_polls$hit)


##Question 5: Hit rate by pollster
#Group and summarize the june_polls object by pollster to find the proportion of hits for each pollster and the number of polls per pollster. 
june_polls %>% group_by(pollster) %>% summarize(num = n(), prop_hits = mean(hit)) %>% arrange(prop_hits)


##Question 6: Boxplot of Brexit polls by poll type
boxplot(june_polls$spread~as.factor(june_polls$poll_type))


##Question 7: Combined spread across poll type
#determines the total sample size per poll type, gives each spread estimate a weight based on the poll's sample size, and adds an estimate of p from the combined spread
combined_by_type <- june_polls %>%
  group_by(poll_type) %>%
  summarize(N = sum(samplesize),
            spread = sum(spread*samplesize)/N,
            p_hat = (spread + 1)/2, se_spread = 2*sqrt(p_hat*(1-p_hat)/N))
#95% confidence interval for online voters
combined_by_type[1,]$spread - qnorm(0.975)*combined_by_type[1,]$se_spread
combined_by_type[1,]$spread + qnorm(0.975)*combined_by_type[1,]$se_spread
#confidence intervals for the combined spreads for each poll type 
uppers <- combined_by_type$spread + qnorm(0.975)*combined_by_type$se_spread
lowers <- combined_by_type$spread - qnorm(0.975)*combined_by_type$se_spread
#online poll size
uppers[1] - lowers[1]
#telephone poll size
uppers[2] - lowers[2]
-0.038 < lowers

##Question 9: Chi-squared p-value
brexit_hit <- brexit_polls %>%
  mutate(p_hat = (spread + 1)/2,
         se_spread = 2*sqrt(p_hat*(1-p_hat)/samplesize),
         spread_lower = spread - qnorm(.975)*se_spread,
         spread_upper = spread + qnorm(.975)*se_spread,
         hit = spread_lower < -0.038 & spread_upper > -0.038) %>%
  select(poll_type, hit)
#make a two-by-two table of poll type and hit status
two_by_two <- brexit_hit %>% group_by(poll_type, hit) %>% summarize(num = n()) %>% spread(poll_type, num)
#chi-squared test
two_by_two %>% select(-hit) %>% chisq.test()
#which poll type has a higher probability of producing a confidence interval that covers the correct value of the spread
two_by_two[[2, 2]]/sum(two_by_two[[2]])
two_by_two[[2, 3]]/sum(two_by_two[[3]])


##Question 10: Odds ratio of online and telephone poll hit rate
#online odds
online_odds <- two_by_two[[2, 2]]/two_by_two[[1, 2]]
#telephone odds
tele_odds <- two_by_two[[2, 3]]/two_by_two[[1, 3]]
#how many times larger the odds are for online polls to hit versus telephone polls
online_odds/tele_odds


##Question 11: Plotting spread over time
brexit_polls %>% ggplot(aes(enddate, spread, col = poll_type)) + 
  geom_smooth(method = "loess", span = 0.4) + 
  geom_point() +
  geom_abline(slope = 0, intercept = d)


##Question 12: Plotting raw percentages over time
brexit_long <- brexit_polls %>%
  gather(vote, proportion, "remain":"undecided") %>%
  mutate(vote = factor(vote))

head(brexit_polls)
head(brexit_long)

str(brexit_polls)
str(brexit_long)

brexit_long %>% ggplot(aes(enddate, proportion, col=vote)) + 
  geom_smooth(method = "loess", span = 0.3)