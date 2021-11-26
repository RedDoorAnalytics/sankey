{smcl}
{* *! version 1.0.0}{...}
{vieweralsosee "python" "help python"}{...}
{title:Title}

{p2colset 5 15 15 2}{...}
{p2col :{cmd:sankey} {hline 2}}creates sankey (alluvial) plots using {cmd:plotly} in {helpb python}{p_end}
{p2colreset}{...}


{phang2}
{cmd: sankey} {it:startvar} {it:stopvar} {it:freqvar} {ifin} {cmd:,} [{it:{help sankey##options_table:options}}]


{marker options_table}{...}
{synoptset 26 tabbed}{...}
{synopthdr:Options}
{synoptline}
{synopt:{opt title(string)}}specify a title for the plot{p_end}
{synopt:{opt colors(color_list)}}specify the colors for each node{p_end}
{synopt:{opt linkc:olor(color)}}specify the color of the flow between nodes; default {cmd:linkcolor(lightblue)}{p_end}
{synopt:{opt bgcolor(color)}}specify the color of the background; default {cmd:bgcolor(white)}{p_end}
{synopt:{opt nolabels}}suppress the labelling of nodes{p_end}
{synopt:{opt arrange(type)}}specifies the arrangement of the nodes; default {cmd:arrange(snap)}{p_end}
{synopt:{opt x(varname)}}specifies the normalised x-axis position of the nodes}{p_end}
{synopt:{opt y(varname)}}specifies the normalised y-axis position of the nodes}{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:sankey} creates {bf:sankey} (alluvial) graphs using the {cmd:plotly} {helpb python} library.
{p_end}


{title:Options}

{phang}
{opt title(string)} defines a title for the plot, such as {cmd:title("Example Sankey plot")}.

{phang}
{opt colors(color_list)} defines the colors for each node, for example {cmd:colors(1 "red" 2 "blue")}, where each number corresponds to 
a node defined in either the {it:startvar} or the {it:stopvar}. Any nodes with undefined colors will have the default {cmd:"red"}.

{phang}
{opt linkcolor(color)} defines the color of the flow between nodes. The {cmd:linkcolor()} applies to all flows, with a default of 
{cmd:linkcolor(lightblue)}.

{phang}
{opt bgcolor(color)} defines the color of the background, with a default of {cmd:bgcolor(white)}.

{phang}
{opt nolabels} suppresses labelling of the nodes, when {it:startvar} and {it:stopvar} have {helpb label values}.

{phang}
{opt arrange(type)} if {it:type} is {cmd:snap} (the default), the node arrangement is assisted by automatic snapping of elements to 
preserve space between nodes.. If {it:type} is {cmd:perpendicular}, the nodes can only move along a line perpendicular to the flow. 
If {it:type} is {cmd:freeform}, the nodes can freely move on the plane. If {it:type} is fixed, the nodes are stationary.

{phang}
{opt x(varname)} defines the normalized (from 0 to 1) horizontal position (x-axis) of the nodes. {cmd:y()} must also be specified.

{phang}
{opt y(varname)} defines the normalized (from 0 to 1) vertical position (y-axis) of the nodes. {cmd:x()} must also be specified.


{title:Example}

{pstd}Load example dataset:{p_end}
{phang}{stata "use https://www.mjcrowther.co.uk/data/sankey_eg1":. use https://www.mjcrowther.co.uk/data/sankey_eg1}{p_end}

{pstd}Produce default plot:{p_end}
{phang}{stata "sankey start stop freq":. sankey start stop freq}{p_end}

{pstd}Change the link color:{p_end}
{phang}{stata "sankey start stop freq, linkcolor(lightgreen)":. sankey start stop freq, linkcolor(lightgreen)}{p_end}

{pstd}Change some node colors:{p_end}
{phang}{stata `"sankey start stop freq, colors(3 "green" 6 "red")"':. sankey start stop freq, colors(3 "green" 6 "red") linkcolor(lightgreen)}{p_end}


{title:Author}

{pstd}{cmd:Michael J. Crowther}{p_end}
{pstd}Department of Health Sciences{p_end}
{pstd}University of Leicester{p_end}
{pstd}E-mail: {browse "mailto:michael.crowther@le.ac.uk":michael.crowther@le.ac.uk}{p_end}

{phang}Please report any errors you may find.{p_end}


{title:References}

{pstd}
{browse "https://plotly.com/python/":https://plotly.com/python/}
{p_end}

