import excel "C:\Users\Dell\Desktop\ECHANTILLONAGE\districts sanitaires.xlsx", sheet("POP DISTRICT") firstrow clear
br
sort REGION DISTRICT
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
tab REGION

***SONDAGE ALEATOIRE SIMPLE
*Consiste à tirer au hasard les individus dans la base de sondage 
*Tous les individus ont la meme probabilite d'inclusion dans la base de sondage
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
sample 10
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
sample 7, count
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\EchantillonSAS.dta", replace


***SONDAGE A PROBABILITE INEGALE
*Consiste à tirer les individus avec une probabilite inegale
***Installation en ligne du module gsample sous Stata
ssc install moremata, replace
ssc install gsample, replace

***Installation manuelle du module gsample sous stata
*extraire le fichier "gsample.zip" et "moremata" dans le disque C
*sous stata executer les syntaxes ci apres
net from "C:/gsample/"
net install gsample, replace
net from "C:/moremata/"
net install moremata, replace

*tirage echantillon
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
gsample 10 [aw=POP2016]
gsample 10 [aw=POP2016], wor
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\EchantillonSPI.dta", replace


***SONDAGE STRATIFIE
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
sample 1 , count by (REGION)
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\EchantillonSS.dta", replace


***SONDAGE PAR GRAPPE
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
sample 1 , count by (REGION)
keep REGION
sample 5, count
sort REGION
merge 1:m REGION using "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta"
drop if _merge!=3
drop _merge
sort REGION DISTRICT
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\EchantillonSG.dta", replace


***SONDAGE A PLUSIEURS DEGRES
*tirage des grappes au premier degré (fait précédemment)
*tirage au second degré 
sample 1 , count by (REGION)
save "C:\Users\Dell\Desktop\ECHANTILLONAGE\EchantillonSG.dta", replace


***SONDAGE SYSTEMATIQUE
use "C:\Users\Dell\Desktop\ECHANTILLONAGE\BaseSondage.dta", replace
scalar n=7 //taille de l'echantillon
scalar Pas=_N/n
scalar alea=runiformint(1, n)
scalar list
gen ligne=_n
drop if mod(ligne-alea, Pas)!=0
