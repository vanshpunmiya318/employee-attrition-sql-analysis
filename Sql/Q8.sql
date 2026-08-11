Q8: High-Risk Employee Resilience
Business Question: Among employees with 3+ identified attrition risk factors, what distinguishes those who stayed from those who left?

WITH pay_ranked AS (
    SELECT
        EmployeeNumber,
        NTILE(4) OVER (
            PARTITION BY JobRole
            ORDER BY MonthlyIncome
        ) AS pay_quartile
    FROM HR_ANALYTICS
),
stagnation_base AS (
    SELECT
        EmployeeNumber,
        YearsSinceLastPromotion / YearsAtCompany AS stagnation_ratio
    FROM HR_ANALYTICS
    WHERE YearsAtCompany > 0
),
stagnation_ranked AS (
    SELECT
        EmployeeNumber,
        NTILE(3) OVER (
            ORDER BY stagnation_ratio
        ) AS gap_tercile
    FROM stagnation_base
    WHERE stagnation_ratio > 0
),
risk_scored AS (
    SELECT
        h.*,
        CASE WHEN p.pay_quartile = 1 THEN 1 ELSE 0 END
        + CASE WHEN s.gap_tercile = 3 THEN 1 ELSE 0 END
        + CASE WHEN h.OverTime = 'Yes' THEN 1 ELSE 0 END
        + CASE WHEN h.JobSatisfaction <= 2 THEN 1 ELSE 0 END
        + CASE WHEN h.EnvironmentSatisfaction <= 2 THEN 1 ELSE 0 END
        AS risk_factor_count
    FROM HR_ANALYTICS h
    LEFT JOIN pay_ranked p
        ON h.EmployeeNumber = p.EmployeeNumber
    LEFT JOIN stagnation_ranked s
        ON h.EmployeeNumber = s.EmployeeNumber
)
SELECT
    CASE
        WHEN Attrition = 'Yes' THEN 'High-Risk Employees Who Left'
        ELSE 'High-Risk Employees Who Stayed'
    END AS "Employee Outcome",
    COUNT(*) AS "Employees",
    ROUND(AVG(JobLevel), 2) AS "Avg Job Level",
    ROUND(AVG(PerformanceRating), 2) AS "Avg Performance Rating",
    ROUND(AVG(JobInvolvement), 2) AS "Avg Job Involvement",
    ROUND(AVG(WorkLifeBalance), 2) AS "Avg Work Life Balance",
    ROUND(AVG(StockOptionLevel), 2) AS "Avg Stock Option Level",
    ROUND(AVG(YearsAtCompany), 2) AS "Avg Years At Company",
    ROUND(AVG(YearsWithCurrManager), 2) AS "Avg Years With Manager",
    ROUND(AVG(MonthlyIncome), 0) AS "Avg Monthly Income"
FROM risk_scored
WHERE risk_factor_count >= 3
GROUP BY
    CASE
        WHEN Attrition = 'Yes' THEN 'High-Risk Employees Who Left'
        ELSE 'High-Risk Employees Who Stayed'
    END
ORDER BY "Employee Outcome";
