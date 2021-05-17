In June 2016, the United Kingdom (UK) held a referendum to determine whether the country would "Remain" in the European Union (EU) or "Leave" the EU. This referendum is commonly known as Brexit. Although the media and others interpreted poll results as forecasting "Remain" (p>0.5), the actual proportion that voted "Remain" was only 48.1% (p=0.481) and the UK thus voted to leave the EU. Pollsters in the UK were criticized for overestimating support for "Remain". 


Question 2: Actual Brexit poll estimates

Load and inspect the brexit_polls dataset from dslabs, which contains actual polling data for the 6 months before the Brexit vote. Raw proportions of voters preferring "Remain", "Leave", and "Undecided" are available (remain, leave, undecided) The spread is also available (spread), which is the difference in the raw proportion of voters choosing "Remain" and the raw proportion choosing "Leave".

Calculate x_hat for each poll, the estimate of the proportion of voters choosing "Remain" on the referendum day (p=0.481), given the observed spread and the relationship d^=2X^−1. 


Question 3: Confidence interval of a Brexit poll

Consider the first poll in brexit_polls, a YouGov poll run on the same day as the Brexit referendum. Use qnorm() to compute the 95% confidence interval for X^. Does the 95% confidence interval predict a winner (does not cover  p=0.5 )? Does the 95% confidence interval cover the true value of  p  observed during the referendum?


Question 4: Confidence intervals for polls in June

Create the data frame june_polls containing only Brexit polls ending in June 2016 (enddate of "2016-06-01" and later). We will calculate confidence intervals for all polls and determine how many cover the true value of d.


Question 5: Hit rate by pollster

Group and summarize the june_polls object by pollster to find the proportion of hits for each pollster and the number of polls per pollster. Use arrange() to sort by hit rate.


Question 6: Boxplot of Brexit polls by poll type

Make a boxplot of the spread in june_polls by poll type.


Question 7: Combined spread across poll type

Calculate the confidence intervals of the spread combined across all polls in june_polls, grouping by poll type. Recall that to determine the standard error of the spread, you will need to double the standard error of the estimate.


Question 9: Chi-squared p-value

Define brexit_hit, with the following code, which computes the confidence intervals for all Brexit polls in 2016 and then calculates whether the confidence interval covers the actual value of the spread d=−0.038. 

Use brexit_hit to make a two-by-two table of poll type and hit status. Then use the chisq.test() function to perform a chi-squared test to determine whether the difference in hit rate is significant.


Question 10: Odds ratio of online and telephone poll hit rate

Use the two-by-two table constructed in the previous exercise to calculate the odds ratio between the hit rate of online and telephone polls to determine the magnitude of the difference in performance between the poll types.

Calculate the odds that an online poll generates a confidence interval that covers the actual value of the spread.


Question 11: Plotting spread over time

Use brexit_polls to make a plot of the spread (spread) over time (enddate) colored by poll type (poll_type). Use geom_smooth() with method = "loess" to plot smooth curves with a span of 0.4. Include the individual data points colored by poll type. Add a horizontal line indicating the final value of d=−.038.


Question 12: Plotting raw percentages over time

Use the following code to create the object brexit_long, which has a column vote containing the three possible votes on a Brexit poll ("remain", "leave", "undecided") and a column proportion containing the raw proportion choosing that vote option on the given poll. Make a graph of proportion over time colored by vote. Add a smooth trendline with geom_smooth() and method = "loess" with a span of 0.3.


