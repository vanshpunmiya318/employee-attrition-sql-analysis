Q5: Promotion Stagnation and Attrition
Business Question: How does promotion stagnation relate to employee attrition?

WITH stagnation AS (
SELECT
EmployeeNumber,
Attrition,
YearsAtCompany,
YearsSinceLastPromotion,
YearsSinceLastPromotion / YearsAtCompany AS promotion_gap_ratio
FROM HR_ANALYTICS
WHERE YearsAtCompany > 0
),
non_zero AS (
SELECT
EmployeeNumber,
Attrition,
YearsAtCompany,
promotion_gap_ratio,
NTILE(3) OVER (ORDER BY promotion_gap_ratio) AS gap_group
FROM stagnation
WHERE promotion_gap_ratio > 0
),
summary AS (
SELECT
1 AS sort_order,
'Zero Promotion Gap' AS "PROMOTION STATUS",
'-' AS "STAGNATION LEVEL",
COUNT(*) AS "TOTAL EMPLOYEES",
ROUND(AVG(YearsAtCompany), 1) AS "AVG TENURE",
ROUND(AVG(promotion_gap_ratio), 2) AS "AVG PROMOTION GAP RATIO",
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "EMPLOYEES LEFT",
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) || '%' AS "ATTRITION RATE"
FROM stagnation
WHERE promotion_gap_ratio = 0

UNION ALL

SELECT
gap_group + 1 AS sort_order,
'Promotion Gap' AS "PROMOTION STATUS",
CASE gap_group
WHEN 1 THEN 'Low'
WHEN 2 THEN 'Medium'
WHEN 3 THEN 'High'
END AS "STAGNATION LEVEL",
COUNT(*) AS "TOTAL EMPLOYEES",
ROUND(AVG(YearsAtCompany), 1) AS "AVG TENURE",
ROUND(AVG(promotion_gap_ratio), 2) AS "AVG PROMOTION GAP RATIO",
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "EMPLOYEES LEFT",
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) || '%' AS "ATTRITION RATE"
FROM non_zero
GROUP BY gap_group
)
SELECT
"PROMOTION STATUS",
"STAGNATION LEVEL",
"TOTAL EMPLOYEES",
"AVG TENURE",
"AVG PROMOTION GAP RATIO",
"EMPLOYEES LEFT",
"ATTRITION RATE"
FROM summary
ORDER BY sort_order;
