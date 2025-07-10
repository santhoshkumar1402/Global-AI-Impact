select *
from global_ai_impact;

ALTER TABLE global_ai_impact
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;


-- removing duplicate rows
DELETE FROM global_ai_impact
WHERE id NOT IN (
    SELECT * FROM (
        SELECT MIN(id)
        FROM global_ai_impact
        GROUP BY Country, Year, Industry
    ) AS temp
);

-- standardization
UPDATE global_ai_impact
SET 
    Country = TRIM(UPPER(Country)),
    Industry = TRIM(UPPER(Industry));
    
-- fixing outliers
DELETE FROM global_ai_impact
WHERE 
  `AI Adoption Rate (%)` > 100 OR `AI Adoption Rate (%)` < 0
  OR `Job Loss Due to AI (%)` > 100 OR `Job Loss Due to AI (%)` < 0
  OR `Revenue Increase Due to AI (%)` > 100 OR `Revenue Increase Due to AI (%)` < 0;

-- check for nulls
SELECT 
    SUM(CASE WHEN `AI_Adoption_Rate (%)` IS NULL THEN 1 ELSE 0 END) AS missing_adoption_rate,
    SUM(CASE WHEN `Job_Loss_Due_to_AI (%)` IS NULL THEN 1 ELSE 0 END) AS missing_job_loss,
    SUM(CASE WHEN `Revenue_Increase_Due_to_AI (%)` IS NULL THEN 1 ELSE 0 END) AS missing_revenue_increase
FROM global_ai_impact;

-- BACKUP
CREATE TABLE global_ai_impact_backup AS
SELECT * FROM global_ai_impact;

-- removing null rows
DELETE FROM global_ai_impact
WHERE 
    `Country` IS NULL
    OR `Year` IS NULL
    OR `Industry` IS NULL
    OR `AI Adoption Rate (%)` IS NULL
    OR `Revenue Increase Due to AI (%)` IS NULL;
    
--     








