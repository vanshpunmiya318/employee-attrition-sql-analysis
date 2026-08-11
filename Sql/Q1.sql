Q1: Department Attrition Rate
Business Question: Which department has the highest employee attrition?

SELECT Department AS "Department",
       COUNT(*) AS "Total Employees",
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "Employees Left",
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) || '%' AS "Attrition Rate"
FROM HR_ANALYTICS
GROUP BY Department
ORDER BY 4 DESC;

