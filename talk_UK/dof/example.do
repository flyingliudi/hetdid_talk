cscript

set scheme stcolor

					// data
qui do get_data
use minwage

global logs ../logs
global png ../png
					//----------------------------//
					// conditional parallel trend
					//----------------------------//
sjlog using $logs/ex1, replace
global covars i.region pop medinc white hs pov c.pop#c.pop c.medinc#c.medinc
xthdidregress aipw (lemp $covars) (treat $covars), group(state)
sjlog close, replace

graph pie, over(_did_cohort) name(pie2)
graph export $png/pie2.png, replace

estat atetplot, name(g2) sci
graph export $png/g2.png, replace

sjlog using $logs/ex2, replace
estat aggreg, dynamic weights(cohort) graph(name(d1))
sjlog close, replace
graph export $png/d2.png, replace

sjlog using $logs/ex3, replace
estat aggreg, cohort weights(cohort) graph(name(c1))
sjlog close, replace
graph export $png/c2.png, replace

sjlog using $logs/ex4, replace
estat aggreg, time weights(cohort) graph(name(t1))
sjlog close, replace
graph export $png/t2.png, replace


sjlog using $logs/ex5, replace
estat aggreg, overall weights(cohort)
sjlog close, replace






