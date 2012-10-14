//log using "u:\Pablo\01182012",text
//log close


*Creating the code book. 
import excel "U:\Pablo\Feb 10\Precinct CanvassNov10.xls", describe
forvalues j=166/225{ //should have run it from 1 to 225 but there were errors which needed to be debugged in certain sheets.
*local myend=substr(r(range_`j'),4,1)
import excel "U:\Pablo\Feb 10\Precinct CanvassNov10.xls", sheet("Sheet`j'") cellrange(H7:K7) allstring
generate int sheetid = `j'
append using "U:\Pablo\Feb 10\codebook.dta", force
save "U:\Pablo\Feb 10\codebook.dta", replace
clear
}



forvalues i=3/227{
qui import excel "U:\Pablo\Feb 10\Precinct CanvassNov10.xls", describe
local myend=substr(r(range_`i'),4,.)
local id=substr(r(worksheet_`i'),6,.)
import excel "U:\Pablo\Feb 10\Precinct CanvassNov10.xls", sheet("Sheet`id'") cellrange(a8:`myend')
* Data are read in by row.  Let's rename and get rid of data we don't want
 local j=1
 drop B C D E F G
 foreach var of var * {
     if "`var'" == "A" rename `var' pid
         *else if inlist("`var'","B","G") drop `var'
         else {
              destring `var', replace
          sum `var'
          if r(N) > 0 {
             rename `var' c1_`j'
             local j=`j'+1
             }
           else drop `var'
     }
 }
drop if pid==""
generate int sheetid = real("`id'")
append using "U:\Pablo\Feb 10\masterdata_test.dta", force
save "U:\Pablo\Feb 10\masterdata_test.dta", replace
qui clear
}





*now we do the dataanalysis
* 1. We start with the masterdata do the following operations
* This just creates a new variable freq with the frequency of all the pids
* we will then merge this data with the data about voter info for all the pids
gen x=1
collapse (count) x , by (pid)
rename x freq
save "U:\Pablo\Feb 10\frequency.dta"
clear 
import excel "U:\Pablo\Feb 10\Precinct CanvassNov10.xls", sheet("Sheet1") cellrange(A7:F1946) firstrow // This imports the voter turnout for every precinct
drop B
drop F
rename A pid
rename Registered reg
rename BallotsCast votes
rename Turnout turnout
merge 1:1 pid using "U:\Pablo\Feb 10\frequency.dta"
drop if pid==""
drop if pid=="Contest Total"
destring pid, replace
drop _merge
generate int year=2010 //rem to change thsi if we are creating this file for a different year
destring reg, replace
destring votes, replace
destring turnout, replace
save "U:\Pablo\Feb 10\metadata_final.dta"
twoway (scatter freq reg)
twoway (scatter freq turnout)
