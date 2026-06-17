cscript

set scheme stcolor

global logs ../logs
global png ../png

local seed 12345671
set seed `seed'
qui dgp_hetdid, n_panel(1000) n_t(7) cohort_max(9) px(5)
label define lb_cohort 0 "Never-treated", add
label value cohort lb_cohort

					// distribution of cohort
graph pie, over(cohort) name(pie) 
graph export $png/pie.png, replace

					// TWFE
sjlog using $logs/twfe1, replace
xtdidregress (y x*) (treat), group(id) time(time)
sjlog close, replace

					// dbecomp -- bacon decomposition
estat bdecomp, graph 
graph export $png/bacon.png, replace

					// heterogeneous DID
sjlog using $logs/atet1, replace
quietly xthdidregress aipw (y x*) (treat), group(id) 
estat atetplot, name(atetplot) sci
graph export $png/atet1.png, replace
sjlog close, replace

					// aggregation
estat aggregation, cohort graph(name(co1) legend(off))
estat aggregation, time graph(name(ti1) legend(off))
estat aggregation, dynamic graph(name(dy1) legend(off))
graph combine co1 ti1 dy1, name(agg1)
graph export $png/agg1.png, replace


