#College scorecard from data.gov
#http://catalog.data.gov/dataset/college-scorecard/resource/bd6e47c1-836a-483f-b8c0-003abab6f0ad?inner_span=True

#Download Date: July 2016

#Data dictionary
#https://collegescorecard.ed.gov/assets/CollegeScorecardDataDictionary-09-08-2015.csv

#Download data
temporaryFile <- tempfile()
download.file("https://s3.amazonaws.com/ed-college-choice-public/Most+Recent+Cohorts+(Scorecard+Elements).csv",destfile=temporaryFile, method="curl")
dat <- read.csv(temporaryFile, na.strings = c("NULL", "PrivacySuppressed"))



#Rename variables
dat <- rename(dat, MedianIncome=md_earn_wne_p10)



#Important variables
#MedianIncome = median income 10 years post-entry
#SATAvg = average