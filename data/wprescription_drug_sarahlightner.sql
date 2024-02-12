--(1)
SELECT npi,total_claim_count
FROM prescription 
ORDER BY total_claim_count DESC;
--1912011792 --claim count(4538)
SELECT prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description,prescription.total_claim_count
FROM prescriber LEFT JOIN prescription USING(npi)
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC;
---------------------------------
--(2)
SELECT prescriber.specialty_description,prescription.total_claim_count
FROM prescriber LEFT JOIN prescription USING(npi)
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC;
--family practice
SELECT prescriber.specialty_description,prescription.total_claim_count,drug.drug_name,drug.opioid_drug_flag
FROM prescriber LEFT JOIN prescription USING(npi)
                INNER JOIN drug USING (drug_name)
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC;
--family practice
(SELECT specialty_description
FROM prescriber
GROUP BY specialty_description)
EXCEPT
(SELECT prescriber.specialty_description
FROM prescriber INNER JOIN prescription USING (npi));
--15 rows
-- FINISH DIFF BONUS
--------------------------------
--(3)
SELECT drug.generic_name,prescription.total_drug_cost
FROM drug INNER JOIN prescription USING (drug_name)
ORDER BY total_drug_cost DESC;
--PIRFENIDONE
SELECT drug_name,MAX(total_drug_cost)AS max_cost, MIN(total_day_supply)AS min_supply
FROM prescription
GROUP BY drug_name
ORDER BY min_supply ASC;
--PREPOIK
--------------------------------
--(4)
SELECT drug_name, CASE WHEN opioid_drug_flag = 'Y'
                       THEN 'opioid' 
					   WHEN antibiotic_drug_flag = 'Y'
					   THEN 'antibiotic' 
					   ELSE 'neither'
					   END AS drug_type
FROM drug;
SELECT SUM(prescription.total_drug_cost::money),CASE WHEN opioid_drug_flag = 'Y'
                       THEN 'opioid' 
					   WHEN antibiotic_drug_flag = 'Y'
					   THEN 'antibiotic' 
					   ELSE 'neither'
					   END AS drug_type
FROM drug INNER JOIN prescription USING (drug_name)
GROUP BY drug_type
ORDER BY drug_type;
--opioids
---------------------------
--(5)
SELECT COUNT(cbsa.cbsa), cbsa.cbsaname, fips_county.state
FROM cbsa INNER JOIN fips_county USING (fipscounty)
WHERE state = 'TN'
GROUP BY cbsa.cbsaname, fips_county.state;
--42

SELECT cbsa.cbsaname, SUM(population.population)
FROM cbsa INNER JOIN population USING (fipscounty)
GROUP BY cbsa.cbsaname,population.population
ORDER BY population.population DESC;
--Memphis, TN-MS-AR
(SELECT fips_county.county, SUM(population.population) AS sum_pop
FROM population INNER JOIN fips_county USING(fipscounty)
GROUP BY fipscounty, fips_county.county
ORDER BY sum_pop DESC ) 
EXCEPT
(SELECT fips_county.county, SUM(population.population)AS sum_pop
FROM population INNER JOIN fips_county USING(fipscounty)
 INNER JOIN cbsa USING(fipscounty)
GROUP BY fipscounty, fips_county.county
ORDER BY sum_pop DESC) 
--SEVIER

---------------------------
--(6)
SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count>=3000;

SELECT drug_name, total_claim_count, CASE WHEN opioid_drug_flag ='Y'
                                         THEN 'opioid'
										 WHEN opioid_drug_flag ='N'
										 THEN 'not'
										 END AS opioid_or_not
FROM prescription INNER JOIN drug USING(drug_name)
WHERE total_claim_count>=3000;

SELECT prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,drug_name, total_claim_count, CASE WHEN opioid_drug_flag ='Y'
                                         THEN 'opioid'
										 WHEN opioid_drug_flag ='N'
										 THEN 'not'
										 END AS opioid_or_not
FROM prescriber INNER JOIN prescription USING (npi) INNER JOIN drug USING(drug_name)
WHERE total_claim_count>=3000;
------------------------------
--(7)
SELECT prescriber.npi, drug.drug_name 
FROM  prescriber 
CROSS JOIN drug 
WHERE prescriber.specialty_description = 'Pain Management'
AND prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'

SELECT prescriber.npi,drug.drug_name, COALESCE(prescription.total_claim_count,0)AS total_claim_count
FROM  prescriber 
INNER JOIN prescription ON  prescriber.npi=prescription.npi INNER JOIN drug ON prescription.drug_name = drug.drug_name
WHERE prescriber.specialty_description = 'Pain Management'
AND prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.npi,drug.drug_name, prescription.total_claim_count

--finish




                 






