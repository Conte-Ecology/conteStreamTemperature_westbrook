Stream temperature model for the West Brook and tributaries
================================

Model of daily stream temperature for the West Brook and its tributaries. Results are reported here: https://peerj.com/articles/1727/

The data generation files are in the root directory and are prefixed by '1-', '2-', and '3-'. '4-westbrook-analysis.rmd' runs the model in Jags and '5-westbrook graphs and tebles.rmd' analyzes data and makes graphs and tables for the manuscript.

Input data are in /localData/tempDataSyncSUsed.RData. The variable in the data frame that defines the streams described in the manuscript is 'riverMS'. The variable 'riverOrdered' contains the actual river names found in the db.ecosheds.org database. [WB = West Brook, OL = Jimmy Nolan, OS = Mitchell Brook, IS = O'Bear Brook (or Ground Brook on Topo maps)]
