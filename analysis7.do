
*** WAVE 6

cd "C:\Users\czymara.local\PowerFolders\projects\SVR-Jahresgutachten 2021"

use "data/ESS7e02_2.dta", clear

keep if cntry == "DE"
drop if agea < 18

* Migrationshintergrund
gen mig = .
label var mig "Migrationshintergrund"
replace mig=0 if brncntr==1 & mocntr==1 & facntr==1 // respondent, mother and father born in country
replace mig=1 if brncntr==2 | (brncntr==1 & (mocntr==2 | facntr==2))
label define ynlbl 0 "Nein" 1 "Ja"
label values mig ynlbl

* almuslv
gen almuslv2 =.
label var almuslv2 "Muslime sollten nach Deutschland einwandern duerfen (almuslv)"
replace almuslv2 = 1 if almuslv == 3 | almuslv == 4
replace almuslv2 = 2 if almuslv == 1 | almuslv == 2
replace almuslv2 = . if missing(almuslv)
label define zustimmunglbl2 1 "Stimme nicht zu (wenige / keine)" 2 "Stimme zu (einige / viele)"
label values almuslv2 zustimmunglbl2


* ANALYSIS
log using results7.log, replace

*** "Migranten kosten mehr als sie beitragen" (imbleco)
* WEIGHTED
tab almuslv2 [aweight=pspwght] if ctzcntr == 1
tab almuslv2 [aweight=pspwght] if mig == 0

* UNWEIGHTED
tab almuslv2 if ctzcntr == 1
tab almuslv2 if mig == 0

log close


