
cd "C:\Users\czymara.local\PowerFolders\projects\SVR-Jahresgutachten 2021"

use "data/ESS1-8e01.dta", clear
append using "data/ESS9e02"

keep if cntry == "DE"
drop if agea < 18

/*
-          contplt
-          wrkprty
-          wrkorg
-          sgnptit
-          pbldmn

(1) ohne MH
(2) MH 1. Generation (=im Ausland geboren)
(3) MH 2. Generation (=im Inland geboren, mind. ein Elternteil im Ausland geboren)
 
Außerdem für die Variable vote, hier müssten aber alle ohne dt. Staatsbürgerschaft ausgeschlossen werden.
 
Jeweils für alle verfügbaren Erhebungen, wenn das ohne großen Aufwand geht; mit Gewichtung.
*/

* Migrationshintergrund
gen mig2 = .
label var mig2 "Migrationshintergrund"
replace mig2=0 if brncntr==1 & mocntr==1 & facntr==1 // respondent, mother and father born in country
replace mig2=1 if brncntr==2 // respondent not born in country
replace mig2=2 if brncntr==1 & (mocntr==2 | facntr==2) // respondent born in country but either father or mother not
label define miglbl 0 "Nein" 1 "Erste Generation" 2 "Zweite Generation"
label values mig2 miglbl


* Analyse
log using results_Wohlfarth.log, replace

/* Jeweils fuer alle Variablen:
Erste Tabelle = Personen ohne Migrationshintergrund
Zweite Tabelle = Migranten erster Generation
Dritte Tablle = Migranten zweiter Generation */

foreach var of varlist contplt wrkprty wrkorg sgnptit pbldmn {
	tab essround `var' [aweight=pspwght] if mig2 == 0, row
	tab essround `var' [aweight=pspwght] if mig2 == 1, row
	tab essround `var' [aweight=pspwght] if mig2 == 2, row
	}

keep if ctzcntr == 1
tab essround vote [aweight=pspwght] if mig2 == 0, row
tab essround vote [aweight=pspwght] if mig2 == 1, row
tab essround vote [aweight=pspwght] if mig2 == 2, row

log close

