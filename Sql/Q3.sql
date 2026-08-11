Q3: Overtime, Work-Life Balance and Attrition
Business Question: How does work-life balance relate to attrition across overtime groups?

SELECT OverTime AS "Overtime",
       CASE
           WHEN WorkLifeBalance = 1 THEN 'Poor'
           WHEN WorkLifeBalance = 2 THEN 'Fair'
           WHEN WorkLifeBalance = 3 THEN 'Good'
           ELSE 'Excellent'
       END AS "Work-Life Balance",
       COUNT(*) AS "Total Employees",
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "Employees Left",
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) || '%' AS "Attrition Rate"
FROM HR_ANALYTICS
GROUP BY OverTime, WorkLifeBalance
ORDER BY OverTime, WorkLifeBalance;
