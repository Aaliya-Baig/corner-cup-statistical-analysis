# =====================================================
# The Corner Cup Coffee Chain - Group Work 1
# Part C: Regression & Probability (R)
# Author: Group 5 (Aaliya, Azra, Fathima, Shubhangi, Shruti)
# =====================================================

# =====================================================
# C1. SIMPLE LINEAR REGRESSION
# Goal: predict Monthly_Revenue_000 from Daily_Customers
# =====================================================

# Load the CSV file into a data frame called 'data'
data <- read.csv("GW1_CornerCup_Data.csv")

# Check that all 12 shops and 8 columns loaded correctly
str(data)
head(data)


# Scatter plot of Daily_Customers (x) vs Monthly_Revenue_000 (y)
# pch = 19 draws solid dots
plot(data$Daily_Customers, data$Monthly_Revenue_000,
     main = "Daily Customers vs Monthly Revenue",
     xlab = "Daily Customers",
     ylab = "Monthly Revenue ($000)",
     pch  = 19)

# Fit the linear model: Revenue = b0 + b1 x Customers
# The ~ means "is predicted by"
model <- lm(Monthly_Revenue_000 ~ Daily_Customers, data = data)

# Add the red regression line to the scatter plot
abline(model, col = "red", lwd = 2)

# Show the full regression results
summary(model)

# Pull out the three numbers the report needs
b0 <- coef(model)[1]                   # intercept
b1 <- coef(model)[2]                   # slope
r_squared <- summary(model)$r.squared  # R-squared

b0
b1
r_squared

# Predict monthly revenue for a new shop with 300 daily customers
predict(model, data.frame(Daily_Customers = 300))

# Manual check using the equation b0 + b1 x 300
b0 + b1 * 300

# -----------------------------------------------------
# C1 RESULTS
# Intercept (b0) = -2.785
# Slope (b1)     = 0.2760
# R-squared      = 0.7684 (Adjusted R-squared = 0.7453)
# Regression equation:
#   Revenue ($000) = -2.785 + 0.2760 x Daily_Customers
# Prediction for 300 customers per day:
#   -2.785 + 0.2760 x 300 = -2.785 + 82.80 = 80.02
#   so about $80,016 per month
#
# C1 INTERPRETATION
# The slope of 0.276 means each additional daily customer is associated
# with about $276 more in monthly revenue. The intercept of -2.785 has no
# practical meaning, since no shop has zero customers; it only positions
# the line. R-squared is 0.768, so daily customers explain about 77% of
# the variation in monthly revenue, which is strong, and the slope is
# highly significant (p = 0.0002). The remaining 23% comes from other
# factors, mainly average spend: Airport Terminal earns about $27.5K less
# than predicted because its customers spend only $6.90, while Harbour
# View earns $26.7K more because they spend $11.20. The $80K prediction
# for a 300-customer shop is reasonable because 300 is within our data
# range (149 to 441), but with only 12 shops and a residual standard
# error of $14K, Maya should treat it as an estimate, not a guarantee.
# -----------------------------------------------------


# =====================================================
# C2. PROBABILITY ANALYSIS
# =====================================================

# -----------------------------------------------------
# Question 1: P(a random shop earns more than $80,000 per month)
# Revenue is stored in $000s, so $80,000 = 80
# -----------------------------------------------------
high_revenue <- data$Monthly_Revenue_000 > 80   # TRUE/FALSE for each shop
data$Shop_Name[high_revenue]                     # which shops are above 80
sum(high_revenue)                                # how many (TRUE counts as 1)
nrow(data)                                       # total number of shops
sum(high_revenue) / nrow(data)                   # the probability

# Q1 WORKING
# Shops above $80K: Airport Terminal (91.4), Midtown Mall (95.5),
# Harbour View (131.0), Tech Campus (87.7) = 4 shops
# P(Revenue > 80) = shops above 80K / total shops = 4 / 12 = 0.3333
# Answer: 0.3333, or 33.33%


# -----------------------------------------------------
# Question 2: Binomial distribution
# 5 new suburban shops, each with a 40% chance of high revenue
# Binomial fits because: fixed number of trials (5 shops), each is a
# success or failure, the same probability for each (0.40), and the
# shops are assumed independent
# -----------------------------------------------------
n <- 5
p <- 0.40

# (a) Expected number of high-revenue shops: E(X) = n x p
n * p

# (b) P(X = 2): dbinom gives the probability of exactly 2 successes
dbinom(2, size = n, prob = p)

# (c) P(X >= 1) = 1 - P(X = 0); pbinom(0) gives P(X <= 0)
1 - pbinom(0, size = n, prob = p)

# Extra: P(X <= 2), used in the recommendations
pbinom(2, size = n, prob = p)

# Extra: the full probability distribution for X = 0 to 5
data.frame(X = 0:5, Probability = round(dbinom(0:5, n, p), 4))

# Q2 WORKING
# (a) E(X) = n x p = 5 x 0.40 = 2 shops
# (b) P(X = 2) = C(5,2) x 0.40^2 x 0.60^3 = 10 x 0.16 x 0.216 = 0.3456
# (c) P(X >= 1) = 1 - P(X = 0) = 1 - 0.60^5 = 1 - 0.07776 = 0.9222
# Answers: (a) 2 shops, (b) 0.3456 (34.56%), (c) 0.9222 (92.22%)


# -----------------------------------------------------
# Question 3: Poisson distribution
# Airport Terminal, average 18 customers per hour (441 / 24 = 18.4)
# -----------------------------------------------------
lambda <- 18

# (d) P(X = 20): dpois gives the probability of exactly 20 customers
dpois(20, lambda = lambda)

# (e) P(X >= 25) = 1 - P(X <= 24); ppois(24) gives P(X <= 24)
1 - ppois(24, lambda = lambda)

# (f) Mean = lambda; standard deviation = square root of lambda
lambda
sqrt(lambda)

# Extra: expected number of peak hours (25+ customers) per day
24 * (1 - ppois(24, lambda = lambda))

# Q3 WORKING
# (d) P(X = 20) = (e^-18 x 18^20) / 20! = 0.0798
# (e) P(X >= 25) = 1 - P(X <= 24) = 1 - 0.9317 = 0.0683
#     (24 is used because X >= 25 means everything above 24)
# (f) E(X) = lambda = 18 customers per hour
#     SD = sqrt(lambda) = sqrt(18) = 4.243
# Answers: (d) 0.0798 (7.98%), (e) 0.0683 (6.83%), (f) mean 18, SD 4.24



# -----------------------------------------------------
# C2 INTERPRETATION
# Only one in three existing shops (33%) earns more than $80K a month,
# so high revenue is not the norm. If Maya opens 5 suburban shops with a
# 40% success chance each, she should expect 2 high performers. There is
# a 92% chance at least one succeeds, but a 68% chance that 2 or fewer
# do, so she should plan for most new shops to be average performers.
# At Airport Terminal, an hour with 25 or more customers happens about
# 6.8% of the time, roughly 1.6 hours a day, so a flexible peak-hour
# staffing plan (an extra barista on call) makes more sense than
# permanently higher staffing.
# -----------------------------------------------------