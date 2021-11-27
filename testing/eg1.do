
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

gen xc = start/10
gen yc = runiform()

sankey start stop freq , colors(1 "blue" 2 "green" 3 "blue") 	///
                        title("Example Sankey plot") 		///
                        arrange(freeform)					
							
