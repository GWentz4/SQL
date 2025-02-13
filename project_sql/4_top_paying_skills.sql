-- What are the top skills based on salary?
-- Look at the average salary associated with each skill for Data Analyst positions
-- Focuses on roles with specified salaries, regardless of location
-- This helps to identify the most financially rewarding skills to acquire or improve upon 

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

-- Results
-- Key Takeaways:
-- ✅ Big Data Engineering is extremely lucrative. PySpark, Databricks, and PostgreSQL indicate strong demand for professionals skilled in distributed computing and data pipelines.
-- ✅ AI & Machine Learning remain top-paying fields. ML tools (DataRobot, Watson) and Python libraries (Pandas, NumPy, Scikit-learn) show companies investing heavily in AI-driven solutions.
-- ✅ DevOps & Cloud skills are essential. Kubernetes, Airflow, and Jenkins indicate demand for automation, cloud deployment, and CI/CD pipelines.
-- ✅ Backend programming languages like Golang, Scala, and Swift continue to be lucrative.