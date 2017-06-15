libname i2 "\\cdc.gov\private\L330\ykf1\New folder\Iraq\Iraq 2";

/* Table 1. General characterisitics of participants in oral cholera vaccine coverage survey */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	sex age_cat / cl(type=wilson psmall=.2) deff;
run;

/* Table 2. Estimated oral cholera vaccination coverage, Iraq, 2015	*/								

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables dose_num / cl(type=wilson psmall=.2) deff;
ods output OneWay=oneway;
run;

data table2a;
set oneway;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
keep /*F_dose_num*/ frequency weighted_percent CI ;
run;

proc sort data=table2a;
by DESCENDING weighted_percent;
run;

proc print data=table2a noobs; run;

/*by gender*/

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables dose_num * sex / column cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table2b;
set crosstabs;
percent = round(percent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
keep /*F_dose_num*/ sex frequency colpercent2 CI ;
run;

proc sort data=table2b;
by DESCENDING colpercent2;
run;

proc print data=table2b noobs; where sex="male"; var Frequency colpercent2 CI;run;
proc print data=table2b noobs; where sex="female"; var Frequency colpercent2 CI; run;

*by age category;

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables dose_num * age_cat / column cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table2c;
set crosstabs;
percent = round(percent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order age_cat frequency colpercent2 CI ;
run;

proc sort data=table2c;
by order /*DESCENDING dose_num /*colpercent2*/;
run;

proc print data=table2c noobs; where age_cat="1-4 yrs"; var Frequency colpercent2 CI;run;
proc print data=table2c noobs; where age_cat="5-14 yr"; var Frequency colpercent2 CI; run;
proc print data=table2c noobs; where age_cat=">15 yrs"; var Frequency colpercent2 CI; run;

proc print data=table2c noobs; run;

*by gender and age category;

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables sex * dose_num * age_cat / column cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table2d;
set crosstabs;
percent = round(percent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order age_cat sex frequency colpercent2 CI ;
run;

proc sort data=table2d;
by order /*DESCENDING dose_num /*colpercent2*/;
run;

proc print data=table2d noobs; where age_cat="1-4 yrs" and sex="male"; var Frequency colpercent2 CI; run;
proc print data=table2d noobs; where age_cat="1-4 yrs" and sex="female"; var Frequency colpercent2 CI; run;

proc print data=table2d noobs; where age_cat="5-14 yr" and sex="male"; var Frequency colpercent2 CI; run;
proc print data=table2d noobs; where age_cat="5-14 yr" and sex="female"; var Frequency colpercent2 CI; run;

proc print data=table2d noobs; where age_cat=">15 yrs" and sex="male"; var Frequency colpercent2 CI; run;
proc print data=table2d noobs; where age_cat=">15 yrs" and sex="female"; var Frequency colpercent2 CI; run;

/* Table 3. Overall estimate of oral cholera vaccine coverage by vaccination card status, Iraq, 2015 */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables howmanydoses / col cl(type=wilson psmall=.2) deff;
run;

data card2;
set i2.analysis_data;
if howmanydoses="twodoses" and firstdosecard="yes" and seconddosecard="yes" then dose2card2 = 1;
else dose2card2=0;

if howmanydoses="twodoses" and firstdosecard="yes" and seconddosecard ne "yes" then dose2card1 = 1;
else if howmanydoses="twodoses" and firstdosecard ne "yes" and seconddosecard = "yes" then dose2card1 = 1;
else dose2card1=0;

if howmanydoses="twodoses" and firstdosecard ne "yes" and seconddosecard ne "yes" then dose2card0 = 1;
else dose2card0=0;

if howmanydoses="onedose" and firstdosecard = "yes" then dose1card1 = 1;
else if receivedose="yes" and howmanydoses = "" and firstdosecard = "yes" then dose1card1= 1;
else dose1card1=0;

if howmanydoses="onedose" and firstdosecard ne "yes" then dose1card0 = 1;
else if receivedose="yes" and howmanydoses = "" and firstdosecard ne "yesrecall" then dose1card0= 1;
else dose1card0=0;

/* see table 3 classification.xlsx document */

if receivedose="yes" and howmanydoses= "" and firstdosecard = "" then missing = 1;
else if receivedose="dontremember" and firstdosecard = "" then missing = 1;
else if receivedose="" and firstdosecard = "" then missing = 1;
else missing = 0;

if receivedose = "no" and howmanydoses=""  then dose0 = 1;
else dose0=0;

run;

/*proc freq data=i2.analysis_data;
tables receivedose * howmanydoses * firstdosecard * seconddosecard / list missing;
run;*/

proc surveyfreq data=card2;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables dose2card2 dose2card1 dose2card0 dose1card1 dose1card0 dose0 missing;
run;

/* Table 4. Estimated 2 dose oral cholera coverage, proven with physical vaccination cards, Iraq, 2015 */

data two_dose_card;
set i2.analysis_data;
if howmanydoses = "twodoses" and firstdosecard="yes" and seconddosecard="yes" then fullvac=1;
else fullvac=0;
run;

proc surveyfreq data= two_dose_card nomcar;
/*stratum governorate;*/
cluster new_hhno;
weight analysis_weight;
tables fullvac  / col cl(type=wilson psmall=.2) deff;
run;

/*by sex*/

proc surveyfreq data= two_dose_card nomcar;
/*stratum governorate;*/
cluster new_hhno;
weight analysis_weight;
tables fullvac * sex  / col cl(type=wilson psmall=.2) deff;
run;

/*by age*/

proc surveyfreq data= two_dose_card nomcar;
/*stratum governorate;*/
cluster new_hhno;
weight analysis_weight;
tables fullvac * age_cat / col cl(type=wilson psmall=.2) deff;
run;

/*by age and sex*/

proc surveyfreq data= two_dose_card nomcar;
/*stratum governorate;*/
cluster new_hhno;
weight analysis_weight;
tables sex * fullvac * age_cat / col cl(type=wilson psmall=.2) deff;
run;

/* calculating n's */

proc surveyfreq data= two_dose_card nomcar;
/*stratum governorate;*/
cluster new_hhno;
weight analysis_weight;
tables sex age_cat  / col cl(type=wilson psmall=.2) deff;
run;

/* Table 5. Estimates of vaccination location, Iraq, 2015  */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables wherevaccinated / cl(type=wilson psmall=.2) deff;
ods output oneway=oneway;
run;

data table5a;
set oneway;
percent = round(percent, .1);
percent2 = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_wherevaccinated = "Total" then delete;
if wherevaccinated="house" then order=1;
else if wherevaccinated="healthcarecenter" then order=2;
else if wherevaccinated="school" then order=3;
else if wherevaccinated="market" then order=4;
else if wherevaccinated="other" then order=5;
keep /*F_wherevaccinated*/ order frequency percent2 CI ;
run;

proc sort data=table5a;
by order /*DESCENDING dose_num /*percent2*/;
run;

proc print data=table5a noobs; var Frequency percent2 CI;run;


/* by sex */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables wherevaccinated * sex / col cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table5b;
set crosstabs;
colpercent = round(colpercent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_wherevaccinated = "Total" then delete;
if wherevaccinated="house" then order=1;
else if wherevaccinated="healthcarecenter" then order=2;
else if wherevaccinated="school" then order=3;
else if wherevaccinated="market" then order=4;
else if wherevaccinated="other" then order=5;
keep /*F_wherevaccinated*/ sex order frequency colpercent2 CI ;
run;

proc sort data=table5b;
by order /*DESCENDING dose_num /*colpercent2*/;
run;

proc print data=table5b noobs; where sex="male"; var Frequency colpercent2 CI;run;
proc print data=table5b noobs; where sex="female"; var Frequency colpercent2 CI;run;

/* by age */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables wherevaccinated * age_cat / col cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table5c;
set crosstabs;
colpercent = round(colpercent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_wherevaccinated = "Total" then delete;
if wherevaccinated="house" then order=1;
else if wherevaccinated="healthcarecenter" then order=2;
else if wherevaccinated="school" then order=3;
else if wherevaccinated="market" then order=4;
else if wherevaccinated="other" then order=5;
keep /*F_wherevaccinated*/ age_cat order frequency colpercent2 CI ;
run;

proc sort data=table5c;
by order /*DESCENDING dose_num /*colpercent2*/;
run;

proc print data=table5c noobs; where age_cat="1-4 yrs" ; var Frequency colpercent2 CI; run;
proc print data=table5c noobs; where age_cat="5-14 yr" ; var Frequency colpercent2 CI; run;
proc print data=table5c noobs; where age_cat=">15 yrs" ; var Frequency colpercent2 CI; run;

/* by age and sex */

proc surveyfreq data=i2.analysis_data nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables sex * wherevaccinated * age_cat / col cl(type=wilson psmall=.2) deff;
ods output crosstabs=crosstabs;
run;

data table5d;
set crosstabs;
colpercent = round(colpercent, .1);
colpercent2 = cat( put(colpercent, 4.1), "%" );
Lower_CL = round(collowercl, .1);
Upper_CL = round(coluppercl, .1);
CI = cat( "(" , round(collowercl, .1), "%,", round(coluppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(coluppercl, .1), "%)" );
if F_wherevaccinated = "Total" then delete;
if wherevaccinated="house" then order=1;
else if wherevaccinated="healthcarecenter" then order=2;
else if wherevaccinated="school" then order=3;
else if wherevaccinated="market" then order=4;
else if wherevaccinated="other" then order=5;
keep /*F_wherevaccinated*/ age_cat sex order frequency colpercent2 CI ;
run;

proc sort data=table5d;
by order /*DESCENDING dose_num /*colpercent2*/;
run;

proc print data=table5d noobs; where age_cat="1-4 yrs" and sex="male"; var Frequency colpercent2 CI; run;
proc print data=table5d noobs; where age_cat="5-14 yr" and sex="male"; var Frequency colpercent2 CI; run;
proc print data=table5d noobs; where age_cat=">15 yrs" and sex="male"; var Frequency colpercent2 CI; run;

proc print data=table5d noobs; where age_cat="1-4 yrs" and sex="female"; var Frequency colpercent2 CI; run;
proc print data=table5d noobs; where age_cat="5-14 yr" and sex="female"; var Frequency colpercent2 CI; run;
proc print data=table5d noobs; where age_cat=">15 yrs" and sex="female"; var Frequency colpercent2 CI; run;

/*Table 6. Estimates of oral cholera vaccine coverage by region, Iraq, 2015 */

/* Northern */

data i2.north;
set i2.analysis_data;
if governorate in ("Dahuk", "Erbil", "Sulaymaniyah") then output; else delete;
run; 

proc surveyfreq data=i2.north  nomcar;
cluster new_hhno;
stratum governorate;
weight analysis_weight;
tables /*receivedose howmanydoses*/ dose_num / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway;
run;

data table6a;
set oneway;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table6a;
by order;
run;

proc print data=table6a noobs; var /*Frequency*/ weighted_percent CI ; run;

/* South Central */

data i2.south_central;
set i2.analysis_data;
if governorate in ("Najaf", "Baghdad-Karkh", "Kerbala", "Salahal-Din",
				   "Anbar",  /*"Diala",*/ "Wassit", "Babylon") then output; else delete;
run; 

proc surveyfreq data=i2.south_central  nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables /*receivedose howmanydoses*/ dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway;
run;

data table6b;
set oneway;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table6b;
by order;
run;

proc print data=table6b noobs; var /*Frequency*/ weighted_percent CI ; run;

/* Table 7. Estimates of oral cholera vaccine coverage by governorate, Iraq, 2015 */

*Dahuk;

data i2.dahuk;
set i2.analysis_data;
if governorate = "Dahuk" then output; else delete;
run;

proc surveyfreq data=i2.dahuk nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway;
run;

data table7a;
set oneway;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7a;
by order;
run;

proc print data=table7a noobs; var /*Frequency*/ weighted_percent CI ; run;

*Erbil;

data i2.erbil;
set i2.analysis_data;
if governorate = "Erbil" then output; else delete;
run;

proc surveyfreq data=i2.erbil nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway;
run;

data table7b;
set oneway;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7b;
by order;
run;

proc print data=table7b noobs; var /*Frequency*/ weighted_percent CI ; run;

*Sulaymaniyah;

data i2.sulaymaniyah;
set i2.analysis_data;
if governorate = "Sulaymaniyah" then output; else delete;
run;

proc surveyfreq data=i2.sulaymaniyah nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_c;
run;

data table7c;
set oneway_c;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7c;
by order;
run;

proc print data=table7c noobs; var /*Frequency*/ weighted_percent CI ; run;

*Najaf;

data i2.najaf;
set i2.analysis_data;
if governorate = "Najaf" then output; else delete;
run;

proc surveyfreq data=i2.najaf nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_d;
run;

data table7d;
set oneway_d;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7d;
by order;
run;

proc print data=table7d noobs; var /*Frequency*/ weighted_percent CI ; run;

*Baghdad-Karkh;

data i2.baghdad;
set i2.analysis_data;
if governorate = "Baghdad-Karkh" then output; else delete;
run;

proc surveyfreq data=i2.baghdad nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_e;
run;

data table7e;
set oneway_e;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7e;
by order;
run;

proc print data=table7e noobs; var /*Frequency*/ weighted_percent CI ; run;

*Kerbala;

data i2.kerbala;
set i2.analysis_data;
if governorate = "Kerbala" then output; else delete;
run;

proc surveyfreq data=i2.kerbala nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_f;
run;

data table7f;
set oneway_f;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7f;
by order;
run;

proc print data=table7f noobs; var /*Frequency*/ weighted_percent CI ; run;

*Salahal-Din;

data i2.salahal;
set i2.analysis_data;
if governorate = "Salahal-Din" then output; else delete;
run;

proc surveyfreq data=i2.salahal nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_g;
run;

data table7g;
set oneway_g;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7g;
by order;
run;

proc print data=table7g noobs; var /*Frequency*/ weighted_percent CI ; run;

*Anbar;

data i2.anbar;
set i2.analysis_data;
if governorate = "Anbar" then output; else delete;
run;

proc surveyfreq data=i2.anbar nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_h;
run;

data table7h;
set oneway_h;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7h;
by order;
run;

proc print data=table7h noobs; var /*Frequency*/ weighted_percent CI ; run;

*Wassit;

data i2.wassit;
set i2.analysis_data;
if governorate = "Wassit" then output; else delete;
run;

proc surveyfreq data=i2.wassit nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_i;
run;

data table7i;
set oneway_i;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7i;
by order;
run;

proc print data=table7i noobs; var /*Frequency*/ weighted_percent CI ; run;

*Babylon;

data i2.babylon;
set i2.analysis_data;
if governorate = "Babylon" then output; else delete;
run;

proc surveyfreq data=i2.babylon nomcar;
weight analysis_weight;
cluster new_hhno;
tables dose_num  / cl(type=wilson psmall=.2) deff; 
ods output oneway=oneway_j;
run;

data table7j;
set oneway_j;
percent = round(percent, .1);
weighted_percent = cat( put(percent, 4.1), "%" );
Lower_CL = round(lowercl, .1);
Upper_CL = round(uppercl, .1);
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_dose_num = "Total" then delete;
if dose_num="n" then order=4;
if dose_num="2" then order=1;
if dose_num="1" then order=2;
if dose_num="0" then order=3;
keep /*F_dose_num*/ order frequency weighted_percent CI ;
run;

proc sort data=table7j;
by order;
run;

proc print data=table7j noobs; var /*Frequency*/ weighted_percent CI ; run;

/* Table 8. Primary reason for not receiving oral cholera vaccine */

proc freq data=i2.analysis_data;
table reasonnotvaccinated;
run;

proc surveyfreq data=i2.analysis_data nomcar;
weight analysis_weight;
cluster new_hhno;
tables  reasonnotvaccinated  / cl(type=wilson psmall=.2) deff; 
ods output OneWay=table1;
run;

data vac;
set table1;
weighted_percent = cat( put(percent, 4.1), "%" );
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
keep F_reasonnotvaccinated frequency /*wgtfreq*/ weighted_percent CI;
run;

proc sort data=vac; by DESCENDING weighted_percent ; run;

proc print data=vac noobs;
run;

proc surveyfreq data=i2.analysis_data nomcar;
weight analysis_weight;
cluster new_hhno;
tables  reasonnoseconddose  / cl(type=wilson psmall=.2) deff; 
ods output OneWay=table2;
run;

proc print data=table2; run;

data no2dose;
set table2;
weighted_percent = cat( put(percent, 4.1), "%" );
CI = cat( "(" , round(lowercl, .1), "%,", round(uppercl, .1), "%)" ) ;
if index(CI, "0%") = 2 then CI = cat( "(<0.1%, ", round(uppercl, .1), "%)" );
if F_reasonnoseconddose = "wasabsentduring" then order=1;
else if F_reasonnoseconddose = "teamsdidnotvisit" then order=2;
else if F_reasonnoseconddose = "vaccinesnotavailable" then order=3;
else if F_reasonnoseconddose = "nofaithin" then order=4;
else if F_reasonnoseconddose = "wassick" then order=5;
else if F_reasonnoseconddose = "badtasteof" then order=6;
else if F_reasonnoseconddose = "decisionmakernot" then order=7;
else if F_reasonnoseconddose = "vaccinatorwasnot" then order=8;
else if F_reasonnoseconddose = "noresponse" then order=9;
else if F_reasonnoseconddose = "busynotime" then order=10;
else if F_reasonnoseconddose = "didnothearabout" then order=11;
else if F_reasonnoseconddose = "didntknowwhen" then order=12;
else if F_reasonnoseconddose = "religiousbeliefs" then order=13;
else if F_reasonnoseconddose = "clinicwasclosed" then order=14;
else if F_reasonnoseconddose = "badexperienceadverse" then order=15;
else if F_reasonnoseconddose = "didnotknow" then order=16;
else if F_reasonnoseconddose = "other" then order=17;
else if F_reasonnoseconddose = "Total" then delete;
keep F_reasonnoseconddose frequency /*wgtfreq*/ weighted_percent CI order;
run;

proc sort data=no2dose; by order ; run;

proc print data=no2dose noobs; var frequency weighted_percent CI;
run;

proc freq data=i2.analysis_data;
tables reasonnotvaccinated * governorate / nocol norow nopercent nocum;
run;

******************
What info?
*****************;
/*
proc surveyfreq data=i2.analysis_data nomcar;
weight analysis_weight;
cluster new_hhno;
tables  informationsources  / cl(type=wilson psmall=.2) deff; 
ods output OneWay=table3;
run;

proc contents data=i2.analysis_data;
run;

proc freq data=i2.analysis_data;
table new_hhno * governorate / norow nocol nopercent nocum;
run;

data a;
set i2.analysis_data;
run;*/



/* Table 9. From which information sources did you hear about cholera campaign?	*/		

ods trace on;

data how;
set i2.analysis_data;
if index(informationsources, 'neighborsfriends') > 0 then neighborsfriends = 1;
	else neighborsfriends = 0;
if index(informationsources, 'television') > 0 then television = 1;
	else television = 0;
if index(informationsources, 'mohhealthstaff') > 0 then mohhealthstaff = 1;
	else mohhealthstaff = 0;
if index(informationsources, 'radio') > 0 then radio = 1;
	else radio = 0;
if index(informationsources, 'internet') > 0 then internet = 1;
	else internet = 0;
if index(informationsources, 'schools') > 0 then schools = 1;
	else schools = 0;
if index(informationsources, 'posterbanner') > 0 then posterbanner = 1;
	else posterbanner = 0;
if index(informationsources, 'mosqueannouncements') > 0 then mosqueannouncements = 1;
	else mosqueannouncements = 0;
if index(informationsources, 'communitymobilizer') > 0 then communitymobilizer = 1;
	else communitymobilizer = 0;
if index(informationsources, 'sms') > 0 then sms = 1;
	else sms = 0;
run;

proc surveyfreq data=how nomcar;
stratum governorate;
weight analysis_weight;
cluster new_hhno;
tables neighborsfriends television mohhealthstaff radio internet 
		schools posterbanner mosqueannouncements communitymobilizer sms
/ cl(type=wilson psmall=.2) deff row; 
run;

proc print data=how ;
var informationsources has has2;
run;

/* Table 10. Did you (or child) have any side effects within 14 days after receiving the 1st or 2nd dose of cholera vaccine? */

data side_effect;
set i2.analysis_data;
if index(havesideeffect, 'abdominalpain') > 0 then abdominalpain = 1;
	else abdominalpain = 0;
if index(havesideeffect, 'diarrhea') > 0 then diarrhea = 1;
	else diarrhea = 0;
if index(havesideeffect, 'vomiting') > 0 then vomiting = 1;
	else vomiting = 0;
if index(havesideeffect, 'fever') > 0 then fever = 1;
	else fever = 0;
if index(havesideeffect, 'headache') > 0 then headache = 1;
	else headache = 0;
if index(havesideeffect, 'nausea') > 0 then nausea = 1;
	else nausea = 0;
if index(havesideeffect, 'vertigo') > 0 then vertigo = 1;
	else vertigo = 0;
if index(havesideeffect, 'weaknessfatigue') > 0 then weaknessfatigue = 1;
	else weaknessfatigue = 0;
if index(havesideeffect, 'faintingwithinan') > 0 then faintingwithinan = 1;
	else faintingwithinan = 0;
if index(havesideeffect, 'rash') > 0 then rash = 1;
	else rash = 0;
run;

proc surveyfreq data=side_effect nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	sideeffect abdominalpain diarrhea vomiting fever headache 
nausea vertigo weaknessfatigue faintingwithinan rash / cl(type=wilson psmall=.2) deff;
run;

proc surveyfreq data=side_effect nomcar;
stratum governorate;
cluster new_hhno;
weight analysis_weight;
tables 	sideeffect / cl(type=wilson psmall=.2) deff;
run;
