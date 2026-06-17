cscript

set scheme stcolor

webuse grunfeld, clear
*fake treatment
gen treated = inrange(company,1,3)
gen post = year>=1945
* basic DiD regression
reg kstock i.treated##i.post 
* now, make the graph
collapse (mean) kstock, by(year treated)
twoway (line kstock year if treated==1) (line kstock year if treated==0), ///
	xline(1945) legend(label(1 Treated) label(2 Control))
