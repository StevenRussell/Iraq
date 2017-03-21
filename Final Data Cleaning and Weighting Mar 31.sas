libname i2 "\\cdc.gov\private\L330\ykf1\New folder\Iraq\Iraq 2";

PROC IMPORT OUT= i2.survey 
            DATAFILE= "\\cdc.gov\private\L330\ykf1\New folder\Iraq\ocv_join_all_final.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data i2.survey_with_age_cats;
set i.survey;
if age < 5 and age ge 1 then age_cat = "1-4 yrs";
else if age ge 5 and age < 15 then age_cat = "5-14 yrs";
else if age ge 15 then age_cat=">15 yrs";

if camp="Amiria carvans camp" and creationdate > "17DEC2015"d then delete;
run;

**************************************************************************************
*********************     Fixing duplicates for all camps      ***********************
**************************************************************************************;

data i2.survey_with_age_cats_nodupes;
set i2.survey_with_age_cats;
*fix;
if objectid=299 or objectid=300 or objectid=301 or objectid=302 or objectid=303 then delete;

*Ya Husein Road;
if objectid=242 or objectid=243 or objectid=244 or objectid=245 then delete;
if objectid in (6430, 6431, 6432, 6433, 6434) then howmanypeople=5;

if objectid=2647 then sex='male';
run;

proc sort data=i2.survey_with_age_cats_nodupes nodupkey;
by x y relation age sex receivedose governorate camp hhno
/*whenwashhands whatinformation mainsourcedrinking secondsourcedrinking kindtoilet toiletshared*/;
run;

**************************************************************************************
*********************        fixing household numbers          ***********************
**************************************************************************************;

data i2.fix_hhno;
set i2.survey_with_age_cats_nodupes;
run;

proc sort data=i2.fix_hhno;
by camp rowid;
run;

data i2.fix_hhno2;
set i2.fix_hhno;
by camp rowid;
do;
if first.camp then new_hhno = 0;
if first.rowid then new_hhno + 1;
end;
run;

**************************************************************************************
*********************             manual changes               ***********************
**************************************************************************************;

data i2.man_edits;
set i2.fix_hhno2;
*Baharka; 
	if objectid = 5806 then delete; /*dupe - age was wrong*/
*Ya Husein Road;

	*objectid 948 looks ok, 1 person had non-response;

	if objectid=6447 then delete;

	if objectid=6415 then delete; /*dupe - sex */
	if objectid=617 then sex='female';

	if objectid=371 then relation='parent';
	if objectid=6421 then delete; /* dupe - relationship */

	/*if objectid=302 then delete;
	if objectid=6428 then objectid=302 and rowid = "51ac6d25-f590-49f6-8d7c-9eb975054c57"
	and new_hhno= 99;
	if objectid in (299, 300, 301, 302, 303) then howmanypeople=5;*/

*Diplaced Population CC;
if objectid = 5376 then delete;
if objectid = 2798 then relation = "parent";  
if objectid = 5377 then delete;
if objectid = 2799 then relation = "parent";  

if objectid = 5442 then delete;
if objectid = 4101 then age=7;

if objectid = 5429 then delete;
if objectid = 4489 then relation='self';

if objectid = 5423 then delete;
if objectid = 5010 then relation='self';

if objectid = 5391 then delete;
if objectid = 5033 then relation='sibling';

if objectid = 5317 then delete;
if objectid = 4480 then sex="male";

if objectid = 5486 then delete;
if objectid = 2253 then do; receivedose='yes'; howmanydoses="twodoses"; firstdosecard="yesrecall"; seconddosecard="yesrecall"; end;

/*if objectid = 1788 then;*/

if objectid = 5438 then delete;
if objectid = 4370 then sex="male";

if objectid = 5372 then delete;
if objectid = 2792 then relation="parent";

if objectid = 5379 then delete;
if objectid= 2721 then relation="self";

if objectid = 5581 then delete;
if objectid = 1563 then relation="granparent";

*;
if objectid = 6432 then delete;
if objectid = 244 then sex="male";

*from Wasan email Thu Jan 21;
if objectid in (3323, 3324) then do; new_hhno = 83; howmanypeople=5; end;
if objectid in (3322) then do; new_hhno = 90; howmanypeople=7; end;
if objectid = 3321 then do; new_hhno=22; howmanypeople=3; end;

*fixing howmanypeople variable for HH level weight;
if objectid in (780, 781, 782) then howmanypeople=3;
if objectid in (2562, 2561, 2560) then howmanypeople=3;
if objectid in (491, 492, 493) then delete; /*appears that these are duplicates from objectids above*/
if objectid in (776, 777, 778, 779) then delete; /*duplicate of objectid 790, 791, 792, 793 slightly different x, y */

if objectid in (5131) then delete; /*think this was a duplicate*/

/*getting rid of blank entries*/
if objectid in (6751, 6489, 6488, 1159, 6747, 6763, 1138, 6663, 6683, 6671,
				3833, 500, 3622, 581, 288, 3111, 356, 436, 164,
				151, 2839, 1370, 1309, 1171, 1018, 398, 694, 

				6517, 914, 2701) then delete;

/*fixing Amiria carvans camp*/
if objectid in (1157, 1155) then do; howmanypeople=7; new_hhno=33; rowid="4f96a5d8-2f5e-4324-a3f2-45dfd9004bc1"; end;
if objectid in (1146, 1148, 1149) then do; howmanypeople=7; new_hhno=89; rowid="fc8544cf-a5f3-4bfa-9c2c-b0e37b68618c"; end;
if objectid in (1142, 1143, 1141) then do; howmanypeople=6; new_hhno=11; rowid="2cc816d2-b6df-45de-883d-0b18100d44a0"; end;
if objectid in (1134, 1135, 1136) then do; howmanypeople=8; new_hhno=13; rowid="2f107f1c-d6d3-4f76-8f12-920501062a32"; end;
if objectid in (6594, 6595, 6596, 6597, 6598) then howmanypeople=8;
if objectid in (1119) then do; new_hhno=83 ; rowid="ea8819f7-2908-42ea-8df6-2f8ef0d74b08"; end;
if objectid in (6074) then do; new_hhno=54 ; rowid="840bc1a6-2124-4fd0-9e35-d338baa1656b"; end;
if objectid in (2840) then do; howmanypeople=5; new_hhno=8; rowid="1dc791ce-5490-4002-8800-01609c2274ad"; end;
if objectid in (2854) then do; new_hhno=48; rowid="76055d45-9908-4d7c-bcdc-82b097c16374"; end;
if objectid in (1113) then do; new_hhno=26; rowid="499097b1-34e9-414c-8b15-9e5c635e9523"; end;

/*these hh's were manually deleted. They had updates on the 19th or 20th. Not originally caught with the dupkey b/c the
x y coordinates were not the same. */

/*if camp = "Amiria carvans camp" and new_hhno in (29, 86, 12, 56, 39, 45, 3, 70, 21, 35, 25, 7, 61
				40, 79, 38, 59, 69, 27, 80, 51, 24, 74, 20, 87, 65,
				5, 77, 23, 46, 47, 6, 19, 10, 71, 82, 17, 72, 52, 68, 75, 37, 4) then delete;*/
if objectid in (1140, 1139, 1137,
				1156, 1154, 1153, 1152, 1151,
				1144, 1145, 1150, 1147
				1129, 1130, 1131, 1133,
				1121, 1118, 1122, 1123, 1120, 1124,
				6069, 6068, 6072, 6071, 6070,
				2853, 2858, 2859, 2856, 2857, 2855,
				1111, 1110, 1112, 1109) then delete; 
run;


**************************************************************************************
*********************    weighting for non-response by camp    ***********************
**************************************************************************************;

/* looking at number of distinct HH numbers */
proc freq data = i2.man_edits noprint; /*i2.survey_with_weights*/
table new_hhno*camp / out=hh_look ; /*norow nocol nocum nopercent*/
run;

proc freq data=hh_look;
tables camp;
run;

/* HH level weight (weight 3) response within a HH */

proc sort data=i2.man_edits;
by camp new_hhno;
run;

data i2.non_resp;
set i2.man_edits;
by camp new_hhno;
if first.new_hhno then count=0;
count +1;
response_rate = count / howmanypeople;
weight3= 1/ response_rate;
if last.new_hhno then output; else delete;
run;

proc freq data=i2.non_resp;
tables weight3;
run;

data i2.weight3;
set i2.non_resp;
keep camp new_hhno weight3;
run;

proc sort data=i2.weight3;
by camp new_hhno ;
run;

proc sort data=i2.man_edits;
by camp new_hhno ;
run;

data i2.almost_final;
merge i2.man_edits i2.weight3;
by camp new_hhno;
run;


*;
data i2.final_data_with_weights;
set i2.almost_final;

if camp = "Bajet Kandala" then base_weight = 139;
if camp = "Esyan" then base_weight = 141;
if camp = "Bardarash" then base_weight = 143;
if camp = "Khanke" then base_weight = 144;
if camp = "Domiz Camp 1" then base_weight = 143;
if camp = "Domiz Camp 2" then base_weight = 132;
if camp = "Harshm" then base_weight = 48;
if camp = "Darashakran Camp" then base_weight = 50;
if camp = "Kawergosk  Camp" then base_weight = 49;
if camp = "Qushtapa Camp" then base_weight = 50;
if camp = "Baharka" then base_weight = 50;
if camp = "Basirma Camp" then base_weight = 49;
if camp = "Arbat IDP" then base_weight = 30;
if camp = "Arbat 2 (Ashty)" then base_weight = 30;
if camp = "Arbat Camp" then base_weight = 30;
if camp = "Ya Husein Road" then base_weight = 20;
if camp = "Alahal Camp" then base_weight = 8;
if camp = "Takiya kasnazaniya" then base_weight = 8;
if camp = "Displaced population CC" then base_weight = 8;
if camp = "Alhwaish" then base_weight = 8;
if camp = "Eshaqi" then base_weight = 8;
if camp = "Amiria carvans camp" then base_weight = 58;
if camp = "Alamiria tourist camp" then base_weight = 59;
if camp = "Numania Shoamali Street CC" then base_weight = 3;
if camp = "Collective center – population 856" then base_weight = 3;
if camp = "Collective center – population 738" then base_weight = 3;
if camp = "Collective center – population 1010" then base_weight = 3;

*non-response weights (by camp);

if camp = "Bajet Kandala" then weight2 = 1  ;
if camp = "Esyan" then weight2 =  1 ;
if camp = "Bardarash" then weight2 = 1 ; 
if camp = "Khanke" then weight2 = 1 ;
if camp = "Domiz Camp 1" then weight2 = (47/38);
if camp = "Domiz Camp 2" then weight2 = 1 ;
if camp = "Harshm" then weight2 = 1 ; 
if camp = "Darashakran Camp" then weight2 = 1;
if camp = "Kawergosk  Camp" then weight2 = (34/33);
if camp = "Qushtapa Camp" then weight2 = 1;
if camp = "Baharka" then weight2 = 1;
if camp = "Basirma Camp" then weight2 = 1;
if camp = "Arbat IDP" then weight2 = 1;
if camp = "Arbat 2 (Ashty)" then weight2 = 1;
if camp = "Arbat Camp" then weight2 = 1;
if camp = "Ya Husein Road" then weight2 = 1;
if camp = "Alahal Camp" then weight2 = (40/39);
if camp = "Takiya kasnazaniya" then weight2 = 1;
if camp = "Displaced population CC" then weight2 = 1;
if camp = "Alhwaish" then weight2 = 1;
if camp = "Eshaqi" then weight2 = 1;
if camp = "Amiria carvans camp" then weight2 = 1;
if camp = "Alamiria tourist camp" then weight2 = 1;
if camp = "Numania Shoamali Street CC" then weight2 = 1;
if camp = "Collective center – population 856" then weight2 = 1;
if camp = "Collective center – population 738" then weight2 = 1;
if camp = "Collective center – population 1010" then weight2 = 1;

/*there were some instances where the number of people entered exceeded the howmanypeople
variable. In these cases, we checked to make sure there were no duplicates. If not, we assumed
that the howmanypeople variable was incorrect, and there were additional people in those HHs*/ 
if weight3 < 1 then weight3=1;

final_weight = base_weight * weight2 * weight3;

if camp = "Bajet Kandala" then calibration_weight = 	1.548432682	;
if camp = "Esyan" then calibration_weight = 	1.967349124	;
if camp = "Bardarash" then calibration_weight = 	1.826368753	;
if camp = "Khanke" then calibration_weight = 	1.463148148	;
if camp = "Domiz Camp 1" then calibration_weight = 	2.098466549	;
if camp = "Domiz Camp 2" then calibration_weight = 	1.441998106	;
if camp = "Harshm" then calibration_weight = 	0.958333333	;
if camp = "Darashakran Camp" then calibration_weight = 	1.461911765	;
if camp = "Kawergosk  Camp" then calibration_weight = 	1.615926228	;
if camp = "Qushtapa Camp" then calibration_weight = 	1.644358974	;
if camp = "Baharka" then calibration_weight = 	1.265	;
if camp = "Basirma Camp" then calibration_weight = 	1.189553788	;
if camp = "Arbat IDP" then calibration_weight = 	1.247435897	;
if camp = "Arbat 2 (Ashty)" then calibration_weight = 	1.542168675	;
if camp = "Arbat Camp" then calibration_weight = 	1.307272727	;
if camp = "Ya Husein Road" then calibration_weight = 	1.217391304	;
if camp = "Alahal Camp" then calibration_weight = 	1.670604817	;
if camp = "Takiya kasnazaniya" then calibration_weight = 	1.549079755	;
if camp = "Displaced population CC" then calibration_weight = 	1.408473783	;
if camp = "Alhwaish" then calibration_weight = 	1.225490196	;
if camp = "Eshaqi" then calibration_weight = 	1.524390244	;
if camp = "Amiria carvans camp" then calibration_weight = 	1.187949981	;
if camp = "Alamiria tourist camp" then calibration_weight = 	1.202883886	;
if camp = "Numania Shoamali Street CC" then calibration_weight = 	1.441102757	;
if camp = "Collective center – population 856" then calibration_weight = 	1.448275862	;
if camp = "Collective center – population 738" then calibration_weight = 	1.5	;
if camp = "Collective center – population 1010" then calibration_weight = 	1.544715447	;

analysis_weight = final_weight * calibration_weight;
run;

* looking at sum of weights by camp ;

proc sql;
select camp, sum(final_weight)
from i2.final_data_with_weights
group by camp;;
run;

* looking at total sum of weights: 231,889 matches population estimate with adjusted pop for CC's ;

proc sql;
select sum(analysis_weight)
from i2.final_data_with_weights;
/*group by camp;*/
quit;

data i2.analysis_data;
set i2.final_data_with_weights;

/*Creating variable for number of doses (Table 2)*/
if receivedose = "yes" and howmanydoses = "twodoses" then dose_num = "2";
else if receivedose = "yes" and howmanydoses = "onedose" then dose_num = "1";
else if receivedose = "yes" and howmanydoses = "" then dose_num = "na";
else if receivedose = "no" then dose_num = "0";
else if receivedose = "dontremember" then dose_num = "na";
else if receivedose = "" then dose_num = "na";

/*Creating variable for Table 3*/
if firstdosecard="yes" and seconddosecard="yes" then cards =  "2 card";

else if firstdosecard="yes" and seconddosecard="yesrecall" then cards =  "1 card";
else if firstdosecard="yes" and seconddosecard="" then cards =  "1 card";
else if firstdosecard="yesrecall" and seconddosecard="yes" then cards =  "1 card";
else if firstdosecard="" and seconddosecard="yes" then cards =  "1 card";

else if firstdosecard="yesrecall" and seconddosecard="yesrecall" then cards =  "no card";
else if firstdosecard="yesrecall" and seconddosecard="" then cards =  "no card";
else if firstdosecard="" and seconddosecard="yesrecall" then cards =  "no card";

else cards="no data";

/* For these 2 HHs, only one person had listed HH information. I am manually adding that HH information to each person in the HH*/
if (camp="Displaced population CC"				and new_hhno = 22) then do;
	knowpriorcampaign="yes"; informationsources="television,neighborsfriends"; receiveotherinformation = "yes";
	whatinformation = "washhandswith,washvegetablesfruits";  mainsourcedrinking = "watertruckwater" ; 
	secondsourcedrinking = "bottledwatercompany"; kindtoilet = "pitlatrinewith"; toiletshared = "no"; 
	havesoap = "yes"; whenwashhands ="afterusingthe,beforeeating,aftereating";
	end;
if (camp="Displaced population CC"				and new_hhno = 90) then do;
	knowpriorcampaign="yes"; informationsources="neighborsfriends"; receiveotherinformation = "yes";
	whatinformation = "washvegetablesfruits,washhandswith,disposeofhuman,dontknowdont";  mainsourcedrinking = "riverstreamlake" ; 
	secondsourcedrinking = "bottledwatercompany"; kindtoilet = "pitlatrinewith"; toiletshared = "no"; 
	havesoap = "yes"; whenwashhands ="afterusingthe,beforeeating,aftereating";
	end;

/*deleting mistyped / unclear ages*/
if objectid=136 then age=.; *33?;
if objectid=677 then age=.; *65?;
if objectid=223 then age=.; *10?;
if objectid=6724 then age=.; *25?;

if familiessharedwith ge 4 then toilet_share_cat = "4 or more";
else if familiessharedwith in (1, 2, 3) or toiletshared = "no" then toilet_share_cat = "0-3";

run;

**************************************************************************************
*********************             spotting errors              ***********************
**************************************************************************************;

%macro spot (camp);
data b;
set man_edits;
where camp = "&camp";
by new_hhno;
if first.new_hhno then count=0;
count +1;
if (last.new_hhno) and (howmanypeople - count) > 0 then wrong=1;
if wrong ne 1 then delete;
run;

proc print data =b;
format x 12.10;
format y 12.10;
var age sex rowid new_hhno howmanypeople count wrong hhno x y objectid;
run;
%mend;

%spot (Qushtapa Camp);
%spot (Baharka);
%spot (Ya Husein Road);
%spot (Displaced population CC);
%spot (Eshaqi);
%spot (Numania Shoamali Street CC);
%spot (Collective center – population 856);
%spot (Collective center – population 738);
%spot (Collective center – population 1010);


