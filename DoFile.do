*********************************
* 	Copyright © 2021, Chloe Wang
*********************************

clear 

use "C:\FilePath\lfs-71M0001-E-2017-july_F1.dta" 

append using "C:\FilePath\lfs-71M0001-E-2017-august_F1.dta" "C:\FilePath\lfs-71M0001-E-2017-september_F1.dta" "C:\FilePath\lfs-71M0001-E-2017-october_F1.dta" "C:\FilePath\lfs-71M0001-E-2017-november_F1.dta" "C:\FilePath\lfs-71M0001-E-2017-december_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-january_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-february_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-march_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-april_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-may_F1.dta" "C:\FilePath\lfs-71M0001-E-2018-june_F1.dta" 

*************************
*	Looking at the data
*************************

tab SURVMNTH
tab LFSSTAT
tab NAICS_21
tab CMA

sum HRLYEARN if NAICS_21==10 & SURVYEAR==2017  // retail 
sum HRLYEARN if NAICS_21==19 & SURVYEAR==2017  // accom. & food serv

tabstat HRLYEARN, by(NAICS_21)
tabstat HRLYEARN AHRSMAIN FTPTMAIN if SURVYEAR==2017, statistics(mean median) by(NAICS_21) 

// Histogram of wages for 2017 
tab HRLYEARN if NAICS_21==19 & SURVYEAR==2017 & AGE_12<=3
hist HRLYEARN if NAICS_21==19 & SURVYEAR==2017 & AGE_12<=3, xlabel(#15)

// Histogram of wages for 2018 
tab HRLYEARN if NAICS_21==19 & SURVYEAR==2018 & AGE_12<=3
hist HRLYEARN if NAICS_21==19 & SURVYEAR==2018 & AGE_12<=3, xlabel(#15)

// Statistics for hourly wages by FT/PT status in 2017
tabstat HRLYEARN if NAICS_21==19 & SURVYEAR==2017 & AGE_12<=3, by(FTPTMAIN)
tabstat HRLYEARN if NAICS_21==19 & SURVYEAR==2017 & AGE_12<=3 & PROV==35, by(FTPTMAIN)
hist HRLYEARN if NAICS_21==19 & SURVYEAR==2017 & AGE_12<=3, by(FTPTMAIN)

// Statistics for hourly wages by FT/PT status in 2018
tabstat HRLYEARN if NAICS_21==19 & SURVYEAR==2018 & AGE_12<=3, by(FTPTMAIN)
tabstat HRLYEARN if NAICS_21==19 & SURVYEAR==2018 & AGE_12<=3 & PROV==35, by(FTPTMAIN)
hist HRLYEARN if NAICS_21==19 & SURVYEAR==2018 & AGE_12<=3, by(FTPTMAIN)

browse HRLYEARN FTPTMAIN LFSSTAT if NAICS_21==19 & AGE_12<=3
sort LFSSTAT
tab LFSSTAT if NAICS_21==19 & AGE_12<=3

// Truncating data
drop if NAICS_21!=19 | AGE_12>3 


*********************
* Creating variables
*********************

* Creating date variables, where January 1st, 2018 is monthorder=0
gen monthorder = 0 
replace monthorder=-6 if SURVMNTH==7
replace monthorder=-5 if SURVMNTH==8
replace monthorder=-4 if SURVMNTH==9
replace monthorder=-3 if SURVMNTH==10
replace monthorder=-2 if SURVMNTH==11
replace monthorder=-1 if SURVMNTH==12
replace monthorder=1 if SURVMNTH==2
replace monthorder=2 if SURVMNTH==3
replace monthorder=3 if SURVMNTH==4
replace monthorder=4 if SURVMNTH==5
replace monthorder=5 if SURVMNTH==6


******************
* Creating dummies
******************
gen FEMALE=0
replace FEMALE=1 if SEX==2

gen married=0
replace married=1 if MARSTAT==1

gen AGE1516=0
replace AGE1516=1 if AGE_6==1

gen AGE1719=0
replace AGE1719=1 if AGE_6==2

gen AGE2021=0
replace AGE2021=1 if AGE_6==3

gen AGE2224=0
replace AGE2224=1 if AGE_6==4

gen AGE2526=0
replace AGE2526=1 if AGE_6==5

gen AGE2729=0
replace AGE2729=1 if AGE_6==6

gen dependents=0
replace dependents=1 if AGYOWNK<=3

gen singlejob=0
replace singlejob=1 if MJH==1


* Creating full- and part-time employment dummies for young workers aged 15-29 for ON, QC, MB, BC, Toronto, Montreal, Vancouver, and rest of Canada (ROC)

// Full-time
gen FTE_ON=0 
replace FTE_ON=1 if FTPTMAIN==1 & PROV==35

gen FTE_QC=0 
replace FTE_QC=1 if FTPTMAIN==1 & PROV==24

gen FTE_MB=0 
replace FTE_MB=1 if FTPTMAIN==1 & PROV==46

gen FTE_BC=0 
replace FTE_BC=1 if FTPTMAIN==1 & PROV==59

gen FTE_ROC=0 
replace FTE_ROC=1 if FTPTMAIN==1 & PROV!=35


gen FTE_TO=0 
replace FTE_TO=1 if FTPTMAIN==1 & CMA==4

gen FTE_MTL=0 
replace FTE_MTL=1 if FTPTMAIN==1 & CMA==2

gen FTE_VBC=0 
replace FTE_VBC=1 if FTPTMAIN==1 & CMA==9

// Part-time
gen PTE_ON=0
replace PTE_ON=1 if FTPTMAIN==2 & PROV==35

gen PTE_QC=0
replace PTE_QC=1 if FTPTMAIN==2 & PROV==24

gen PTE_MB=0
replace PTE_MB=1 if FTPTMAIN==2 & PROV==46

gen PTE_BC=0
replace PTE_BC=1 if FTPTMAIN==2 & PROV==59

gen PTE_ROC=0 
replace PTE_ROC=1 if FTPTMAIN==2 & PROV!=35


gen PTE_TO=0
replace PTE_TO=1 if FTPTMAIN==2 & CMA==4

gen PTE_MTL=0
replace PTE_MTL=1 if FTPTMAIN==2 & CMA==2

gen PTE_VBC=0
replace PTE_VBC=1 if FTPTMAIN==2 & CMA==9



***************************
* Examining Parallel Trends 
***************************

* Visual inspection of parallel trends between PROVINCES
// Aggregate the number of FTE for each month
preserve
collapse (sum) FTE_ON FTE_QC FTE_MB PTE_ON PTE_QC PTE_MB FTE_TO FTE_MTL PTE_TO PTE_MTL FTE_BC PTE_BC FTE_VBC PTE_VBC, by(monthorder)
// Calculate proportion of full-time employees
gen FTEP_ON = FTE_ON / (FTE_ON + PTE_ON)
gen FTEP_QC = FTE_QC / (FTE_QC + PTE_QC)
gen FTEP_MB = FTE_MB / (FTE_MB + PTE_MB)
gen FTEP_BC = FTE_BC / (FTE_BC + PTE_BC)
gen FTEP_TO = FTE_TO / (FTE_TO + PTE_TO)
gen FTEP_MTL = FTE_MTL / (FTE_MTL + PTE_MTL)
gen FTEP_VBC = FTE_VBC / (FTE_VBC + PTE_VBC)
// Graph
graph twoway (connected FTEP_ON monthorder) (connected FTEP_QC monthorder) (connected FTEP_MB monthorder) (connected FTEP_BC monthorder), xlabel(#12)
list


* Visual inspection of parallel trends between ONTARIO & QUEBEC
// Aggregate the number of FTE for each month
preserve
collapse (sum) FTE_ON FTE_QC PTE_ON PTE_QC, by(monthorder)
// Calculate proportion of full-time employees
gen FTEP_ON = FTE_ON / (FTE_ON + PTE_ON)
gen FTEP_QC = FTE_QC / (FTE_QC + PTE_QC)
// Graph
graph twoway (connected FTEP_ON monthorder) (connected FTEP_QC monthorder), xlabel(#12)
list


* Visual inspection of parallel trends between ONTARIO & ROC
// Aggregate the number of FTE for each month
preserve
collapse (sum) FTE_ON FTE_QC FTE_MB PTE_ON PTE_QC PTE_MB FTE_TO FTE_MTL PTE_TO PTE_MTL FTE_BC PTE_BC FTE_VBC PTE_VBC FTE_ROC PTE_ROC, by(monthorder)
// Calculate proportion of full-time employees
gen FTEP_ON = FTE_ON / (FTE_ON + PTE_ON)
gen FTEP_QC = FTE_QC / (FTE_QC + PTE_QC)
gen FTEP_MB = FTE_MB / (FTE_MB + PTE_MB)
gen FTEP_BC = FTE_BC / (FTE_BC + PTE_BC)
gen FTEP_TO = FTE_TO / (FTE_TO + PTE_TO)
gen FTEP_MTL = FTE_MTL / (FTE_MTL + PTE_MTL)
gen FTEP_VBC = FTE_VBC / (FTE_VBC + PTE_VBC)
gen FTEP_ROC = FTE_ROC / (FTE_ROC + PTE_ROC)
// Graph
graph twoway (connected FTEP_ON monthorder) (connected FTEP_ROC monthorder), xlabel(#12)
list


* Visual inspection of parallel trends between CITIES
// Aggregate the number of FTE for each month
preserve
collapse (sum) FTE_TO FTE_MTL PTE_TO PTE_MTL FTE_VBC PTE_VBC, by(monthorder)
// Calculate proportion of full-time employees
gen FTEP_TO = FTE_TO / (FTE_TO + PTE_TO)
gen FTEP_MTL = FTE_MTL / (FTE_MTL + PTE_MTL)
gen FTEP_VBC = FTE_VBC / (FTE_VBC + PTE_VBC)
// Graph
graph twoway (connected FTEP_TO monthorder) (connected FTEP_MTL monthorder) (connected FTEP_VBC monthorder), xlabel(#12)
list


************************************************************
* Comparing household characteristics bw ON & QC, and ON & ROC
* Using t-tests & regression
************************************************************

gen ON=0
replace ON=1 if PROV==35

ttest married if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV) 
reg married ON if (FEMALE==1 & SURVYEAR==2017)

ttest married if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg married ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE1516 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE1516 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE1516 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE1516 ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE1719 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE1719 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE1719 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE1719 ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE2021 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE2021 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE2021 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE2021 ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE2224 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE2224 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE2224 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE2224 ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE2526 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE2526 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE2526 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE2526 ON if (FEMALE==0 & SURVYEAR==2017)


ttest AGE2729 if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg AGE2729 ON if (FEMALE==1 & SURVYEAR==2017)

ttest AGE2729 if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg AGE2729 ON if (FEMALE==0 & SURVYEAR==2017)


ttest dependents if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg dependents ON if (FEMALE==1 & SURVYEAR==2017)

ttest dependents if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg dependents ON if (FEMALE==0 & SURVYEAR==2017)


ttest singlejob if (PROV==35 & FEMALE==1 & SURVYEAR==2017) | (PROV==24 & FEMALE==1 & SURVYEAR==2017), by(PROV)
reg singlejob ON if (FEMALE==1 & SURVYEAR==2017)

ttest singlejob if (PROV==35 & FEMALE==0 & SURVYEAR==2017)  | (PROV==24 & FEMALE==0 & SURVYEAR==2017), by(PROV)
reg singlejob ON if (FEMALE==0 & SURVYEAR==2017)


********************
* D-in-D Estimation
********************

gen FTE=0 
replace FTE=1 if FTPTMAIN==1 
gen PTE=0 
replace PTE=1 if FTPTMAIN==2 
gen FTEP = FTE / (FTE + PTE)


* Dummy variable to indicate time when treatment started. Post treatment effects=1 for 2018 
gen POST = (SURVYEAR==2018)

* Dummy variable for treatment group
gen ONT = (PROV==35)

* Interaction between treatment and time
gen DID = ONT*POST

* Simple D-in-D regression
reg FTEP ONT POST DID, robust

******************
* D-in-D Method 1
******************
// Dummies for covariates
gen inschool = (SCHOOLN==2 | SCHOOLN==3)
gen singlejobholder = (MJH==1)
gen immigrant = (IMMIG==1 | IMMIG==2)
gen smfirm = (ESTSIZE==1)
gen medfirm = (ESTSIZE==2)

quietly tabulate PROV
display r(r)

reg FTEP ONT POST DID AGE_6 EDUC FEMALE immigrant married smfirm medfirm AHRSMAIN ATOTHRS dependents singlejobholder inschool UHRSMAIN, cluster(PROV)

******************
* D-in-D Method 2
******************
diff FTEP, treated(ONT) period(POST) cov(AGE_6 EDUC FEMALE immigrant married smfirm medfirm AHRSMAIN ATOTHRS dependents singlejobholder inschool UHRSMAIN)

