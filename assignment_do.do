*Assignment

/* ChatGPT suggestion for GitHub folder:

📂 project-name/
├── 📂 data/
│   ├── 📂 raw/                  # Store raw datasets here
│   └── 📂 processed/            # Store processed datasets here
├── 📂 scripts/
│   ├── 📂 python/               # Python scripts for data manipulation
│   └── 📂 stata/                # Stata .do files for analysis
├── 📂 output/
│   ├── 📂 graphs/               # Save any output graphs here (from Stata or Python)
│   └── 📂 tables/               # Save any generated tables here (summary stats, etc.)
├── README.md                    # Overview of the project
└── report.md                    # Document describing the data analysis and results

*/


/* README:
- Project overview
- folder structure

PYTHON Scripts
using jupyter

STATA
do files

GRAPHS
storing them in a separate folder



 1. Understand folder structure. Perform operations on files in different folders.

pwd
cd
ls
copying files
cp WDIData.csv myfavouritecopy.csv

does this also include bash commands? how would we show this?

copying files
cp WDIData.csv myfavouritecopy.csv

create a folder in worldbank called "backup"
mkdir backup

moving myfavouritecopy to backup
mv myfavouritecopy.csv to backup

printing the first five lines
head -n 5 WDISeries-Time.csv

*/

cd /Users/ina/Desktop/ceu/coding_class/assignment/osfstorage-archive/raw


/*

5. Read .csv data in. Fix common data quality errors (for example, string vs number,missing value). (in Stata and in Python as well)
*/

import delimited /Users/ina/Desktop/ceu/coding_class/assignment/osfstorage-archive/raw/airbnb_london_listing.csv, varnames(1) bindquotes(strict) encoding("utf-8") clear

browse

* a) scrape_id: cutting all e+13 - we can do this my specifying that we only want to have an x amount of digits

generate scrape_id_str = string(scrape_id)
drop scrape_id

generate scrape =substr(scrape_id_str, 1, 4)
drop scrape_id_str

destring scrape, generate(scrape_id)

* b) drop v1 - what does that even do?
drop v1

* c) changing host_since, calendar_last_scraped, first_review and last_review: destringing; proper date format

generate numdate = date(calendar_last_scraped, "YMD")
format numdate %td
drop calendar_last_scraped

* same thing with: host_since, calendar_last_scraped, first_review, last_review

generate host_date = date(host_since, "YMD")
format host_date %td
drop host_since

generate date_first_review = date(first_review, "YMD")
format date_first_review %td
drop first_review

generate date_last_review = date(last_review, "YMD")
format date_last_review %td
drop last_review


* https://www.stata.com/manuals/ddatetime.pdf


* d) review score

replace review_scores_rating = "" if review_scores_rating == "NA"
destring review_scores_rating, replace

* e) for all observations that entail two names: replace "And" with "&"; get rid of any special characters

*????

* f) destring host_response_rate

replace host_response_rate = "" if host_response_rate == "N/A"
split host_response_rate, parse(%) gen(host_response_percent)
drop host_response_rate
destring host_response_percent, replace
generate host_response_rate = host_response_percent/100


* g) drop host_acceptance_rate; it's only N/A's
drop host_acceptance_rate

* h) host_is_superhost: create a binary numerical variable
generate superhost_binary = 0 if host_is_superhost == "f"
replace superhost_binary = 1 if superhost_binary == .
drop host_is_superhost
* here I might want to add labels : yes and no, but keep it a numeric variable

* i) host_listings_count: destring
replace host_listings_count = "" if host_listings_count == "NA"
destring host_listings_count, replace

* j) host_total_listings_count: destring

replace host_total_listings_count = "" if host_total_listings_count == "NA"
destring host_listings_count, replace

* k) host_verifications: get rid of all weird shit
** ?????


* l) host_has_profile_pic: create binary variable, destring
generate profile_pic = 0 if host_has_profile_pic == "f"
replace profile_pic = 1 if profile_pic == .
drop host_has_profile_pic
* here I might want to add labels : yes and no, but keep it a numeric variable

* m) host_identity_verified: create binary variable, destring
generate host_verified_binary = 0 if host_identity_verified == "f"
replace host_verified_binary = 1 if host_verified_binary == .
drop host_identity_verified
* here I might want to add labels : yes and no, but keep it a numeric variable

* n) drop neighbourhood
drop neighbourhood

* o) drop neighbourhood_group_cleansed
drop neighbourhood_group_cleansed

* p) city; smart_location: get rid of weird shit (e.g. observation 10)
* ???


* q) latitude: get rid of the last few digits
* ????

* r) longitude: change format: include the first 0; cut the last digits

* s) is_location_exact: create binary variable; destring
generate exact_location_binary = 0 if is_location_exact == "f"
replace exact_location_binary = 1 if exact_location_binary == .
drop is_location_exact

* t) destring: bathrooms; bedrooms; beds
replace bathrooms = "" if bathrooms == "NA"
destring bathrooms, replace

replace bedrooms = "" if bedrooms == "NA"
destring bedrooms, replace

replace beds = "" if beds == "NA"
destring beds, replace


* u) amenities: get rid of weird shit
* ???

* v) square_feet: get rid of variables; NAs only
drop squre_feet


* w) price; weekly_price; monthly_price; security_deposit; cleaning_fee; extra_people: destring; get rid of $
* ???

* x) has_availability: get rid of this variable; NAs only
drop has_availability

* y) review_scores_accuracy; review_scores_cleanliness; review_scores_checkin; review_scores_communication; review_scores_location; review_scores_value: get rid of NAs, destring

replace review_scores_accuracy = "" if review_scores_accuracy == "NA"
destring review_scores_accuracy, replace

replace review_scores_cleanliness = "" if review_scores_cleanliness == "NA"
destring review_scores_cleanliness, replace

replace review_scores_checkin = "" if review_scores_checkin == "NA"
destring review_scores_checkin, replace

replace review_scores_communication = "" if review_scores_communication == "NA"
destring review_scores_communication, replace

replace review_scores_location = "" if review_scores_location == "NA"
destring review_scores_location, replace

replace review_scores_value = "" if review_scores_value == "NA"
destring review_scores_value, replace


* z) requires_license: create binary variable; destringing
generate requires_license_binary = 0 if requires_license == "f"
drop requires_license
replace requires_license_binary = 1 if requires_license_binary == .

* A) get rid of license; jurisdiction_names: NAs only
count if license != "NA"
drop license

* B) instant_bookable; require_guest_phone_verification, require_guest_profile_picture: create binary variable; destring

count if instant_bookable == "NA"
count if require_guest_phone_verification == "NA"
count if require_guest_profile_picture == "NA"


generate phone_verification_binary = 0 if require_guest_phone_verification == "f"
drop require_guest_phone_verification
replace phone_verification_binary = 1 if phone_verification_binary == .

generate guest_picture_binary = 0 if require_guest_profile_picture == "f"
drop require_guest_profile_picture
replace guest_picture_binary = 1 if guest_picture_binary == .


* C) reviews_per_month: get rid of NAs; destring
replace reviews = "" if reviews == "NA"
destring reviews, replace







