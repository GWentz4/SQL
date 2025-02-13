# Top Paying and Most Demanded Skills Analysis

## Introduction

📊 This project analyzes the top-paying jobs and the most in-demand skills in the job market. Using SQL queries, I extracted insights on which skills are associated with high salaries 💰 and strong job demand 📈. The goal is to provide data-driven recommendations for individuals looking to upskill and align their expertise with lucrative opportunities.

🔍 SQL Queries? Check them out here: [project_sql folder](/project_sql/)

## Background

With the rapid evolution of technology and industry needs, certain skills have become more valuable than others. This project leverages job posting data to identify these trends by examining salary distributions and demand for specific skills. The analysis helps determine which skills are both high-paying and in demand, offering a strategic approach for career planning.

## Tools I Used
- **SQL**: For data extraction, transformation, and aggregation. The backbone of all of the analysis performed

- **PostgreSQL**: The chosen database management system which was key for handling the job posting dating.

- **GitHub and Git**: Essential for version control and sharing all my SQL scripts and analysis, ensuring collaboration and project tracking.

## The Analysis

The analysis involved multiple SQL queries that addressed key questions:

### 1. Top Paying Data Analyst Jobs 
To identify the highest paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs or jobs located in Pennsylvania. This query high paying opportunities in the field.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location IN ('Pennsylvania','Anywhere')
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 100
```
### 2. Top Paying Skills 
This SQL query identifies the top 100 highest-paying Data Analyst jobs in Pennsylvania or remote, along with their required skills. It defines a CTE (top_paying_jobs) to select job ID, title, salary, and company name from job_postings_fact and company_dim, filtering for non-null salaries and Data Analyst roles in the specified locations. The results are ordered by salary in descending order. The main query then joins with skills_job_dim and skills_dim to retrieve the skills for each job while maintaining the salary ranking. This helps identify skills associated with higher-paying Data Analyst positions.
```sql
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
        job_location IN ('Pennsylvania','Anywhere')
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT 100
)

SELECT 
    top_paying_jobs.*, 
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Results:
```sql
-- Top 10 Most Common Skills in High-Paying Jobs for Data Analysts
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
```
### 3. Most Demanded Skills 
This SQL query analyzes the demand for skills in Data Scientist job postings located in Pennsylvania, Maryland, or remote. It joins the job_postings_fact, skills_job_dim, and skills_dim tables to link job listings with their required skills. The query filters for job titles labeled "Data Scientist" and includes positions in the specified locations. It then groups the results by skill and counts how many job postings require each skill. Finally, the query orders the skills by demand (in descending order) and limits the results to the top 5 most in-demand skills. A query was also performed for Data Analysts
```sql
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
```
**Results**:
```sql
-- Top 5 results for Data Analyst:
-- SQL
-- Excel
-- Python
-- Tableau
-- Power BI 

-- Top 5 results for Data Scientist
-- Python
-- SQL
-- R
-- AWS
-- Tableau
```
### 4. Top-Paying Skills
This SQL query calculates the average salary for each skill required in Data Analyst job postings located in Pennsylvania, Maryland, or remote. It joins the job_postings_fact, skills_job_dim, and skills_dim tables to link job listings with their required skills and filter for roles with non-null salaries. The query focuses on Data Analyst positions and groups the results by skill. It then calculates the average salary for each skill, rounding the value to the nearest whole number. Finally, the query orders the skills by average salary in descending order and limits the results to the top 25 highest-paying skills.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'  
    AND salary_year_avg IS NOT NULL AND
    job_location IN ('Anywhere','Pennsylvania','Maryland')
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```
**Results**:
```sql
-- Key Takeaways:
-- ✅ Big Data Engineering is extremely lucrative. PySpark, Databricks, and PostgreSQL indicate strong demand for professionals skilled in distributed computing and data pipelines.
-- ✅ AI & Machine Learning remain top-paying fields. ML tools (DataRobot, Watson) and Python libraries (Pandas, NumPy, Scikit-learn) show companies investing heavily in AI-driven solutions.
-- ✅ DevOps & Cloud skills are essential. Kubernetes, Airflow, and Jenkins indicate demand for automation, cloud deployment, and CI/CD pipelines.
-- ✅ Backend programming languages like Golang, Scala, and Swift continue to be lucrative.
```
### 5. Optimal Skills
This SQL query combines two Common Table Expressions (CTEs) to identify the most optimal skills for Data Analyst roles located in Pennsylvania, Maryland, or remote. The first CTE (skills_demand) counts the number of job postings for each skill, filtering for roles with non-null salaries. The second CTE (average_salary) calculates the average salary for each skill, rounding it to the nearest whole number. The main query joins the two CTEs, retrieving the skill ID, skill name, demand count, and average salary for skills with more than 10 job postings. The results are ordered by average salary in descending order, followed by demand count, and limited to the top 25 most optimal skills.
```sql
WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        job_location IN ('Anywhere','Pennsylvania','Maryland')
    GROUP BY
        skills_dim.skill_id
    ), average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'  
        AND salary_year_avg IS NOT NULL AND
        job_location IN ('Anywhere','Pennsylvania','Maryland')
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY
    avg_salary DESC, 
    demand_count DESC
    LIMIT 25;
```
The results for optimal skills included higher demand programs such Python, R, and Tableau. Other more specialized and lower demand skills included softwares such as databricks, hadoop, and aws.

Each query was structured to filter relevant jobs, calculate salary averages, and count skill occurrences, allowing for meaningful insights into career trends.

## What I Learned

SQL Joins, Aggregations, and basic functions: Mastered the use of joins, GROUP and ORDER BY's,  and WHERE's to extract insights from multiple tables.

Salary Trends: Observed a correlation between certain tech skills (e.g., Python, Cloud Computing, Data Science tools) and high salaries.

Skill Demand vs. Pay: Some high-paying skills are not necessarily in demand, while others are valuable due to widespread industry adoption.

## Conclusions and Insights

Skills like SQL, Python, Cloud Computing, and Data Engineering tools consistently appear in high-paying and in-demand job postings.

The highest-paying skills are often linked to niche technologies like Couchbase, PySpark, and DataRobot.

For career growth, a balance between high-paying and high-demand skills is ideal—focusing on widely adopted technologies while also gaining expertise in emerging high-paying tools.

By leveraging SQL and job market data, this project provides a strategic guide for professionals aiming to enhance their skill sets and improve their career prospects.

## Closing Thoughts and Further Learning
My first SQL project was incredibly rewarding, as it gave me the opportunity to learn a great deal about data manipulation techniques and SQL in general. It was a hands-on experience that deepened my understanding of querying, filtering, and joining data, while also improving my ability to work with real-world datasets.

### Further Study
1. Further study and practical application with Sub-queries and CTE's 

2. More practice loading and creating databases within SQL 