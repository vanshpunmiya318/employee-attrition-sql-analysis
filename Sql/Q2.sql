Q2: Overtime and Attrition
Business Question: How does overtime status relate to employee attrition?

SELECT OverTime AS "Overtime",
       COUNT(*) AS "Total Employees",
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "Employees Left",
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) || '%' AS "Attrition Rate"
FROM HR_ANALYTICS
GROUP BY OverTime
ORDER BY ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) DESC;
