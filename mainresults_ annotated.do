***Table 1

*For the following analysis, use the racial_polarization_winners.dta dataset*

use "racial_polarization_winners.dta", clear


**Column 1

* perform a multi-level mixed-effects linear regression of biggest split on 
* the multi-group H index with controls for Herfindahl Diversity Index, % Asian
* interpolated, % Black interpolated, % Latino interpolated, median household
* income interpolated, % renters interpolated, percent college grads interpolated,
* a dummy indicating if there were biracial candidates in the election, a dummy 
* indicating if the election was nonpartisan, an indicator if the election was
* a primary, and the log population. The regression also includes fixed effects
* for year and region and random effects for cities (geo_id2). Diversity is 
* included because of the claim that more diverse populations will have more 
* heterogeneous political preferences. The other fixed effect control variables
* are included because they are known to be potentially correlated with 
* segregation. winner == 1 requires that there was a winner in the election.*

xtmixed biggestsplit H_citytract_multi_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:


***predicted effects following Table 1

* estimate predictive margins at the mean of all covariates except for
* H_citytract_multi_i, which will be equal to .23 in the first specification
* and .54 in the second. Doing this to allows us to see the predicted effect on
* the biggest split if all the covariates were at their mean and H_citytract_multi_i
* were at .23 or .54. *

margins, at((mean) _all H_citytract_multi_i=(.23 .54))



***Column 2

* Perform the same regression as for Column 1 above but this time regress on the
* two-group calculation of Theil's H interpolated. It is unclear where the "diversity"
* variable is coming from, as the only variable related to diversity in the specificed
* dataset is diversityinterp. This is a problem that will need to be resolved. 
* Essentially, this regression just tests an alternate specification to the first in
* which the segregation index in defined in terms of two-groups rather than multiple.*

xtmixed biggestsplit H_citytract_NHW_i diversity pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:


***Column 3

* perform the same regression as for column 2, but now add in a measure of average
* white political ideology. The point of this is to control for ideology so that the
* author can separate any effects of segregation from any potential effects of white political ideology. This is important because it is possible that segregation is 
* just a proxy for white conservatism and thus failure to include this variable could
* lead to ommitted variable bias. *

xtmixed biggestsplit H_citytract_NHW_i diversity pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop whiteideology_fill2 i. year south midwest west if winner==1||geo_id2:


***Table 2

* switch to the fin_seg data set *

use "fin_seg.dta", clear

***Column 1

* The following is a fixed effects model regression with clustering around geo_id2.
* It mandates that total census tracts in the city is greater than 1, which we want
* because our measure of evenness of racial spread is constant for cities with only
* one tract by our definition (which requires comparing tracts within cities). It
* also mandates that Direct General Expenditures (DGE) per capita, CPI adjusted is
* not equal to 0, which would be problematic and indicate a potential data error. 
* This regression regresses the DGE per capita on the the two-group calculation of 
* Theil's H interpolated. Controls are included for diversity and the % populations
* of Blacks, Asians, and Latinos to help identify whether it is actually diversity
* that drives down spending.These demographic controls also help to account for the
* fact that whites and minorities tend to perfer different levels of government
* spending in general. This will help isolate the effects of segregation v. other
* forms of diversity on public spending. Other controls for Median household income,
* CPI adjusted, percent over 65, percent college grads, percent local government 
* workers, log population help control for additional factors related to segregation
* and expenditure. Controls for percent renters interpolated and Median household 
* income also help to control for the general wealth of cities, which could be a 
* potential driver of public spending. Fixed effects for cities are also included 
* so that the author can examine the effect of segregation in the same city over 
* time, which also helps control for many other factors not otherwise taken into 
* account (such as city age) *

xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & dgepercap_cpi~=0,fe vce(cluster geo_id2)


***predicted effects following Table 2

* estimate predictive margins at the mean of all covariates except for 
* H_citytract_NHW_i, which will be equal to .01 in the first specification and .1
* in the second. Doing this to allows us to see the predicted effect on the DGE per
* capita if all the covariates were at their mean and H_citytract_multi_i were at 
* .01 or .10.*

margins, at((mean) _all H_citytract_NHW_i=(.01 .10))


***Column 2

* This regression is the same as above except instead of using diversity, a new 
* control is added for the five year changes in racial group shares. The goal here
* is to see whether or not changes in diversity are a driving factor (rather than 
* absolute levels of diversity). *

xtreg dgepercap_cpi H_citytract_NHW_i pctblkpopinterp pctasianpopinterp pctlatinopopinterp chng5pctblk chng5pctlatino chng5pctasian  medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)



***Column 3

* As in column 3 of table 1, this regression simply adds in a control for  mean 
* ideology of city residents from General Social Survey (GSS) to control for the 
* possibolity that ideology that segregated cities are more ideologically 
* conservative and that the conservative nature of segregated cities is what 
* actually drives the effect. *

xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop ideology_fill if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)


***Table 3

* use the fin_seg dataset *

use "fin_seg.dta", clear


***Column 1

* The following is a fixed effects model regression with clustering once again
* around geo_id2. Again, the if statements at the end mandate that total census
* tracts in the city is greater than 1, which we want because our measure of 
* evenness of racial spread is constant for cities with only one tract by our 
* definition (which requires comparing tracts within cities). They also mandate
* that the highways per capita, CPI adjsuted with no cap extend (lagged 5 years)
* is not equal to 0, which would be problematic and indicate a potential data error.
* The dependent variable here is highways per capita, CPI adjsuted with no cap extend
* (lagged 5 years) and it is regressed on the two group calculation of Theil's H, 
* interpolated. Controls are added for diversity, percent population of Blacks, 
* Asians, and Latinos, and median household CPI adjusted income as well as for % 
* local government worker hundreds, percent rentership, percent over 65, percent 
* college graduates, and the log of the population. This essentially examines the 
* effect of segregation on the specific public good of highways. As in the previous
* table's regressions, fixed effects for cities are also included so that the author
* can examine the effect of segregation in the same city over time, which also helps
* control for many other factors not otherwise taken into account (such as city age) *

xtreg highwayspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)



***Column 2

* This is the same regression as column 1, but this time the dependent variable
* is police per capita, CPI adjusted with no cap extend. This essentially examines
* the effect of segregation on the specific public good of police per capita.*

xtreg policepercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)


***Column 3

* This is again the same regression, but this time the dependent variable is 
* parks per capita, CPI adjusted with no cap extend. This essentially examines
* the effect of segregation on the specific public good of parks.*

xtreg parkspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)


***Column 4

* This is again the same regression, but this time the dependent variable is 
* sewers per capita, CPI adjusted with no cap extend. This essentially examines
* the effect of segregation on the specific public good of sewers.*

xtreg sewerspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)


***Column 5

* This is again the same regression, but this time the dependent variable is Welfare,
* Health, Housing per capita, CPI adjusted, no cap expend. This essentially examines
* the effect of segregation on the specific public good of welfare and housing.*

xtreg welfhoushealthNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)


***Column 6

* This is again the same regression, but this time the dependent variable is own
* source of general revenue per capita, CPI adjusted. This essentially examines the
* effect of segregation on the specific public good of own source revenue.*

xtreg genrevownpercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)


***Figure 1

* This is the code to generate the highways plot of figure one using the fixed
* effects regression of highwayspercapNC_cpi on H_citytract_NHW_i. quietly tells
* Stata not to show the execution of the subseuqent commands. The margins command
* estimates the predictive margins at the mean of all covariates for H_citytract_NHW_i
* ranging from 0 to .5 incremented by .01. marginsplot generates of plot of the 
* calculated margins. xlabel creates axis ticks and labels 0 to .5 incremented by .01,
* and the xtitle, ytitle, and title label the plot according to the margin() and size()
* specified within the funcction. plotopts() sets the general color. recast(line) makes
* the plot a line plot and ciopts(color()) sets the color of the line to 
* gray.recastci(rarea) plots the confidence intervals as an area around the line. 
* graphregion sets the margin to medium-large, and the color of the graph region to 
* white. legendoff turns the legend off, and plotregion sets the color of the plot 
* region to white.*


xtreg highwayspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Roads Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

* This generates the same graph for policepercapNC_cpi

xtreg policepercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Police Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

* This generates the same graph for parkspercapNC_cpi

xtreg parkspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Parks Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

* This generates the same graph for sewerspercapNC_cpi

xtreg sewerspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Sewers Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

* This generates the same graph for welfhoushealthNC_cpi 

xtreg welfhoushealthNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .3))
marginsplot, xlabel(0(.1).3) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Welfare Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white)) 

* This generates the same graph for genrevownpercap_cpi 

xtreg genrevownpercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Own Source Revenue Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))


***Table 4

*  The following is a fixed effects model regression with clustering once
* again around geo_id2. Again, the if statements at the end mandate that total
* census tracts in the city is greater than 1, which we want because our measure
* of evenness of racial spread is constant for cities with only one tract by our
* definition (which requires comparing tracts within cities).They also mandate 
* that the DGE per capita, CPI adjsuted  extend (lagged 5 years) is not equal to
* 0, which would be problematic and indicate a potential data error. The dependent
* variable here is DGE per capita, CPI adjusted, and it is regressed on the two
* group calculation of Theil's H, interpolated. Controls are added for diversity,
* percent population of Blacks, Asians, and Latinos, and median household CPI 
* adjusted income as well as for % local government worker hundreds, percent 
* rentership, percent over 65, percent college graduates, and the log of the 
* population. As in the previous table's regressions, fixed effects for cities
* are also included so that the author can examine the effect of segregation 
* in the same city over time, which also helps control for many other factors not
* otherwise taken into account (such as city age). This regression essentially 
* examines the effect of segregation on DGE per capita.*

xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)


***Columns 2 & 3

* generates a table of mean percentnonwhit and mean H_citytract_NHW_i by percent
* non while quintiles. *

table pctnonwht_xtile, c(mean pctnonwht mean H_citytract_NHW_i)


***Determine min/max values for each quintile in a table of summary statistics

table pctnonwht_xtile, c(min H_citytract_NHW_i max H_citytract_NHW_i )


***Calculate marginal effect of changing from minimum to maximum level of 
* segregation for each quintile: calculates the margins over the quintiles 
* of percent non-white at the means of all the covariates and the min and max
* values of H_citytract_NHW_i at each quintile. I am not sure exactly what the
* contrast(atcontrast(r._at)wald) term is doing, and so I will try to find some 
* help on understanding this. It seems to be essentially applying the wald 
* contrast operator to the groups defined by the mean of all the covariates
* at the min and maxes of all the quintiles of H_citytract_NHW_i.*

***Columns 4 & 5


margins, over(pctnonwht_xtile) at((mean) _all H_citytract_NHW_i=(0 .38726727 .68708962 .76654474 .73449214 .66859493)) contrast(atcontrast(r._at) wald)


***Table 5

***Install IVREG2 package if not already installed

 ssc install ivreg2
 ssc install ranktest 
 
 
***Top Row

***Column 1

* This is an instrumental variable regression with DGE per capita, adjusted by
* the CPI, as the dependent variable and total number of waterways as the 
* instrumental variable for segregation. The instrument includes the log of the
* population in the first stage because the number of waterways is positively 
* correlated to population and population is positively correlated with 
* segregation. The control variables are the same as those in the regressions
* for Table 2 except for 2 changes: since the number of waterways does not change,
* there is no need for city fixed effects. Instead, we include fixed effects for
* the region and year. A lagged version of the dependent variable (dgepercap_cpilag)
* is added to the regressions to account for the high correlation between 
* observations for the same city over time and because changes in local budgets
* typically are incremental (NOTE: why exactly do we do this/why does it help/why
* not do it in the non-intstrumental regressions?). 

ivreg2 dgepercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) dgepercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if dgepercap_cpi~=0


***Column 2

* this is the same regression as for column 1 but now we use the dependent
* variable highwayspercapNC_cpi to assess the effect of the instrumental 
* variable on highways per capita *

ivreg2 highwayspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) highwayspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  highwayspercapNC_cpi~=0


***Column 3

* this is the same regression as for column 1 but now we use the dependent
* variable policepercapNC_cpi to assess the effect of the instrumental 
* variable on police per capita *

ivreg2 policepercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) policepercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  policepercapNC_cpi ~=0 


***Column 4

* this is the same regression as for column 1 but now we use the dependent
* variable parkspercapNC_cpi to assess the effect of the instrumental variable
* on parks per capita *

ivreg2 parkspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) parkspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  parkspercapNC_cpi ~=0 


***Bottom Row

***Column 1

* this is the same regression as for column 1 but now we use the dependent
* variable sewerspercapNC_cpi to assess the effect of the instrumental variable
* on sewers per capita *

ivreg2 sewerspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) sewerspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if sewerspercapNC_cpi ~=0 


***Column 2

* this is the same regression as for column 1 but now we use the dependent
* variable welfhoushealthNC_cpi to assess the effect of the instrumental 
* variable on welfare per capita *

ivreg2 welfhoushealthNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) welfhoushealthNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if welfhoushealthNC_cpi ~=0 


***Column 3

* this is the same regression as for column 1 but now we use the dependent
* variable genrevownpercap_cpi to assess the effect of the instrumental 
* variable on own source revenue per capita *

ivreg2 genrevownpercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) genrevownpercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if genrevownpercap_cpi ~=0 















***Appendix

**Appendix Table A1 & A2

use "racial_polarization_winners.dta", clear
xtmixed biggestsplit H_citytract_multi_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:


***Table A1

sum biggestsplit H_citytract_multi_i H_citytract_NHW diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop whiteideology_fill  if e(sample)


***Table A2

table cityname biggestsplit_gr if e(sample)
table cityname if e(sample), c(mean H_citytract_multi_i mean H_citytract_NHW_i)


***Appendix Table A3

use "fin_seg.dta", clear
xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)

sum  dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp chng5pctblk chng5pctlatino chng5pctasian medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop ideology_fill population if e(sample)
sum  highwayspercapNC_cpi  if e(sample) & highwayspercapNC_cpi~=0
sum  policepercapNC_cpi if e(sample) & policepercapNC_cpi~=0
sum parkspercapNC_cpi  if e(sample) & parkspercapNC_cpi ~=0
sum sewerspercapNC_cpi if e(sample) & sewerspercapNC_cpi ~=0
sum  welfhoushealthNC_cpi if e(sample) &  welfhoushealthNC_cpi ~=0
sum  genrevownpercap_cpi if e(sample) &  genrevownpercap_cpi  ~=0


***Appendix Table A4

***Column 1

ivreg2 dgepercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) dgepercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if dgepercap_cpi~=0, first


***Column 2

ivreg2 highwayspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) highwayspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  highwayspercapNC_cpi~=0, first


***Column 3

ivreg2 policepercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) policepercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  policepercapNC_cpi ~=0, first


***Column 4

ivreg2 parkspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) parkspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  parkspercapNC_cpi ~=0, first 


***Bottom Row

***Column 1

ivreg2 sewerspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) sewerspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if sewerspercapNC_cpi ~=0, first 


***Column 2

ivreg2 welfhoushealthNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) welfhoushealthNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if welfhoushealthNC_cpi ~=0, first 


***Column 3

ivreg2 genrevownpercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) genrevownpercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if genrevownpercap_cpi ~=0, first 

