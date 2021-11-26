//build new version 
//either for website or SSC
// --> run whole do file

//!!
// BUILD in 16
//!!


//local drive Z:/
local drive /Users/Michael/Documents
cd `drive'/sankey/

local sscbuild 		= 0

//=======================================================================================================================//

//build for SSC -> current version up is ????
if `sscbuild' {
	local sscversion 1_0_0
	cap mkdir ./ssc/version_`sscversion'
	local fdir /Users/Michael/Documents/sankey/ssc/version_`sscversion'/
}
//build for website -> 1.2.0
else {
	local fdir /Users/Michael/Documents/website/static/code/sankey/
}


//=======================================================================================================================//

//pkg files
if `sscbuild' {
	copy ./ssc/sankey_details.txt `fdir', replace
}
else {
	copy ./build/sankey.pkg `fdir', replace
	copy ./build/stata.toc `fdir', replace
}
	
//=======================================================================================================================//

//stmixed
copy ./sankey/sankey.ado `fdir', replace

//help files
copy ./sankey/sankey.sthlp `fdir', replace

