/*-----------------------------------------------------------------------------
	Effect of minimum wage on teen employment	
	Data from Callaway and Sant'Anna (2021)
-----------------------------------------------------------------------------*/
					// data
use min_wage_cs, clear
xtset countyreal year

drop treat
					// creat observational treat indicator
gen treat = 0
replace treat = 1 if year >= first_treat & first_treat!=0

					// encode state
encode state_name, generate(state)

save minwage, replace


