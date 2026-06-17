cscript

set scheme stcolor
global png ../png
local seed 12345671
set seed `seed'

/*-----------------------------------------------------------------------------
	utility functions
-----------------------------------------------------------------------------*/
program dgp_did
	syntax, n_group(string) ///
		n_time(string)  ///
		[heter]

	clear

	set obs `n_group'
	gen id = _n
	if (`n_group' <= 2) {
		gen mu_i = rnormal(id, 1)
	}
	else {
		gen mu_i = id 
	}
	expand `n_time'
	bysort id : gen time = _n
	gen y0 = .
	gen y1 = .
	gen y = .
	gen byte treated = 0
					// y0	
	replace y0 = mu_i + time 

	if (`"`heter'"' != "" & `n_group' > 2) {
		replace y0 = mu_i + id + time 
	}
					// y1
	if (`"`heter'"' == "") {
		if (`n_group' <= 2) {
			gen effect = 1
		}
		else {
			gen effect = 0.5
		}
	}
	else {
		if (`n_group' <= 2) {
			gen effect = id - time/2 + 2
		}
		else {
			gen effect = id - time/4 
		}
	}
	replace y1 = y0 + effect
					// first period, y = y0
	replace y = y0 if time == 1
					// control group
	replace y = y0 if id == 1
					// treated group
	replace treated = 1 if id > 1
					// treated group
	replace y = y1 if time >= id & treated
	replace y = y0 if time < id & treated
end


/*-----------------------------------------------------------------------------
	classical 2 x 2 DID
-----------------------------------------------------------------------------*/
					//----------------------------//
					// DGP
					//----------------------------//
dgp_did, n_group(2) n_time(2)

					//----------------------------//
					// graph
					//----------------------------//
local line1 connected y time if id == 1, 	///
	legend(label(1 "control") on) lcolor(black)

local line2 connected y time if id == 2, 	///
	legend(label(2 "treated, observed") on)	///

local line3 connected y0 time if id == 2, 		///
	legend(label(3 "treated, potential") on) 	///
	lp(dash) lcolor(red)

local twopts	ytitle("Outcome") 					///
	xtitle("Time")  						///
	xlabel(1 "1" 2 "2")						///
	title(Two Groups x Two Periods)					///
	text(2.03 1.1 "Y{sup:control, T=1}(0)")				///
	text(2.5 2.05 "Y{sup:control, T=2}(0)")				///
	text(3.6 1.1 "Y{sup:treated, T=1}(0)")				///
	text(5.75 1.9 "Y{sup:treated, T=2}(1)")				///
	text(4.85 1.9 "{bf:Y{sup:treated, T=2}(0)}", color(green)) 	///
	name(did2x2)							///
	play(did2x2)


twoway (`line1') (`line2') (`line3'), `twopts' 
graph export $png/did2x2.png, replace

/*-----------------------------------------------------------------------------
	2 groups x multiple periods (homogeneous effects)
-----------------------------------------------------------------------------*/
					//----------------------------//
					// DGP
					//----------------------------//
dgp_did, n_group(2) n_time(5)

					//----------------------------//
					// graph
					//----------------------------//
local line1 connected y time if id == 1, 	///
	legend(label(1 "control") on) lcolor(black)

local line2 connected y time if id == 2, 	///
	legend(label(2 "treated, observed") on)	///

local line3 connected y0 time if id == 2, 		///
	legend(label(3 "treated, potential") on) 	///
	lp(dash) lcolor(red)

local twopts	ytitle("Outcome") 					///
	xtitle("Time")  						///
	title(Two Groups x Multiple Periods (homogeneous effects) )	///
	play(did2x5)							///
	name(did2x5)							

twoway (`line1') (`line2') (`line3'), `twopts'
graph export $png/did2x5.png, replace

/*-----------------------------------------------------------------------------
	2 groups x multiple periods (hetero effects)
-----------------------------------------------------------------------------*/
					//----------------------------//
					// DGP
					//----------------------------//
dgp_did, n_group(2) n_time(5) heter

					//----------------------------//
					// graph
					//----------------------------//
local line1 connected y time if id == 1, 	///
	legend(label(1 "control") on)	

local line2 connected y time if id == 2, 	///
	legend(label(2 "treated, observed") on)	///

local line3 connected y0 time if id == 2, 		///
	legend(label(3 "treated, potential") on) 	///
	lp(dash) lcolor(red)

local twopts	ytitle("Outcome") 					///
	xtitle("Time")  						///
	title(Two Groups x Multiple Periods (heterogeneous effects) )	///
	name(did2x5_heter)						///
	play(did2x5_heter)					


twoway (`line1') (`line2') (`line3'), `twopts'
graph export $png/did2x5_heter.png, replace

/*-----------------------------------------------------------------------------
	3 groups x multiple periods (homogenenous effects)
-----------------------------------------------------------------------------*/
					//----------------------------//
					// DGP
					//----------------------------//
dgp_did, n_group(3) n_time(5) 

					//----------------------------//
					// graph
					//----------------------------//
local line1 connected y time if id == 1, 	///
	legend(label(1 "control") on) lcolor(black)

local line2 connected y time if id == 2, 	///
	legend(label(2 "group=2, observed") on)	///
	lcolor(red)

local line3 connected y0 time if id == 2, 		///
	legend(label(3 "group=2, potential") on) 	///
	lp(dash) lcolor(red)

local line4 connected y time if id == 3, 	///
	legend(label(4 "group=3, observed") on)	///
	lcolor(blue)

local line5 connected y0 time if id == 3, 		///
	legend(label(5 "group=3, potential") on) 	///
	lp(dash) lcolor(blue)

local twopts	ytitle("Outcome") 					///
	xtitle("Time")  						///
	title(Three Groups x Multiple Periods (homogeneous effects) )	///
	name(did3x5)							///
	play(did3x5)					


twoway (`line1') (`line2') (`line3') (`line4') (`line5'), `twopts'

graph export $png/did3x5.png, replace


/*-----------------------------------------------------------------------------
	3 groups x multiple periods (homogenenous effects)
-----------------------------------------------------------------------------*/
					//----------------------------//
					// DGP
					//----------------------------//
dgp_did, n_group(3) n_time(5) heter

					//----------------------------//
					// graph
					//----------------------------//
local line1 connected y time if id == 1, 	///
	legend(label(1 "control") on) lcolor(black)

local line2 connected y time if id == 2, 	///
	legend(label(2 "group=2, observed") on)	///
	lcolor(red)

local line3 connected y0 time if id == 2, 		///
	legend(label(3 "group=2, potential") on) 	///
	lp(dash) lcolor(red)

local line4 connected y time if id == 3, 	///
	legend(label(4 "group=3, observed") on)	///
	lcolor(blue)

local line5 connected y0 time if id == 3, 		///
	legend(label(5 "group=3, potential") on) 	///
	lp(dash) lcolor(blue)

local twopts	ytitle("Outcome") 					///
	xtitle("Time")  						///
	title(Three Groups x Multiple Periods (heterogeneous effects) )	///
	name(did3x5_heter)						///
	play(did3x5_heter)						


twoway (`line1') (`line2') (`line3') (`line4') (`line5'), `twopts'

graph export $png/did3x5_heter.png, replace

