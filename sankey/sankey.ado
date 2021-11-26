*! 23jun2020 version 1.3.0 MJC

/*
History


23jun2020: version 1.3.0 - x() and y() added to allow specification of coordinates for node placement
22jun2020: version 1.2.0 - if/in added
						 - bug fix; when the same label was applied to multiple different states, it only labelled one of them -> now fixed
22jun2020: version 1.1.0 - added bgcolor() to change background color
						 - added arrange() to change node arrangements
21jun2020: version 1.0.0 - initial release
*/

program sankey
	version 16
	syntax [varlist(min=3)] [if] [in]	,									///
											[								///
												TITLE(string)				///
												COLORS(string)				///
												LINKColor(string)			///
												BGCOLOR(string)				///
												NOLABELS					///
																			///
												ARRANGE(string)				///
												*							/// 
											]
	

	capture python which plotly
	if _rc {
		di as error "You need to install the plotly python library"
		exit 198
	}
	
	local start : word 1 of `varlist'
	local stop : word 2 of `varlist'
	local freq : word 3 of `varlist'
	
	if "`arrange'"=="" {
		python: arrange = "snap"
	}
	else if "`arrange'"!="snap" & "`arrange'"!="perpendicular" & "`arrange'"!="fixed" & "`arrange'"!="freeform" {
		di as error "arrange() must be one of snap, perpendicular, fixed or freeform"
		exit 198
	}
	else {
		python: arrange = "`arrange'"
	}
	
	//xpos#()
	local opts `options'
	local Nxp	= 0
	local ind 	= 1
	while "`opts'"!="" {
		local 0 , `opts'
		syntax , [XPOS`ind'(string) * ]
			local opts `options'
			local 0 "`xpos`ind''"
			syntax anything, ORDER(numlist min=1)
			local x`ind' `anything'
			local order`ind' `order'
			local Nxp = `Nxp' + `: word count `order''
		local ind = `ind' + 1
	}
	local Nxpos = `ind' - 1
	
	//=================================================================================================//
	
	marksample touse
	markout `touse' `varlist'
	
	// labels
	python: labels = []
	local labname1 : value label `start'
	local labname2 : value label `stop'
	
	if ("`labname1'"!="" & "`labname2'"=="") | ("`labname1'"=="" & "`labname2'"!="") {
		di as error "Both start and stop variables require value labels"
		exit 198
	}
	
	if ("`labname1'"!="") & "`nolabels'"=="" { 
		
		qui levelsof `start', local(startstates)
		tempvar labs1

		qui gen `labs1' = "" if `touse'
		local index = 1
		foreach lab in `startstates' {
			qui replace `labs1' = "`: label `labname1' `lab''" if `start'==`lab'
			local index = `index' + 1
		}
		
		qui levelsof `stop', local(stopstates)
		tempvar labs2
		qui gen `labs2' = "" if `touse'
		local index = 1
		foreach lab in `stopstates' {
			qui replace `labs2' = "`: label `labname2' `lab''" if `stop'==`lab'
			local index = `index' + 1
		}

	}
	
	//find all unique states and post newly indexed versions
	
	qui sort `start' `stop'
	tempvar s0 s1
	
	mata: getnewstates()
	
	python: start 	= np.asarray(Data.get("`s0'",None,"`touse'"))
	python: stop 	= np.asarray(Data.get("`s1'",None,"`touse'"))
	python: freq 	= np.asarray(Data.get("`freq'",None,"`touse'"))
	
	//=================================================================================================//
	// plot appearance
	
	// title
	if "`title'"=="" {
		python: title = ""
	}
	else {
		python: title = "`title'"
	}
	
	//background color
	if "`bgcolor'"=="" {
		python: bgcolor = "white"
	}
	else {
		python: bgcolor = "`bgcolor'"
	}
	
	// node colors
	python: colors = "black"
	if "`colors'"!="" { 
		tempvar nodecolors
		qui gen `nodecolors' = "black" if `touse'
		
		tokenize `colors' 
		local index 	= 1
		while "`1'"!="" {
			cap confirm num `1'
			if _rc {
				di in red "invalid colors(... `1' `2' ...)"
				exit 198
			}
			
			//!!add check for valid colors
			
			qui replace `nodecolors' = "`2'" if _n==`index'
			mac shift 2
			local index = `index' + 1
		}

		python: colors 	= np.asarray(Data.get("`nodecolors'",None,"`touse'"))
	}
	
	if "`linkcolor'"=="" {
		python: linkcolor = "lightblue"
	}
	else {
		python: linkcolor = "`linkcolor'"
	}

	//=================================================================================================//
	python: sankey()
	
	//tidy up
	mata mata drop newlabs newxvals newyvals
	
end

program sankey_error
	di as error `0'
	exit 198
end

version 16.0

mata:
void getnewstates()
{
	start 	= st_data(.,st_local("start"),st_local("touse"))
	stop 	= st_data(.,st_local("stop"),st_local("touse"))
	Nobs	= rows(start)

	unique	= uniqrows(start\stop)
	Nstates	= rows(unique)
	st_local("Nstates",strofreal(Nstates))
	
	newunique = 0::(Nstates-1)
	newstart = newstop = J(Nobs,1,.)
	
	//label setup
	labname1 	= st_local("labname1")
	labname2 	= st_local("labname2")
	haslabs		= labname1!=""
	external newlabs
	if (haslabs) 	{
		startlabs 	= st_sdata(.,st_local("labs1"),st_local("touse"))
		stoplabs	= st_sdata(.,st_local("labs2"),st_local("touse"))		
		newlabs 	= J(Nstates,1,"")
	}
	else newlabs = ""
	
	//xpos,ypos
	external newxvals, newyvals
	if (st_local("xpos1")!="") {
		
		Nxpos 	= strtoreal(st_local("Nxpos")) 	//# of xpos#()
		Nxps	= strtoreal(st_local("Nxp"))	//total number of states spec'd
		
		positions = J(0,3,.) //state,x,y
		
		for (i=1;i<=Nxpos;i++) {
			
			s 	= tokens(st_local("order"+strofreal(i)))'
			Ns 	= rows(s)
			x 	= J(Ns,1,strtoreal(st_local("x"+strofreal(i))))
			
			index = 1::Ns
			
			s
			x
			exit(1986)
		}
		
		
		
	}
	
	
	//=================================================================================================//
	
	//find unique states (and labels)
	for (i=1;i<=Nstates;i++) {
		labdone = xdone = ydone = 0
		//appears in start
		index = selectindex(start:==unique[i])
		nrows = rows(index)
		if (nrows & cols(index)) {
			newstart[index] = J(nrows,1,newunique[i])
			if (haslabs) {
				newlabs[i] = startlabs[index][1]
				labdone = 1
			}
		}

		//appears in stop
		index = selectindex(stop:==unique[i])
		nrows = rows(index)
		if (nrows & cols(index)) {
			newstop[index] = J(nrows,1,newunique[i])
			if (haslabs & !labdone) newlabs[i] = stoplabs[index][1]
		}
	}

	//post new starts and stops
	id1 = st_addvar("float",st_local("s0"))
	id2 = st_addvar("float",st_local("s1"))
	st_store(.,id1,st_local("touse"),newstart)
	st_store(.,id2,st_local("touse"),newstop)
	
}

end

python:
import numpy as np
from sfi import Data, Macro, Mata
import plotly.graph_objects as go

def sankey():
	fig = go.Figure(data=[go.Sankey(
		arrangement = arrange,
		node = dict(
		  pad = 15,
		  thickness = 20,
		  line = dict(color = "black", width = 0.5),
		  label = Mata.get('newlabs'),
		  x = Mata.get('newxvals'),
		  y = Mata.get('newyvals'),
		  color = colors
		),
		link = dict(
		  source = start, # indices correspond to labels
		  target = stop,
		  value = freq,
		  color = linkcolor
		)
	),
# 	go.Scatter(
# 		x = [0.0,1.0],
# 		y = [0.0,1.0],
# 		mode='markers'
# 	)
	])
	
	fig.update_layout(
		title=title, 
		font_size=10,
		paper_bgcolor = bgcolor
	)
	
	
	
	fig.show()

end

// fig.update_layout(
//     annotations=[
//         dict(
//             x=0.5,
//             y=0,
//             showarrow=False,
//             text="x1",
// 			xref="paper",
//             yref="paper"
//         ),
//         dict(
//             x=0.1,
//             y=0,
//             showarrow=False,
//             text="x2",
// 			xref="paper",
//             yref="paper"
//         )
//     ]
// 	)
