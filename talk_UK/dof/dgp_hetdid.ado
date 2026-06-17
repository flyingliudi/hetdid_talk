program dgp_hetdid
	syntax [, n_panel(integer 1000)	///
		n_t(string)		///
		px(integer 1)		///
		cohort_max(integer 20)	///
		beta(real 1) 		///
		cluster 		///
		wvar(string)		///
		homo]
	
	/* ---------------------------------------------------------- */
	// before expansion on T

	if (`"`n_t'"' == "") {
		local n_t = `cohort_max' - 3
	}

	clear
					// number of individuals
	set obs `n_panel'
					// id
	gen id = _n
					// assigning treatment cohort
	gen cohort = runiformint(2, `cohort_max')

	gen tmax = `n_t'
	replace cohort = . if cohort > tmax

	if (`"`cluster'"' != "") {
		gen state = runiformint(1, 50)
	}

	if (`"`wvar'"' != "") {
		gen double wvar = `wvar'
	}
	
	
	/* ---------------------------------------------------------- */
	// after expansion
	expand tmax
	bysort id : gen time = _n
					// covariates X before treatment
	gen double myxb = 0
	forvalues i = 1/`px' {
		gen double x`i' = rnormal(0, 1)
		replace myxb = x`i'*`beta' + myxb
	}
					// untreated potential outcomes
	gen double eta = rnormal()
	gen double u = rnormal()
	gen double y = time + eta + myxb + u
	gen double my_y0 = y

					// observed outcomes
	gen delta_e = time - cohort + 1 if cohort <= 3
	replace delta_e = -(time - cohort + 1) if cohort > 3
	if (`"`homo'"' != "") {
		replace delta_e = 1
	}
	gen double v = rnormal()
	replace y = y + delta_e + v - u if time >= cohort
	gen double my_y1 = y if time >= cohort

					// xtset
	xtset id time
					// cohort and treat
	gen byte treat = time >= cohort
	replace treat = 0 if cohort == .
	replace cohort = 0 if cohort == .

end
