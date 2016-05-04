# TeamGOATS
Zika virus forecast

######################
CONTACT INFO
Kelly Schroeder
kschroed@bu.edu
307-399-5248

Emily Chua
ejchua@bu.edu
617-840-6331

Stephen Caron
caronst@bu.edu
781-264-4383

Andrew Pineda 
ajpineda@bu.edu

Andre Schettino
schettin@bu.edu
617-784-1217

######################
DATA
-Buzzfeed Repo:
  -Colombia's Zika data updated weekly from 2016-01-09 to 2016-02-20; stored 
  in the table "total" within get_data.R

-Google Trends:
  -Data updated daily and stored in "zika_trends"" within    
   get_googletrends_data.R 
  -NOTE: Did not end up using this data
   
CRON SETTINGS
-All updates emailed to zikaforecast@gmail.com

######################
ORDER OF R SCRIPTS
1) get_data.R
    -sets the working directory
    -scrapes Github for Buzzfeed Colombia Zika data
    -divides up Colombia by department
    -saves all objects into "zika.RData"
2) model_test_new.R
    -fits the model to the 7 weeks of available data using a Random Walk model
      -includes a departmental effect
    -visualizes the model and data time series with confidence estimates
    -visualizes the MCMC diagnostics and saves the MCMC output
3) initial_forecast.R
    -generates an initial ensemble forecast for the 7 weeks + out through weeks 8 to 20
    -uses 500 MC simulations
    -holds out a randomly-chosen initial forecast as our "pseudo-data"
4) sensitivity_analysis.R
    -performs the sensitivity and uncertainty analyses
5) EnKF.R
    -uses an Ensemble Kalman Filter to iteratively update the analysis and forecast steps on a weekly basis
