Q7: Risk Factor Prioritization
Business Question: Which individual risk factors account for the greatest number of attrition cases among employees exposed to each risk?

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
    WHERE stagnation_ratio > 0
),
risk_flags AS (
    SELECT
        h.EmployeeNumber,
        h.Attrition,
        CASE WHEN p.pay_quartile = 1 THEN 1 ELSE 0 END AS low_pay_flag,
        CASE WHEN s.gap_tercile = 3 THEN 1 ELSE 0 END AS high_promotion_gap_flag,
        CASE WHEN h.OverTime = 'Yes' THEN 1 ELSE 0 END AS overtime_flag,
        CASE WHEN h.JobSatisfaction <= 2 THEN 1 ELSE 0 END AS low_job_satisfaction_flag,
        CASE WHEN h.EnvironmentSatisfaction <= 2 THEN 1 ELSE 0 END AS low_environment_satisfaction_flag
    FROM HR_ANALYTICS h
    LEFT JOIN pay_ranked p
        ON h.EmployeeNumber = p.EmployeeNumber
    LEFT JOIN stagnation_ranked s
        ON h.EmployeeNumber = s.EmployeeNumber
)

SELECT
    'Overtime' AS "RISK FACTOR",
    SUM(overtime_flag) AS "EMPLOYEES WITH RISK",
    SUM(CASE WHEN overtime_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END) AS "ATTRITION CASES",
    ROUND(
        SUM(CASE WHEN overtime_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(SUM(overtime_flag), 0),
        2
    ) AS "ATTRITION RATE"
FROM risk_flags

UNION ALL

SELECT
    'Low Environment Satisfaction',
    SUM(low_environment_satisfaction_flag),
    SUM(CASE WHEN low_environment_satisfaction_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN low_environment_satisfaction_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(SUM(low_environment_satisfaction_flag), 0),
        2
    )
FROM risk_flags

UNION ALL

SELECT
    'Low Job Satisfaction',
    SUM(low_job_satisfaction_flag),
    SUM(CASE WHEN low_job_satisfaction_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN low_job_satisfaction_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(SUM(low_job_satisfaction_flag), 0),
        2
    )
FROM risk_flags

UNION ALL

SELECT
    'Low Pay',
    SUM(low_pay_flag),
    SUM(CASE WHEN low_pay_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN low_pay_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(SUM(low_pay_flag), 0),
        2
    )
FROM risk_flags

UNION ALL

SELECT
    'High Promotion Gap',
    SUM(high_promotion_gap_flag),
    SUM(CASE WHEN high_promotion_gap_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END),
    ROUND(
        SUM(CASE WHEN high_promotion_gap_flag = 1 AND Attrition = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(SUM(high_promotion_gap_flag), 0),
        2
    )
FROM risk_flags

ORDER BY "ATTRITION CASES" DESC, "ATTRITION RATE" DESC;
