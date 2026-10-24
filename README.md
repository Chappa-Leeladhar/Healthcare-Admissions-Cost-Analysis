# Healthcare-Admissions-Cost-Analysis

An end-to-end analysis of a hospital admissions dataset: cleaned in Python (pandas), explored with SQL (MySQL), and presented in a two-page Power BI dashboard.

**Tools:** Python (pandas) · MySQL · Power BI

## Objective

Understand who is being admitted, for what, at what cost, and for how long, so that hospital and insurance teams know where volume and cost sit.

## Dataset

- Source: healthcare admissions dataset (`healthcare_dataset.csv`)
- 54,966 admission records after cleaning (SQL `count(*)`)
- Key fields: age, gender, blood type, medical condition, admission and discharge dates, billing amount, medication, insurance provider, test results

> Note: this appears to be a synthetic dataset, so many groups come out nearly equal. See *Limitations*.

## 1. Data cleaning (Python / pandas)

Notebook: `healthcare.ipynb`

| Issue found | Fix |
|---|---|
| Inconsistent column names (spaces, wrong names) | Replaced spaces with underscores, renamed columns |
| Inconsistent name casing | Standardised with `str.strip().str.title()` |
| Dates stored as text | Converted to datetime |
| Negative billing amounts (**[X] rows**) | Converted to positive with `abs()` and rounded to 2 decimals |
| Titles and suffixes in doctor names (Mr., Dr., MD, PhD...) | Removed with regex |
| Stray commas and leading/trailing "and" in hospital names | Cleaned with regex |
| Duplicate rows (**[X] rows**) | Dropped |

New columns created: `Age_Group` (Child <15, Adult 15-29, Middle Aged 30-59, Old Age 60+), `Length_of_Stay` (days), `Admission_Year`.

Rows before cleaning: **[X]** → after cleaning: **54,966**

## 2. Business questions and findings (SQL)

Queries: `Healthcare.sql`

**Q1. Which age group is admitted the most?**
Middle Aged (30-59) with 24,413 admissions (44.4%), followed by Old Age (60+) at 20,948 (38.1%). Together they make up about 82% of admissions. Adult (15-29) has 9,573 (17.4%) and Child has only 32 (0.06%).
*Caveat: the age groups have different widths, so wider groups naturally hold more patients.*

**Q2. Which medical condition is most common?**
Arthritis (9,218), but all six conditions are very close: the lowest, Asthma, has 9,095. The gap between first and last is about 1.3%, so no condition clearly dominates.

**Q3. Which year had the most admissions?**
2020 with 11,172. 2021-2023 are steady at about 10,800-10,900 per year. 2019 (7,300) and 2024 (3,827) are lower, most likely because they are partial years in the data, not because admissions fell. **[Confirm with `select min(Admission_Date), max(Admission_Date)`]**

**Q4. What is the average bill by condition?**
Obesity is the highest at 25,806.63 and Cancer the lowest at 25,154.73. The spread is only about 2.6%.

**Q5. Which medication is prescribed most for each condition?**

| Condition | Top medication | Patients |
|---|---|---|
| Arthritis | Aspirin | 1,901 |
| Asthma | Paracetamol | 1,870 |
| Cancer | Lipitor | 1,904 |
| Diabetes | Lipitor | 1,875 |
| Hypertension | Ibuprofen | 1,874 |
| Obesity | Penicillin | 1,872 |

Each top medication covers only about 20% of its condition's patients, which is what you would expect if the five medications are used almost equally.

**Q6. Which condition does each insurance provider cover the most?**

| Insurance provider | Top condition | Patients |
|---|---|---|
| Aetna | Hypertension | 1,862 |
| Blue Cross | Obesity | 1,872 |
| Cigna | Asthma | 1,890 |
| Medicare | Diabetes | 1,885 |
| UnitedHealthcare | Hypertension | 1,866 |

The leading condition differs by provider, but the margins are small.

**Q7. What is the average length of stay by condition?**
Asthma has the longest stay at 15.68 days and Diabetes the shortest at 15.43. The whole range is only about 0.25 days.

## 3. Dashboard (Power BI)

**Page 1: Overview**: KPI cards (admissions, total billing, average bill, average stay), admissions by age group, by condition and by year, with slicers for insurance provider, blood type and gender.

**Page 2: Cost & Care**: average bill by condition, average stay by condition, and a medication-by-condition matrix.

*<img width="956" height="582" alt="Screenshot_20261024_112844" src="https://github.com/user-attachments/assets/46fe9861-bea2-4a79-8fbd-028717039d06" />
<img width="965" height="585" alt="Screenshot_20261024_112902" src="https://github.com/user-attachments/assets/e551d572-84c7-4961-af89-5f795bb37a1a" />
*

## 4. Key takeaways and recommendations

1. **Plan around adults 30 and over.** They account for about 82% of admissions, while child admissions are almost zero in this data. Capacity and staffing should follow that mix.
2. **Cost differs more than stay length.** Obesity has the highest average bill but a mid-range stay, while Asthma has the longest stay but only a mid-range bill. Cost is therefore not simply driven by days in hospital, and billing items per condition are worth a closer look.
3. **Demand is steady.** Full years 2020-2023 stay close to 11K admissions per year, so a flat baseline is a reasonable planning assumption.
4. **Insurer mix differs slightly.** Each provider's top condition is different, which could guide provider-specific care programs, but the differences are small and should be checked on larger, real data.

## Limitations

- The dataset looks synthetic: conditions, medications, costs and stay lengths are almost uniform, and some medication-condition pairs are not clinically realistic (for example Lipitor as the top medication for cancer, Penicillin for obesity). Findings show how the analysis was done, not real clinical patterns.
- 2019 and 2024 appear to be partial years, so year comparisons use 2020-2023.
- Counts are admission records. One person can appear in several admissions, so unique patients are fewer than total admissions.

## Repository contents

- `healthcare.ipynb`: data cleaning
- `Healthcare.sql`: business questions and queries
- `Healthcare_Dashboard.pbix`: Power BI dashboard
