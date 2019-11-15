# How The Washington Post Analyzed HUBZone Contacts in Washington, DC. 

## The codes used for this project were all written in R. 

Tools used 

- R 
- QGIS 
- Geocoding.geo.census.gov

To examine the distribution of contracts, the Post examined three variables, which include location, poverty rates and income factors. The locations of firms and contracts awarded were obtained from https://www.fpds.gov/fpdsng_cms/index.php/en/. 

The parameters used to pull the data obtained from the FPDS' data dictionary and EzSearch FAQ. 

There are four types of HUBZone designations. They are: qualified census tract; qualified nonmetropolitan county; qualified Indian reservation; and, qualified base closure area. The analysis accounts for each of the unique designations through FY 2000 through 2019.

HUBZone firm recipients were geocoded using the U.S. Census geocoder.

Results of the geocoding: 

### Location of HUBZone firms across the US

<img border="0" height="324" src="https://2.bp.blogspot.com/-nIbOr7W40qg/XcsIZ6VFysI/AAAAAAAAJRY/nOZ8VPbYHQQVmlotul_pJW01ffVMt35CACK4BGAYYCw/s640/Screen%2BShot%2B2019-11-12%2Bat%2B2.30.38%2BPM.png" width="640" />

HUBZone was designed to offer firms a path to securing federal contracts based on geography — not veteran, gender or race
based qualifications used by some other programs. 

But the program appears to have inadvertently fostered a new divide. A Washington Post analysis iin April 2019 of 20 years of HUBZone data shows that about $800 million earmarked for firms enrolled in the program was awarded to just 11 D.C. businesses.

<img alt="HUBZone Top Firms" src="http://3.bp.blogspot.com/-ShvrEeJ5bp8/XcwN4o1-2sI/AAAAAAAAJR4/eQLNp-ELU-saUfluw_1u7or1JpxZEyLEwCK4BGAYYCw/s640/FIMAE6BPZYI6TB4BOY3BT4JMWQ.jpeg" width="auto" />

What had been unclear was how neighborhoods with higher levels of wealth and private investment fell into the program, while more economically distressed communities received only a sliver of the benefits. The Post re-engineered the HUBZone algorithm to find out when tracts and DDA fell into the program and when they exited. 

An tract that exited the program indicated an economic improvement within that area. 

A new Washington Post analysis since April found the HUBZone program’s use of outdated and unadjusted data allowed businesses in wealthy areas to qualify for more than $550 million in federal contracts meant for firms in underserved neighborhoods. 

Rather than improve inequalities, critics say the program has exacerbated disparities and question whether its calculations fit the program’s mission.

Much like the District, The Post’s analysis shows outdated data has steered billions from firms in neighborhoods across the country that the program is intended to benefit. 

From FY 2016 to FY 2019, HUBZone contracts sent about $2 billion, or more than 40 percent of HUBZone awards during that time, to areas that have not qualified for the program since 2013 — the result of multiyear contracts signed when those areas qualified, the analysis found.
