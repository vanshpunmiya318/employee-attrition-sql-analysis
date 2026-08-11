Q6: Cumulative Attrition Risk
Business Question: How does employee attrition change as multiple risk factors accumulate?


WITH pay_ranked AS (
    SELECT
        EmployeeNumber,
        NTILE(4) OVER (PARTITION BY JobRole ORDER BY MonthlyIncome) AS pay_quartile
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
        NTILE(3) OVER (ORDER BY stagnation_ratio) AS gap_tercile
    FROM stagnation_base
    WHERE stagnation_ratio > 0   -- excludes zero promotion-gap employees, consistent with Q5
),
risk_flags AS (
    SELECT
        h.EmployeeNumber,
        h.Attrition,
        CASE WHEN p.pay_quartile = 1 THEN 1 ELSE 0 END AS low_pay_flag,
        CASE WHEN s.gap_tercile = 3 THEN 1 ELSE 0 END AS high_stagnation_flag,
        CASE WHEN h.OverTime = 'Yes' THEN 1 ELSE 0 END AS overtime_flag,
        CASE WHEN h.JobSatisfaction <= 2 THEN 1 ELSE 0 END AS low_satisfaction_flag,
        CASE WHEN h.EnvironmentSatisfaction <= 2 THEN 1 ELSE 0 END AS low_environment_flag
    FROM HR_ANALYTICS h
    LEFT JOIN pay_ranked p        ON h.EmployeeNumber = p.EmployeeNumber
    LEFT JOIN stagnation_ranked s ON h.EmployeeNumber = s.EmployeeNumber
),
risk_summary AS (
    SELECT
        EmployeeNumber,
        Attrition,
        low_pay_flag + high_stagnation_flag + overtime_flag
            + low_satisfaction_flag + low_environment_flag AS risk_factor_count
    FROM risk_flags
)
SELECT
    risk_factor_count AS "Risk Factor Count",
    COUNT(*) AS "Total Employees",
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS "Employees Left",
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Attrition Rate"
FROM risk_summary
GROUP BY risk_factor_count
ORDER BY risk_factor_count;
