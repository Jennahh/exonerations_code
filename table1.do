**code for short paper project on exonerations,TABLE 1
**FINAL CODE OUTPUT
**code written by Jennah Haque: jhaque@mit.edu

******************************
** Useful packages to install
******************************
ssc install unique
ssc install fre
ssc install binscatter
ssc install estout, replace
ssc install tabout
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
import delimited "50_us_state_names.csv"

table state first_reform
tabout state first_reform using "Table1.tex"






	
