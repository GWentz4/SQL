
-- What skills are required for the top paying data analyst jobs
-- Use the top 10 highest paying Data analyst jobs from first query
-- Add the skills required


WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location IN ('Pennsylvania','Anywhere') -- Changed this for my scenario
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 100
)

SELECT 
    top_paying_jobs.*, -- This selects all values from top paying jobs table
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC

-- Top 10 Most Common Skills in High-Paying Jobs:
-- SQL (76 mentions)
-- Python (52 mentions)
-- Tableau (39 mentions)
-- R (33 mentions)
-- SAS (28 mentions)
-- Excel (24 mentions)
-- Power BI (19 mentions)
-- Snowflake (14 mentions)
-- Looker (12 mentions)
-- Go (11 mentions)
