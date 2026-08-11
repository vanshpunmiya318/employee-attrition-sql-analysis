Q8 Validation: Tenure Distribution Check
Purpose: Validate whether the tenure difference between high-risk employees who left and stayed is broad-based rather than driven by outliers.

WITH pay_ranked AS (
SELECT EmployeeNumber,NTILE(4) OVER (PARTITION BY JobRole ORDER BY MonthlyIncome) AS pay_quartile
FROM HR_ANALYTICS
),
stagnation_base AS (
SELECT EmployeeNumber,YearsSinceLastPromotion / YearsAtCompany AS stagnation_ratio
FROM HR_ANALYTICS
WHERE YearsAtCompany > 0
),
stagnation_ranked AS (
SELECT EmployeeNumber,NTILE(3) OVER (ORDER BY stagnation_ratio) AS gap_tercile
FROM stagnation_base
WHERE stagnation_ratio > 0
),
risk_scored AS (
SELECT
h.EmployeeNumber,
h.ATTRITION AS attrition_status,
h.YearsAtCompany,
CASE WHEN p.pay_quartile = 1 THEN 1 ELSE 0 END
+ CASE WHEN s.gap_tercile = 3 THEN 1 ELSE 0 END
+ CASE WHEN h.OverTime = 'Yes' THEN 1 ELSE 0 END
+ CASE WHEN h.JobSatisfaction <= 2 THEN 1 ELSE 0 END
+ CASE WHEN h.EnvironmentSatisfaction <= 2 THEN 1 ELSE 0 END AS risk_factor_count
FROM HR_ANALYTICS h
LEFT JOIN pay_ranked p ON h.EmployeeNumber = p.EmployeeNumber
LEFT JOIN stagnation_ranked s ON h.EmployeeNumber = s.EmployeeNumber
),
high_risk AS (
SELECT
CASE WHEN attrition_status = 'Yes' THEN 'High-Risk Employees Who Left' ELSE 'High-Risk Employees Who Stayed' END AS employee_outcome,
YearsAtCompany
FROM risk_scored
WHERE risk_factor_count >= 3
)
SELECT
employee_outcome AS "Employee Outcome",
COUNT(*) AS "Employees",
MIN(YearsAtCompany) AS "Min Tenure",
ROUND(MEDIAN(YearsAtCompany),1) AS "Median Tenure",
ROUND(AVG(YearsAtCompany),1) AS "Avg Tenure",
MAX(YearsAtCompany) AS "Max Tenure"
FROM high_risk
GROUP BY employee_outcome
ORDER BY CASE WHEN employee_outcome = 'High-Risk Employees Who Left' THEN 1 ELSE 2 END;
