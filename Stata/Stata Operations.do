* Stata Operations

cd /Users/ina/Desktop/ceu/coding_class/assignment

use "/Users/ina/Desktop/ceu/coding_class/assignment/airbnb_cleaned.dta", clear

* summary statistic
summarize bedrooms, detail

* graphs
hist bedrooms
scatter price_num2 bedrooms

* filter observations
generate airbnb_houses = property_type if property_type == "House"
tab bedrooms if bedrooms >1 & <= 4

* filter variables
summarize host*
summarize *d
browse latitude longitude

* create transformations of variables
replace bed_type = "Supersoft Mattress" if bed_type == "Real Bed"

gen short_term = maximum_nights if maximum_nights <= 100
gen long_term = maximum_nights if maximum_nights > 100

* loop 
forvalues t = 2/6 {
	tab price_num2 if bedrooms == `t'
}
