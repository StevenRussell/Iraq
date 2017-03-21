libname i2 "\\cdc.gov\private\L330\ykf1\New folder\Iraq\Iraq 2";

/* Table 11. Did you (or child) spit part of the first or second dose of the vaccine due to bad taste? */

proc contents data=drink;
run;

proc freq data=i2.analysis_data;
where badtaste="";
table governorate;
run;

data spit;
set i2.analysis_data;
if badtaste="" and governorate ne "Anbar" then badtaste="missing";
if receivedose ne "yes" then badtaste="";
run;

/*proc freq data=i2.analysis_data;
tables receivedose * badtaste / list missing;
run;*/

proc surveyfreq data=spit nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	badtaste / cl(type=wilson psmall=.2) deff;
run;

/* Table 12. Did you receive any other information on cholera during the campaign in November – December 2015? */

data whatinfo;
set i2.analysis_data;
if receiveotherinformation="" and governorate ne "Anbar" then receiveotherinformation="missing";

if index(whatinformation, 'boilwater') > 0 then boilwater = 1;
	else boilwater = 0;
if index(whatinformation, 'disposeofhuman') > 0 then disposeofhuman = 1;
	else disposeofhuman = 0;
if index(whatinformation, 'washvegetablesfruits') > 0 then washvegetablesfruits = 1;
	else washvegetablesfruits = 0;
if index(whatinformation, 'cookfoodthoroughly') > 0 then cookfoodthoroughly = 1;
	else cookfoodthoroughly = 0;
if index(whatinformation, 'washhandswith') > 0 then washhandswith = 1;
	else washhandswith = 0;
if index(whatinformation, 'cleancookingutensils') > 0 then cleancookingutensils = 1;
	else cleancookingutensils = 0;
if index(whatinformation, 'drinkoruse') > 0 then drinkoruse = 1;
	else drinkoruse = 0;
if index(whatinformation, 'takeorsif') > 0 then takeorsif = 1;
	else takeorsif = 0;
if index(whatinformation, 'gotohealth') > 0 then gotohealth = 1;
	else gotohealth = 0;
if index(whatinformation, 'dontknowdont') > 0 then dontknowdont = 1;
	else dontknowdont = 0;
if index(whatinformation, 'other') > 0 then other = 1;
	else other = 0;	
run;

proc surveyfreq data=whatinfo nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables receiveotherinformation / cl(type=wilson psmall=.2) deff;
run;

proc surveyfreq data=whatinfo nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	boilwater disposeofhuman washvegetablesfruits cookfoodthoroughly
		washhandswith cleancookingutensils drinkoruse takeorsif
		gotohealth dontknowdont other / cl(type=wilson psmall=.2) deff;
run;

/* Table 13. What is the main source of drinking water for members of your household? */

proc surveyfreq data=i2.analysis_data nomcar;
weight analysis_weight;
cluster new_hhno;
tables  mainsourcedrinking  / cl(type=wilson psmall=.2) deff; 
ods output OneWay=table1;
run;

data MSD;
set table1;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_mainsourcedrinking = "Total" then delete;
keep F_mainsourcedrinking frequency /*wgtfreq*/ weighted_percent CI ;
run;

proc sort data=MSD;
by DESCENDING weighted_percent;
run;

proc print data=MSD noobs; run;

/* Table 14. What is the second most frequently used source of drinking water for members of your household? */

proc surveyfreq data=i2.analysis_data nomcar;
weight analysis_weight;
cluster new_hhno;
tables  secondsourcedrinking  / cl(type=wilson psmall=.2) deff; 
ods output OneWay=table1;
run;

data SSD;
set table1;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_secondsourcedrinking = "Total" then delete;
keep F_secondsourcedrinking frequency /*wgtfreq*/ weighted_percent CI ;
run;

proc sort data=SSD;
by DESCENDING weighted_percent;
run;

proc print data=SSD noobs; run;

/* Table 13b. Are you using an improved primary water source? */
/* Table 14b. Are you using an improved secondary water source? */

data drink;
set i2.analysis_data;

if mainsourcedrinking in ("pipedwaterin", "pipedwaterpublic") then improved="yes";
else if mainsourcedrinking in ("bottledwatercompany", "wellunprotected", "springwaterunprotected", "riverstreamlake", "watertruckwater") then improved="no";
else if mainsourcedrinking = "other" then improved="no";  /*translated all responses - were unimproved*/
else if mainsourcedrinking = "" and governorate ne "Anbar" then improved="missing";

if secondsourcedrinking = "secondsourcenotavailable" then improved2="secondsourcenotavailable";
else if secondsourcedrinking in ("pipedwaterin", "pipedwaterpublic", "wellprotected") then improved2="yes";
else if secondsourcedrinking in ("bottledwatercompany", "wellunprotected", "springwaterunprotected", "riverstreamlake", "watertruckwater") then improved2="no";
else if secondsourcedrinking = "other" then improved2="no";  /*translated all responses - were unimproved*/
else if secondsourcedrinking = "" and governorate ne "Anbar" then improved2="missing";
run;

proc surveyfreq data=drink nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	improved improved2 / cl(type=wilson psmall=.2) deff;
run;

/* Table 15. What kind of toilet facility do members of your household usually use? (Improved or unimproved sanitation source?) */

data toilet;
set i2.analysis_data;

if governorate ne "Anbar" and toiletshared = "" then toiletshared = "Missing";

if governorate ne "Anbar" and kindtoilet = "" then improved3 = "Missing";
else if kindtoilet in ("flushconnectedtolatrines", "flushconnectedtoseptic", "flushconnectedtosystem",
					"pitlatrineventilated", "pitlatrinewith") then improved3="Yes";
else if kindtoilet in ("pitlatrinewithout", "buckettoilet", "hangingtoilethanging") then improved3="No";
else if kindtoilet = "other" then improved3 ="No";  /*translated all responses - were unimproved*/

run;

proc surveyfreq data=toilet nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables improved3 /*familiessharedwith*/ / cl(type=wilson psmall=.2) deff;
ods output OneWay=table1;
run;

data KT;
set table1;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_improved3 = "Total" then delete;
keep F_improved3 frequency /*wgtfreq*/ weighted_percent CI ;
run;

proc sort data=KT;
by DESCENDING F_improved3;
run;

proc print data=KT noobs; run;

/* Table 15b. What kind of toilet facility do members of your household usually use? */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables kindtoilet / cl(type=wilson psmall=.2) deff;
ods output OneWay=table1;
run;

data KT_b;
set table1;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_kindtoilet = "Total" then delete;
keep /*F_kindtoilet*/ frequency /*wgtfreq*/ weighted_percent CI ;
run;

proc sort data=KT_b;
by DESCENDING weighted_percent;
run;

proc print data=KT_b noobs; run;

/* Table 16. Are these toilet facilities shared with other households? */

data t16;
set i2.analysis_data;
if governorate ne "Anbar";
if toiletshared = "" then toiletshared="missing";
run;

proc surveyfreq data=t16 nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables toiletshared /*familiessharedwith*/ / cl(type=wilson psmall=.2) deff;
run;


/* Table 17. How many people are sharing a bathroom? */ 

data shared1;
set i2.analysis_data;
if governorate ne "Anbar";
if toiletshared = "" then toiletshared = "missing";
run;

proc surveyfreq data=shared1 nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables toiletshared / cl(type=wilson psmall=.2) deff;
run;

data shared2;
set i2.analysis_data;

if toiletshared="yes";
if governorate ne "Anbar" and toiletshared = "" then shared_cat = "missing";

if familiessharedwith ge 4 then shared_cat = "4 or more";
else if familiessharedwith = . then shared_cat="missing";
else if familiessharedwith in (1, 2, 3) then shared_cat = "1-3";

if familiessharedwith ge 10 then shared_cat_original="10 or more";
else if familiessharedwith in (4:9) then shared_cat_original = "4-9";
else if familiessharedwith in (1, 2, 3) then shared_cat_original="1-3";
else if familiessharedwith = . then shared_cat_original="missing";

run;

proc surveyfreq data=shared2 nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables shared_cat shared_cat_original/ cl(type=wilson psmall=.2) deff;
run;

/*proc freq data=shared;
table familiessharedwith;
run;*/

/* Table 18. Do you have soap for handwashing (ask to see soap for confirmation)? */

data soap;
set i2.analysis_data;
if governorate ne "Anbar" and havesoap = "" then havesoap = "Missing";
run;

proc surveyfreq data=soap nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables havesoap / cl(type=wilson psmall=.2) deff;
run;

/* Table 19. When do you wash your hands with soap? */

data when_wash;
set i2.analysis_data;
/*if whenwashhands="" and governorate ne "Anbar"*/

if index(whenwashhands, 'beforeeating') > 0 then beforeeating = 1;
	else if whenwashhands="" then beforeeating=.;
	else beforeeating = 0;
if index(whenwashhands, 'beforecooking') > 0 then beforecooking = 1;
	else if whenwashhands="" then beforecooking=.;
	else beforecooking  = 0;
if index(whenwashhands, 'afterwashingcleaning') > 0 then afterwashingcleaning = 1;
	else if whenwashhands="" then afterwashingcleaning=.;
	else afterwashingcleaning = 0;
if index(whenwashhands, 'aftereating') > 0 then aftereating = 1;
	else if whenwashhands="" then aftereating=.;
	else aftereating = 0;
if index(whenwashhands, 'afterusingthe') > 0 then afterusingthe = 1;
	else if whenwashhands="" then afterusingthe=.;
	else afterusingthe = 0;
if index(whenwashhands, 'aftercleaningthe') > 0 then aftercleaningthe = 1;
	else if whenwashhands="" then aftercleaningthe=.;
	else aftercleaningthe = 0;
if index(whenwashhands, 'aftercleaningbaby') > 0 then aftercleaningbaby= 1;
	else if whenwashhands="" then aftercleaningbaby=.;
	else aftercleaningbaby = 0;
if index(whenwashhands, 'other') > 0 then other = 1;
	else if whenwashhands="" then other=.;
	else other = 0;	

/* If governorate = "Anbar" then do; 
	beforeeating = 99;
	beforecooking  = 99;
	afterwashingcleaning = 99;
	aftereating = 99;
	afterusingthe = 99;
	aftercleaningthe = 99;
	aftercleaningbaby= 99;
	other = 99;
end; */
run;

proc surveyfreq data=when_wash nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables beforeeating  beforecooking afterwashingcleaning aftereating afterusingthe
		aftercleaningthe aftercleaningbaby other / cl(type=wilson psmall=.2) deff;
ods output OneWay=table1;
run;


/*********************************************
Did you know about the cholera campaign prior to the start of the campaign or arrival of the vaccinators?
vs.
Vaccination status
********************************************/;

/*overall*/

data for_chisq;
set i2.analysis_data;
if receivedose="dontremember" then receivedose= "";
run;

proc surveyfreq data=for_chisq nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables knowpriorcampaign*receivedose / cl(type=wilson psmall=.2) deff chisq col;
run;

/* northern governorates */

proc surveyfreq data=for_chisq nomcar;
where governorate in ("Dahuk", "Erbil", "Sulaymaniyah");
cluster new_hhno;
weight analysis_weight;
tables knowpriorcampaign*receivedose / cl(type=wilson psmall=.2) deff chisq row ;
run;

/* south central governorates */

proc surveyfreq data=for_chisq nomcar;
where governorate in ("Najaf", "Baghdad-Karkh", "Kerbala", "Salahal-Din",
				   "Anbar",  /*"Diala",*/ "Wassit", "Babylon");
cluster new_hhno;
weight analysis_weight;
tables knowpriorcampaign*receivedose / cl(type=wilson psmall=.2) deff chisq row ;
run;




