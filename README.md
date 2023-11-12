# COVID MONITORING
 
## OBJECTIVE 
Our objective consists in creating synthetic views on Covid in EU countries with 3 main indicators “cases”, “hospital occupancy” and “deaths” and deepen the analysis with 2 behavioral indicators: covid vaccination and travelling (flying passengers).

## STEPS
### OPERATIONAL LAYER: 
From EUROSTAT and ECDC, we import 4 datasets, one of which, Vaccination, is extremely heavy (49Mo). To get to a lighter dataset, we manually created a synthetic vaccination dataset with number of first and second doses on a weekly bases (originally daily data split by age group).


### ANALYTICAL LAYER: 
Our Analytical Layer features 5 datasets:
 - 4 covid datasets with weekly data for 30 countries (EU + Norway, Iceland and Liechtenstein).
 - 1 dataset with montly flying passenger data for 34 countries (EU + Norway, Iceland, Bosnia, Macedonia, Montenegro, Serbia, Switzerland, UK).

## DATA SOURCES
### From EUROSTAT:
 - Air passenger transport by main airports in each reporting country:                        
https://ec.europa.eu/eurostat/databrowser/bookmark/15424aa3-01d4-4b6f-98f2-c3c213a85a3b?lang=en 
 - Explanatory text
https://ec.europa.eu/eurostat/cache/metadata/en/avia_pa_esms.htm

### From ECDC (European Centre for Disease Prevention and Control)

New Covid cases and deaths (“cases”):
https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv/data.csv 
 - Data dictionary on New Covid Cases
https://www.ecdc.europa.eu/sites/default/files/documents/2022-06-23_Variable_Dictionary_and_Disclaimer_national_weekly_data.pdf 

Hospital Covid admission data (“occup”):
https://opendata.ecdc.europa.eu/covid19/hospitalicuadmissionrates/csv/data.csv 
 - Data dictionary on Hospital admission:
https://www.ecdc.europa.eu/sites/default/files/documents/2021-01-13_Variable_Dictionary_and_Disclaimer_hosp_icu_all_data.pdf 

Covid 19 Vaccination (broken down in “vaccin_yy”, yy for each year 20 to 23):
https://opendata.ecdc.europa.eu/covid19/vaccine_tracker/csv/data.csv 
 - Data dictionary on Covid Vaccination:
https://www.ecdc.europa.eu/sites/default/files/documents/Variable_Dictionary_VaccineTracker-5-april-2023.pdf

## DATASET VIEW

Attached is a synthetic mapping of all datasets, their use and their field structure.
[Datasets.docx](https://github.com/amer1606/Data_Engineering_Alain_Merceron/files/13328402/Datasets.docx)


