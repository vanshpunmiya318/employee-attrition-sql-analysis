Q4: Pay Position Within Job Role and Attrition
Business Question: How does attrition differ between the lowest-paid and highest-paid employees within each job role?


WITH ranked AS (
    SELECT JobRole,
           MonthlyIncome,
           Attrition,
           NTILE(4) OVER (PARTITION BY JobRole ORDER BY MonthlyIncome) AS pay_quartile
    FROM HR_ANALYTICS
),
quartile_summary AS (
    SELECT JobRole,
           pay_quartile,
           COUNT(*) AS total_employees,
           ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS attrition_rate
    FROM ranked
    GROUP BY JobRole, pay_quartile
)
SELECT JobRole AS "Job Role",
       MAX(CASE WHEN pay_quartile = 1 THEN total_employees END) AS "Lowest Paid Employees",
       MAX(CASE WHEN pay_quartile = 1 THEN attrition_rate END) AS "Lowest Paid Attrition (%)",
       MAX(CASE WHEN pay_quartile = 4 THEN total_employees END) AS "Highest Paid Employees",
       MAX(CASE WHEN pay_quartile = 4 THEN attrition_rate END) AS "Highest Paid Attrition (%)",
       ROUND(
           MAX(CASE WHEN pay_quartile = 1 THEN attrition_rate END) -
           MAX(CASE WHEN pay_quartile = 4 THEN attrition_rate END),
           2
       ) AS "Attrition Difference (Percentage Points)"
FROM quartile_summary
GROUP BY JobRole
HAVING MAX(CASE WHEN pay_quartile = 1 THEN total_employees END) >= 30
   AND MAX(CASE WHEN pay_quartile = 4 THEN total_employees END) >= 30
ORDER BY ABS(MAX(CASE WHEN pay_quartile = 1 THEN attrition_rate END) -
             MAX(CASE WHEN pay_quartile = 4 THEN attrition_rate END)) DESC;
