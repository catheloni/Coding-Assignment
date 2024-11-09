

* DATA CLEANING IN STATA


cd /Users/ina/Desktop/ceu/coding_class/assignment/osfstorage-archive/raw


import delimited /Users/ina/Desktop/ceu/coding_class/assignment/osfstorage-archive/raw/airbnb_london_listing.csv, varnames(1) bindquotes(strict) encoding("utf-8") clear

browse

* scrape_id: cutting all e+13 - we can do this my specifying that we only want to have an x amount of digits
generate scrape_id_str = string(scrape_id)
drop scrape_id
generate scrape =substr(scrape_id_str, 1, 4)
drop scrape_id_str
destring scrape, generate(scrape_id)

* drop v1
drop v1

* changing host_since, calendar_last_scraped, first_review and last_review: destringing; proper date format
generate numdate = date(calendar_last_scraped, "YMD")
format numdate %td
drop calendar_last_scraped

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


* review score
replace review_scores_rating = "" if review_scores_rating == "NA"
destring review_scores_rating, replace

* destring host_response_rate
replace host_response_rate = "" if host_response_rate == "N/A"
split host_response_rate, parse(%) gen(host_response_percent)
drop host_response_rate
destring host_response_percent, replace
generate host_response_rate = host_response_percent/100

* drop host_acceptance_rate; it's only N/A's
drop host_acceptance_rate

* host_is_superhost: create a binary numerical variable
generate superhost_binary = 0 if host_is_superhost == "f"
replace superhost_binary = 1 if superhost_binary == .
drop host_is_superhost

* host_listings_count: destring
replace host_listings_count = "" if host_listings_count == "NA"
destring host_listings_count, replace

* host_total_listings_count: destring
replace host_total_listings_count = "" if host_total_listings_count == "NA"
destring host_listings_count, replace

* host_verifications: get rid of all weird stuff
replace host_verifications = subinstr(host_verifications, "'",  "", .)
replace host_verifications = subinstr(host_verifications, "[", "", .)
replace host_verifications = subinstr(host_verifications, "]", "", .)

* host_has_profile_pic: create binary variable, destring
generate profile_pic = 0 if host_has_profile_pic == "f"
replace profile_pic = 1 if profile_pic == .
drop host_has_profile_pic

* host_identity_verified: create binary variable, destring
generate host_verified_binary = 0 if host_identity_verified == "f"
replace host_verified_binary = 1 if host_verified_binary == .
drop host_identity_verified

* instant_bookable: create binary variable, destring
generate instant_bookable_binary = 0 if instant_bookable == "f"
replace instant_bookable_binary = 1 if instant_bookable_binary == .
drop instant_bookable

* destring scrape

destring(scrape),replace

* drop neighbourhood
drop neighbourhood

* drop neighbourhood_group_cleansed
drop neighbourhood_group_cleansed

* city; smart_location: get rid of non latin observations
gen city_clean =trim(itrim(ustrregexra(ustrto(city, "ascii", 2), "[^a-zA-Z0-9]", " ", .)))
drop city

gen smart_location_clean =trim(itrim(ustrregexra(ustrto(smart_location, "ascii", 2), "[^a-zA-Z0-9]", " ", .)))
drop smart_location

* is_location_exact: create binary variable; destring
generate exact_location_binary = 0 if is_location_exact == "f"
replace exact_location_binary = 1 if exact_location_binary == .
drop is_location_exact

* destring: bathrooms; bedrooms; beds
replace bathrooms = "" if bathrooms == "NA"
destring bathrooms, replace

replace bedrooms = "" if bedrooms == "NA"
destring bedrooms, replace

replace beds = "" if beds == "NA"
destring beds, replace


* amenities: get rid of weird stuff

replace amenities = subinstr(amenities, `"""',  "", .)
replace amenities = substr(amenities, 1, strpos(amenities, "}") -1)
replace amenities = substr(amenities, 2, .)
replace amenities = subinstr(amenities, ",", ", ",.) 

* square_feet: get rid of variable; NAs only
drop square_feet

* price; weekly_price; price; monthly_price; security_deposit; cleaning_fee; extra_people: destring; get rid of $

split weekly_price, parse($) gen(weekly_price_num)
drop weekly_price_num1
replace weekly_price_num2 = subinstr(weekly_price_num2 , ",", "", .)
destring weekly_price_num2, replace
drop weekly_price

split price, parse($) gen(price_num)
drop price_num1
replace price_num2 = subinstr(price_num2 , ",", "", .)
destring price_num2, replace
drop price

split monthly_price, parse($) gen(monthly_price_num)
drop monthly_price_num1
replace monthly_price_num2 = subinstr(monthly_price_num2 , ",", "", .)
destring monthly_price_num2, replace
drop monthly_price

split security_deposit, parse($) gen(security_deposit_num)
drop security_deposit_num1
replace security_deposit_num2 = subinstr(security_deposit_num2 , ",", "", .)
destring security_deposit_num2, replace
drop security_deposit

split cleaning_fee, parse($) gen(cleaning_fee_num)
drop cleaning_fee_num1
replace cleaning_fee_num2 = subinstr(cleaning_fee_num2 , ",", "", .)
destring cleaning_fee_num2, replace
drop cleaning_fee

split extra_people, parse($) gen(extra_people_num)
drop extra_people_num1
replace extra_people_num2 = subinstr(extra_people_num2 , ",", "", .)
destring extra_people_num2, replace
drop extra_people

* has_availability: get rid of this variable; NAs only
drop has_availability

* review_scores_accuracy; review_scores_cleanliness; review_scores_checkin; review_scores_communication; review_scores_location; review_scores_value: get rid of NAs, destring
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

replace host_total_listings_count = "" if host_total_listings_count == "NA"
destring host_total_listings_count, replace

* requires_license: create binary variable; destringing
generate requires_license_binary = 0 if requires_license == "f"
drop requires_license
replace requires_license_binary = 1 if requires_license_binary == .

* get rid of license; jurisdiction_names: NAs only
count if license != "NA"
drop license

* instant_bookable; require_guest_phone_verification, require_guest_profile_picture: create binary variable; destring
count if instant_bookable == "NA"
count if require_guest_phone_verification == "NA"
count if require_guest_profile_picture == "NA"

generate phone_verification_binary = 0 if require_guest_phone_verification == "f"
drop require_guest_phone_verification
replace phone_verification_binary = 1 if phone_verification_binary == .

generate guest_picture_binary = 0 if require_guest_profile_picture == "f"
drop require_guest_profile_picture
replace guest_picture_binary = 1 if guest_picture_binary == .

* reviews_per_month: get rid of NAs; destring
replace reviews = "" if reviews == "NA"
destring reviews, replace


browse

* we're all done!! :)









