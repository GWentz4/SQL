-- What are the most in demand skills for data analyts?
-- Join job postings to inner join table similar to previous query
-- Identify the top 5 in demand skills for a data analyst
-- Focus on all job postings, we want to examine the whole job market instead of a niche based on location or salary

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist' AND 
    job_location IN ('Anywhere','Pennsylvania','Maryland')
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5

-- Top 5 results for Data Analyst:
-- SQL
-- Excel
-- Python
-- Tableau
-- Power BI 

-- What about Data Scientists?
-- Top 5 results:
-- Python
-- SQL
-- R
-- AWS
-- Tableau