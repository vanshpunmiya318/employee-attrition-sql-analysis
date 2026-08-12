# HR Analytics: Employee Attrition Analysis

## Project Overview

This project analyzes employee attrition using SQL to identify patterns across departments, overtime, work-life balance, compensation, promotion stagnation, and combined employee risk factors.

The analysis consists of eight business questions, progressing from broad department-level attrition patterns to more detailed employee risk-factor analysis.

The project focuses on descriptive and observational analysis. The findings identify patterns and associations in the dataset but do not establish causation or predictive relationships.

## Business Objective

The objective is to understand where employee attrition is concentrated and identify employee characteristics and workplace conditions associated with higher observed attrition.

The analysis examines:

- Department-level attrition
- The relationship between overtime and attrition
- Overtime and work-life balance together
- Relative pay position within job roles
- Promotion stagnation
- Accumulation of multiple risk factors
- Individual risk factors and their observed attrition rates
- Differences between high-risk employees who left and those who stayed

## Dataset

The project uses the IBM HR Analytics Employee Attrition & Performance dataset.

The dataset contains employee-level information covering demographics, job characteristics, compensation, satisfaction, performance, promotion history, and attrition status.

Key variables used in the analysis include:

- Department
- Job Role
- Monthly Income
- OverTime
- Job Satisfaction
- Environment Satisfaction
- Work-Life Balance
- Years At Company
- Years Since Last Promotion
- Years With Current Manager
- Job Level
- Job Involvement
- Performance Rating
- Stock Option Level
- Attrition

The dataset contains 1,470 employees.

## Tools & Technologies

- Oracle Database
- Oracle SQL
- Common Table Expressions (CTEs)
- Window Functions
- `NTILE()`
- `UNPIVOT`
- Conditional Aggregation
- SQL Aggregations and Grouping

## Analytical Approach

The analysis was structured around eight business questions, with each query designed to answer a specific business problem.

Key analytical techniques included:

- Calculating department-level attrition rates
- Comparing attrition between overtime and non-overtime employees
- Segmenting employees by work-life balance within overtime groups
- Comparing relative pay position within individual job roles
- Measuring promotion stagnation using a promotion-gap ratio
- Creating binary risk flags for identified attrition-related conditions
- Combining risk flags into a cumulative risk count
- Comparing high-risk employees who left with those who stayed

For comparisons involving pay, employees were ranked into pay quartiles separately within each job role rather than across the entire company.

Promotion stagnation was measured using:

`YearsSinceLastPromotion / YearsAtCompany`

Employees with a non-zero promotion gap were divided into three groups using `NTILE(3)`.

The cumulative risk analysis used five binary risk factors:

1. Overtime
2. Low Environment Satisfaction
3. Low Job Satisfaction
4. Low Pay
5. High Promotion Gap

Each employee's risk score is a simple count of the applicable risk factors. The factors are not weighted.

## Key Insights

### 1. Sales has the highest department-level attrition rate

Sales has the highest attrition rate at 20.63%, followed by Human Resources at 19.05% and Research & Development at 13.84%.

Research & Development nevertheless accounts for the largest number of departures because it has a much larger workforce.

### 2. Overtime shows the strongest observed association with attrition

Employees working overtime have an attrition rate of 30.53%, compared with 10.44% among employees who do not work overtime.

This difference remains visible across every work-life-balance category examined in Q3, making overtime the most consistent pattern observed across the analyses.

The analysis is observational and does not establish that overtime causes attrition.

### 3. Work-life balance does not show a simple linear relationship with attrition

Attrition is highest among employees with poor work-life balance within both overtime groups, but the relationship is not monotonic.

In both overtime and non-overtime groups, attrition falls from Poor to Good work-life balance and then rises again for Excellent work-life balance.

The more consistent pattern is the difference between overtime and non-overtime employees within each work-life-balance category.

### 4. The relationship between pay position and attrition varies by job role

Laboratory Technicians and Research Scientists show substantially higher attrition among their lowest-paid employees than their highest-paid employees.

However, the pattern reverses for Sales Executives, Healthcare Representatives, and Manufacturing Directors.

This indicates that relative pay position does not have a consistent company-wide relationship with attrition and should be interpreted in the context of the employee's job role.

### 5. Promotion stagnation shows a non-linear relationship with attrition

Among employees with a non-zero promotion gap, attrition increases from 10.44% in the Low group to 12.16% in the Medium group and 20.27% in the High group.

However, the Zero Promotion Gap group has an attrition rate of 17.50%, meaning the overall relationship is not a simple linear progression across all categories.

The High Promotion Gap group also has lower average tenure, which is important when interpreting the promotion-gap ratio because YearsAtCompany is its denominator.

### 6. Attrition increases as multiple risk factors accumulate

Attrition rises consistently as the number of identified risk factors increases, from 4.63% among employees with zero risk factors to 27.17% among those with three.

Employees with four or more risk factors have a combined attrition rate of 57.14%.

The five-risk-factor group has an attrition rate of 66.67%, but it contains only six employees, so the combined 4+ group provides a more informative summary while still warranting caution.

### 7. Overtime has the highest observed attrition rate among the identified risk factors

Among the five identified risk factors, overtime has the highest attrition rate at 30.53% and the highest number of attrition cases at 127.

The other four risk factors have relatively similar attrition rates, ranging from 19.46% to 20.27%.

Because employees can meet multiple risk-factor conditions, these groups are not mutually exclusive.

### 8. High-risk employees who left differ from those who stayed

Among employees classified as high-risk, those who left generally had lower average job levels, job involvement, stock option levels, tenure, tenure with their current manager, and monthly income than those who stayed.

The largest observed differences include average years at the company (3.66 vs. 6.20), average years with the current manager (2.43 vs. 4.07), and average monthly income (4,311 vs. 6,124).

The median tenure also differs, at 2.5 years for high-risk employees who left compared with 5.0 years for those who stayed.

Performance rating and work-life balance show little to no difference between the two groups.

These are observed group differences and should not be interpreted as evidence that any individual characteristic caused an employee to leave.

## Methodology & Validation

Several methodological decisions were used to make the comparisons more meaningful and reduce misleading interpretations.

### Relative Pay Analysis

Pay quartiles were calculated separately within each job role. This prevents employees in fundamentally different roles from being compared solely on absolute salary.

Only job roles with at least 30 employees in both the lowest- and highest-paid groups were included.

### Promotion Stagnation

The promotion-gap ratio was calculated only for employees with more than zero years at the company.

Employees with a zero promotion gap were kept as a separate group rather than being mixed into the non-zero promotion-gap distribution.

The remaining employees were divided into three equal-sized groups using `NTILE(3)`.

### Risk Factors

The five risk factors were converted into binary flags and combined into a simple risk-factor count.

No factor was given additional weight.

### Supporting Validation

Supporting validation queries were added where a specific result required additional context, particularly where distributions or smaller groups could make averages or individual categories misleading.

For example, Q8 includes a supporting tenure-distribution analysis to confirm that the difference in average tenure between high-risk employees who left and stayed is also reflected in their median tenure.

## Limitations

- The analysis is observational and does not establish causation.
- The dataset represents a specific employee population and may not generalize to other organizations.
- Risk-factor groups are not mutually exclusive, so an employee may meet several risk conditions simultaneously.
- Some smaller groups have greater volatility in their reported attrition rates.
- The promotion-gap ratio can behave differently for employees with shorter tenure because YearsAtCompany is used as the denominator.
- The Zero Promotion Gap group can contain both relatively recent employees and employees whose most recent promotion occurred within the previous year; the dataset does not distinguish between these cases.
- No statistical significance testing or predictive modeling was performed.
- The analysis identifies observed relationships rather than forecasting which individual employees will leave.

## Project Structure

HR-Analytics-Employee-Attrition/
│
├── README.md
│
├── sql/
│   ├── Q1.sql
│   ├── Q2.sql
│   ├── Q3.sql
│   ├── Q4.sql
│   ├── Q5.sql
│   ├── Q6.sql
│   ├── Q7.sql
│   └── Q8.sql
│
└── results/
    ├── Q1.md
    ├── Q2.md
    ├── Q3.md
    ├── Q4.md
    ├── Q5.md
    ├── Q6.md
    ├── Q7.md
    └── Q8.md

Each SQL file contains the query used to answer the corresponding business question, while the results files document the output, methodology, and interpretation.

## Conclusion

The analysis shows that employee attrition is associated with several overlapping workplace and employee characteristics, but no single factor provides a universal explanation.

Overtime shows the strongest and most consistent observed association across the analyses, while pay and promotion relationships vary depending on job role and employee group.

The cumulative risk analysis shows that employees exposed to multiple identified risk conditions have substantially higher observed attrition rates than employees with fewer risk conditions.

Finally, the comparison of high-risk employees who left versus those who stayed highlights differences in tenure, job level, job involvement, compensation, stock options, and manager tenure, while performance rating and work-life balance show little difference.

Overall, the project demonstrates how SQL can be used to move from basic descriptive reporting toward structured employee-risk analysis while maintaining appropriate caution around causation, sample size, and interpretation.



