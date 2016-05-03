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
   
CRON SETTINGS
All updates emailed to zikaforecast@gmail.com

######################
ORDER OF R SCRIPTS
1) get_data.R
2) model_test_new.R
3) initial_forecast.R
4) sensitivity_analysis.R
5) EnKF.R


