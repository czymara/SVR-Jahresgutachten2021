
cd "C:\Users\czymara.local\PowerFolders\projects\SVR-Jahresgutachten 2021"

use "data/ESS1-8e01.dta", clear
append using "data/ESS9e02"

keep if cntry == "DE"
drop if agea < 18


****
* DATENAUFBEREITUNG
****

*** DRITTVARIABLEN

* Migrationshintergrund
gen mig = .
label var mig "Migrationshintergrund"
replace mig=0 if brncntr==1 & mocntr==1 & facntr==1 // respondent, mother and father born in country
replace mig=1 if brncntr==2 | mocntr==2 | facntr==2
label define ynlbl 0 "Nein" 1 "Ja"
label values mig ynlbl


* Alter
* Alter bitte folgende Gruppen bilden:   1 '18-29'  2 '30-59' 3 '60+'
gen alter = .
replace alter = 1 if agea>=18 & agea<=29
replace alter = 2 if agea>=30 & agea<=59
replace alter = 3 if agea>=60
replace alter = . if missing(alter) 
label define alterlbl 1 "18-29" 2 "30-59" 3 "60+"
label values alter alterlbl

* Bildung
/*
Für die Aufschlüsselung nach 
1 'Volks- Hauptschulabschluss'
2 'Mittlere Reife / Fachhochschulreife'
3 'Abitur, Fachhochschulabschluss, Hochschulabschluss'.
*/

* welle 3
gen bildung3 = .
replace bildung3 = 1 if edlvade <= 3
replace bildung3 = 2 if edlvade == 4 | edlvade == 5
replace bildung3 = 3 if edlvade >= 6
replace bildung3 = . if missing(edlvade) 
label define bildungslbl 1 "<= Hauptschule" 2 "Realschule / FH-Reife" 3 ">= Abitur"
label values bildung3 bildungslbl

* welle 8
gen bildung8 = .
replace bildung8 = 1 if edubde1  <= 3
replace bildung8 = 2 if edubde1 == 4 | edubde1 == 5
replace bildung8 = 3 if edubde1 == 6
replace bildung8 = . if missing(edubde1) 
label values bildung8 bildungslbl

gen bildung38 = .
replace bildung38 = 1 if bildung3 == 1 | bildung8 == 1
replace bildung38 = 2 if bildung3 == 2 | bildung8 == 2
replace bildung38 = 3 if bildung3 == 3 | bildung8 == 3
label values bildung38 bildungslbl

* ost/west (Berlin excluded)
gen ostwest1 = .
replace ostwest1 = 1 if regionde >= 12 & regionde <= 16
replace ostwest1 = 2 if regionde <= 10
replace ostwest1 = . if missing(regionde)

gen ostwest2 = .
replace ostwest2 = 1 if cregion == "DE4" | cregion == "DE8" | cregion == "DED" | ///
	cregion == "DEE" | cregion == "DEG"
replace ostwest2 = 2 if cregion == "DE1" | cregion == "DE2" | ///
	cregion == "DE5" | cregion == "DE6" | cregion == "DE7" | cregion == "DE9" | ///
	cregion == "DEA" | cregion == "DEB" | cregion == "DEC" | cregion == "DEF"
replace ostwest2 = . if missing(cregion)

gen ostwest = .
replace ostwest = 1 if ostwest1 == 1 | ostwest2 == 1
replace ostwest = 2 if ostwest1 == 2 | ostwest2 == 2

label define owlbl 1 "Ost" 2 "West"
label values ostwest owlbl

* lr scale
gen lr = .
replace lr = 1 if lrscale <= 3
replace lr = 2 if lrscale > 3 & lrscale < 7
replace lr = 3 if lrscale >= 7
replace lr = . if missing(lrscale) 
label define lrlbl 1 "Links" 2 "Mitte" 3 "Rechts"
label values lr lrlbl


*** ABHAENGIGE VARIABLEN

* imbleco
gen imbleco2 =.
label var imbleco2 "Migranten kosten mehr als sie beitragen (imbleco)"
replace imbleco2 = 1 if imbleco > 5
replace imbleco2 = 2 if imbleco == 5
replace imbleco2 = 3 if imbleco < 5
replace imbleco2 = . if missing(imbleco) 
label define zustimmunglbl 1 "Stimme nicht zu" 2 "Neutral" 3 "Stimme zu"
label values imbleco2 zustimmunglbl

* imbgeco
gen imbgeco2 =.
label var imbgeco2 "Migranten sind schlecht für die deutsche Wirtschaft (imbgeco)"
replace imbgeco2 = 1 if imbgeco > 5
replace imbgeco2 = 2 if imbgeco == 5
replace imbgeco2 = 3 if imbgeco < 5
replace imbgeco2 = . if missing(imbgeco) 
label values imbgeco2 zustimmunglbl

* imsmrgt
* ESS1

* imsmrgt
* categorical

* imvtctz
* ESS6

* almuslv
* ESS7

* imueclt
gen imueclt2 =.
label var imueclt2 "Migranten untergraben die deutsche Kultur (imueclth)"
replace imueclt2 = 1 if imueclt > 5
replace imueclt2 = 2 if imueclt == 5
replace imueclt2 = 3 if imueclt < 5
replace imueclt2 = . if missing(imueclt) 
label values imueclt2 zustimmunglbl

* imwbcnt
gen imwbcnt2 =.
label var imwbcnt2 "Migranten machen die Welt schlechter (imwbcnt)"
replace imwbcnt2 = 1 if imwbcnt > 5
replace imwbcnt2 = 2 if imwbcnt == 5
replace imwbcnt2 = 3 if imwbcnt < 5
replace imwbcnt2 = . if missing(imwbcnt) 
label values imwbcnt2 zustimmunglbl

* imwbcnt
gen qfimcmt2 =.
label var qfimcmt2 "Wichtig, dass sich Migranten dem deutschen Lebensstil anpassen (qfimcmt)"
replace qfimcmt2 = 1 if qfimcmt < 5
replace qfimcmt2 = 2 if qfimcmt == 5
replace qfimcmt2 = 3 if qfimcmt > 5
replace qfimcmt2 = . if missing(qfimcmt) 
label values qfimcmt2 zustimmunglbl


****
* DATENANALYSE
****

log using results_qfimcmt.log, replace

*** "Wichtig, dass sich Migranten dem deutschen Lebensstil anpassen (qfimcmt)"
* WEIGHTED
tab qfimcmt2 essround [aweight=pspwght] if ctzcntr == 1, col
tab qfimcmt2 essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab qfimcmt2 essround if ctzcntr == 1, col
tab qfimcmt2 essround if mig == 0, col

log close


*** rest
log using results1-9.log, replace

*** "Migranten kosten mehr als sie beitragen" (imbleco)
* WEIGHTED
tab imbleco2 essround [aweight=pspwght] if ctzcntr == 1, col
tab imbleco2 essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab imbleco2 essround if ctzcntr == 1, col
tab imbleco2 essround if mig == 0, col


*** "Migranten sind schlecht für die deutsche Wirtschaft" (imbgeco)
* WEIGHTED
tab imbgeco2 essround [aweight=pspwght] if ctzcntr == 1, col
tab imbgeco2 essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab imbgeco2 essround if ctzcntr == 1, col
tab imbgeco2 essround if mig == 0, col


*** "Migranten untergraben die deutsche Kultur (imueclth)"
* WEIGHTED
tab imueclt2 essround [aweight=pspwght] if ctzcntr == 1, col
tab imueclt2 essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab imueclt2 essround if ctzcntr == 1, col
tab imueclt2 essround if mig == 0, col


*** "Migranten machen die Welt schlechter (imwbcnt)"
* WEIGHTED
tab imwbcnt2 essround [aweight=pspwght] if ctzcntr == 1, col
tab imwbcnt2 essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab imwbcnt2 essround if ctzcntr == 1, col
tab imwbcnt2 essround if mig == 0, col


*** "Wann sollten Migranten Recht auf Sozialhilfe haben?"
* WEIGHTED
tab imsclbn essround [aweight=pspwght] if ctzcntr == 1, col
tab imsclbn essround [aweight=pspwght] if mig == 0, col

* UNWEIGHTED
tab imsclbn essround if ctzcntr == 1, col
tab imsclbn essround if mig == 0, col



*** Welle 3 und 8 fuer Untergruppen
keep if essround == 3 | essround == 8

***
* "Migranten sind schlecht für die deutsche Wirtschaft" (imbgeco)

*** ALTER
* WEIGHTED
bys essround: tab imbgeco2 alter if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imbgeco2 alter if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imbgeco2 alter essround if ctzcntr == 1
table imbgeco2 alter essround if mig == 0


*** GESCHLECHT
* WEIGHTED
bys essround: tab imbgeco2 gndr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imbgeco2 gndr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imbgeco2 gndr essround if ctzcntr == 1
table imbgeco2 gndr essround if mig == 0


*** BILDUNG
* WEIGHTED
bys essround: tab imbgeco2 bildung38 if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imbgeco2 bildung38 if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imbgeco2 bildung38 essround if ctzcntr == 1
table imbgeco2 bildung38 essround if mig == 0


*** OST/WEST
* WEIGHTED
bys essround: tab imbgeco2 ostwest if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imbgeco2 ostwest if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imbgeco2 ostwest essround if ctzcntr == 1
table imbgeco2 ostwest essround if mig == 0


*** LINKS/RECHTS
* WEIGHTED
bys essround: tab imbgeco2 lr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imbgeco2 lr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imbgeco2 lr essround if ctzcntr == 1
table imbgeco2 lr essround if mig == 0

***
* "Migranten untergraben die deutsche Kultur (imueclth)"

*** ALTER
* WEIGHTED
bys essround: tab imueclt2 alter if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imueclt2 alter if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imueclt2 alter essround if ctzcntr == 1
table imueclt2 alter essround if mig == 0


*** GESCHLECHT
* WEIGHTED
bys essround: tab imueclt2 gndr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imueclt2 gndr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imueclt2 gndr essround if ctzcntr == 1
table imueclt2 gndr essround if mig == 0


*** BILDUNG
* WEIGHTED
bys essround: tab imueclt2 bildung38 if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imueclt2 bildung38 if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imueclt2 bildung38 essround if ctzcntr == 1
table imueclt2 bildung38 essround if mig == 0


*** OST/WEST
* WEIGHTED
bys essround: tab imueclt2 ostwest if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imueclt2 ostwest if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imueclt2 ostwest essround if ctzcntr == 1
table imueclt2 ostwest essround if mig == 0


*** LINKS/RECHTS
* WEIGHTED
bys essround: tab imueclt2 lr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imueclt2 lr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imueclt2 lr essround if ctzcntr == 1
table imueclt2 lr essround if mig == 0

***
* "Migranten machen die Welt schlechter (imwbcnt)"

*** ALTER
* WEIGHTED
bys essround: tab imwbcnt2 alter if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imwbcnt2 alter if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imwbcnt2 alter essround if ctzcntr == 1
table imwbcnt2 alter essround if mig == 0


*** GESCHLECHT
* WEIGHTED
bys essround: tab imwbcnt2 gndr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imwbcnt2 gndr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imwbcnt2 gndr essround if ctzcntr == 1
table imwbcnt2 gndr essround if mig == 0


*** BILDUNG
* WEIGHTED
bys essround: tab imwbcnt2 bildung38 if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imwbcnt2 bildung38 if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imwbcnt2 bildung38 essround if ctzcntr == 1
table imwbcnt2 bildung38 essround if mig == 0


*** OST/WEST
* WEIGHTED
bys essround: tab imwbcnt2 ostwest if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imwbcnt2 ostwest if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imwbcnt2 ostwest essround if ctzcntr == 1
table imwbcnt2 ostwest essround if mig == 0


*** LINKS/RECHTS
* WEIGHTED
bys essround: tab imwbcnt2 lr if ctzcntr == 1 [aweight=pspwght], col 
bys essround: tab imwbcnt2 lr if mig == 0 [aweight=pspwght], col 

* UNWEIGHTED
table imwbcnt2 lr essround if ctzcntr == 1
table imwbcnt2 lr essround if mig == 0


log close

