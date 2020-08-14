
*** WAVE 6

cd "C:\Users\czymara.local\PowerFolders\projects\SVR-Jahresgutachten 2021"

use "data/ESS6e02_4.dta", clear

keep if cntry == "DE"
drop if agea < 18

* Migrationshintergrund
gen mig = .
label var mig "Migrationshintergrund"
replace mig=0 if brncntr==1 & mocntr==1 & facntr==1 // respondent, mother and father born in country
replace mig=1 if brncntr==2 | (brncntr==1 & (mocntr==2 | facntr==2))
label define ynlbl 0 "Nein" 1 "Ja"
label values mig ynlbl

* imvtctz
gen imvtctz2 =.
label var imvtctz2 "Es ist wichtig, dass Migranten Wahlrecht bekommen sobald sie Staatsbuergerschaft haben (imvtctz)"
replace imvtctz2 = 1 if imvtctz < 5
replace imvtctz2 = 2 if imvtctz == 5
replace imvtctz2 = 3 if imvtctz > 5
replace imvtctz2 = . if missing(imvtctz) 
label define zustimmunglbl 1 "Stimme nicht zu" 2 "Neutral" 3 "Stimme zu"
label values imvtctz2 zustimmunglbl


* ANALYSIS
log using results6.log, replace

*** "Migranten kosten mehr als sie beitragen" (imbleco)
* WEIGHTED
tab imvtctz2 [aweight=pspwght] if ctzcntr == 1
tab imvtctz2 [aweight=pspwght] if mig == 0

* UNWEIGHTED
tab imvtctz2 if ctzcntr == 1
tab imvtctz2 if mig == 0

log close


