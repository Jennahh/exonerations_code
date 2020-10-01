**code for short paper project on exonerations,
**FINAL CODE OUTPUT+ GRAPH
**code written by Jennah Haque: jhaque@mit.edu

******************************
** Useful packages to install
******************************
ssc install unique
ssc install fre
ssc install binscatter
ssc install estout, replace
ssc install eventdd, replace
ssc install matsort
**************************
** Setting up your dofile
**************************

clear all
set more off

// Change this to your path!
cd "/Users/jennahhaque/Desktop/"

**********************
** Loading your data
**********************

*Loading exonerations csv file
import delimited "exonerations_policy.csv"


**looking at data
br
summarize
tab race /* quite interesting: Black peple made up 49% of exonerations*/
tab age /* The group hit the hardest by exonerations were people aged 17-26 */
fre state /* 11% of all crimes occured in New York. Almost 13% in Illinois, 14.5% in Texas */
fre region /* Nearly a quarter of all crimes are happening in East North Central */

fre age if race == "Hispanic" /* Hispanics and Blacks getting convicted at much younger ages than White people */



tab sentence if race == "Hispanic"
sum exonerated if race == "Hispanic"
sum convicted if race == "Hispanic"


tab sentence if age >=17 & age <= 26
tab race if age >=17 & age <= 26

gen Length_exoneration = exonerated-convicted
sum Length_exoneration



**********************
** Note on length til exoneration: Avg = 11.14
*Black avg = 13.00
*White avg = 9.53
*Hispanic avg = 8.88
**********************


tab sentence if  worstcrime == "Murder"
tab sentence if race == "Black" & worstcrime == "Murder"
tab sentence if race == "Hispanic" & worstcrime == "Murder"
tab sentence if race == "White" & worstcrime == "Murder"
**repeat this in console to see patterns for sexual assault and Drug Possession or Sale**


tab sentence if race == "Black" & worstcrime == "Murder" & age >=17 & age <= 26
tab sentence if race == "White" & worstcrime == "Murder" & age >=17 & age <= 26
tab sentence if race == "Hispanic" & worstcrime == "Murder" & age >=17 & age <= 26
**repeat this in console to see patterns for sexual assault and Drug Possession or Sale**


**********************
**Black people are getting probation way less often compared to white and hispanic counterparts. Whites get probation more than hispanics
**********************


tab worstcrime if race == "Black"


// saving dta file
save "exonerations.dta", replace

**********************
** Cleaning the data
**********************

// using a dataset that is in your folder
	clear
	use "exonerations.dta", clear
	
	
	**change demographic variables to integers for regression**
	gen Black = 1 if race == "Black"
	replace Black = 0 if race != "Black"
	
	gen Hispanic = 1 if race == "Hispanic"
	replace Hispanic = 0 if race != "Hispanic"
	
	gen NA = 1 if race == "Native American"
	replace NA= 0 if race != "Native American"
	
	gen Female = 1 if sex == "Female"
	replace Female = 0 if sex != "Female"
	
	gen young_age = 1
	replace young_age = 0 if age < 17
	replace young_age = 0 if age > 26
	
	**codify policy information, get lags and leads**
	gen Post_event = 1 if convicted >= policy
	replace Post_event = 0 if convicted < policy

	generate Time_policy = convicted-policy
	
	
	
	
**********************
** Analyzing the data
**********************	
	
	 **crime and state fixed effects**
	 tabulate worstcrime, generate (crime_)
	 tabulate state, generate (state_)
	 
	 **get diff in diff estimator by running regression**
	 eventdd Length_exoneration young_age Black Hispanic NA Female crime_* state_*, timevar(Time_policy) ci(rcap) accum lags(17) leads(17) graph_op(title("Time wrongfully in jail, pre/post minimum sentencing reform") ytitle("years between conviction and exoneration")) r
	 

	**This will make figure 1**
	graph export "/Users/jennahhaque/Desktop/Figure2.eps", as(eps) name("Graph") preview(off) replace
	
	estimates store m1, title(Model 1)
	
**********************
**Outputting the data
**********************		
	
	estout m1, keep (young_age Black Hispanic NA Female) cells(b(star fmt (3)) se(par fmt(2))) stats(N r2, labels("N" "R-squared") fmt(0 2)) starlevels( * 0.10 ** 0.05 *** 0.010)
	
	
	**This will make Table 1**
	esttab m1 using "table1.tex", replace
	
	
	
	                                                                                                                                                                                                                                                                                                     
	
	


