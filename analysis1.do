
*** WAVE 1

cd "C:\Users\czymara.local\PowerFolders\projects\SVR-Jahresgutachten 2021"

use "data/ESS1e06_6.dta", clear

keep if cntry == "DE"
drop if agea < 18

* Migrationshintergrund
gen mig = .
label var mig "Migrationshintergrund"
replace mig=0 if brncntr==1 & mocntr==1 & facntr==1 // respondent, mother and father born in country
replace mig=1 if brncntr==2 | (brncntr==1 & (mocntr==2 | facntr==2))
label define ynlbl 0 "Nein" 1 "Ja"
label values mig ynlbl

* imsmrgt
gen imsmrgt2 =.
label var imsmrgt2 "Migranten sollten die gleichen Rechte haben wie alle anderen (imsmrgt)"
replace imsmrgt2 = 1 if imsmrgt == 4 | imsmrgt == 5
replace imsmrgt2 = 2 if imsmrgt == 3
replace imsmrgt2 = 3 if imsmrgt == 1 | imsmrgt == 2
replace imsmrgt2 = . if missing(imsmrgt)
label define zustimmunglbl 1 "Stimme nicht zu" 2 "Neutral" 3 "Stimme zu"
label values imsmrgt2 zustimmunglbl


* ANALYSIS
log using results1.log, replace

*** "Migranten kosten mehr als sie beitragen" (imbleco)
* WEIGHTED
tab imsmrgt2 [aweight=pspwght] if ctzcntr == 1
tab imsmrgt2 [aweight=pspwght] if mig == 0

* UNWEIGHTED
tab imsmrgt2 if ctzcntr == 1
tab imsmrgt2 if mig == 0

log close



