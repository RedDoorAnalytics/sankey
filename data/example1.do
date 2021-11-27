local drive /Users/Michael/Documents/reddooranalytics/products/sankey

adopath ++ "`drive'"
clear all
set seed 986786
set obs 10
gen start = _n 
gen stop = ceil(runiform()*5)
gen freq = ceil(runiform()*100)

forvalues i=1/10 {
	local labs `labs' `i' "A`i'"
	
}
label define statelabs `labs'
label values start statelabs
label values stop statelabs

// save /Users/Michael/Documents/website/static/data/sankey_eg1.dta,replace
