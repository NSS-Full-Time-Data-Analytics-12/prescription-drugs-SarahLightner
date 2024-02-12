SELECT countries.country
,SUBSTRING(country_stats.year,1,4)AS calendar_year
, country_stats.nobel_prize_winners
,CASE WHEN country_stats.pop_in_millions < '50'
      THEN 'large'
	  WHEN country_stats.pop_in_millions < '100'
	  THEN 'medium'
	  WHEN country_stats.pop_in_millions > '100'
	  THEN 'small'END AS country_size
FROM countries INNER JOIN country_stats ON countries.id = country_stats.country_id
WHERE country_stats.nobel_prize_winners >= 1
GROUP BY countries.country,country_stats.pop_in_millions,country_stats.year,country_stats.nobel_prize_winners
ORDER BY country_stats.nobel_prize_winners DESC;

SELECT countries.country, SUBSTRING(country_stats.year,1,4)AS calendar_year,COALESCE(country_stats.gdp::text, 'unknown')AS gdp_amount
FROM countries INNER JOIN country_stats ON countries.id = country_stats.country_id


