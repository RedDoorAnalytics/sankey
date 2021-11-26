local drive /Users/Michael/Documents/reddooranalytics/products/sankey
cd "`drive'"
adopath ++ "`drive''"
clear all

use "/Users/Michael/Documents/sankey/data/sankey.dta", clear
drop if freq==0
sankey start stop freq, arrange(freeform) 						///
		xpos1(0.1, order(10 11 12 13 15 112 113))					///
		xpos2(0.3, order(20 21 22 23 24 25 29 210 211 212 213))		///
		xpos3(0.5, order(30 31 32 33 34 35 312 313))				///
		xpos4(0.7, order(40 41 42 45 412 413))						
	
