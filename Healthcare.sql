select * from healthcare;
#Q1. Which age group people are admitting to the hospitals most?
select Age_Group,count(*)count_of_patients from healthcare
group by Age_Group
order by 2 desc;
#Q2. Which medical condition is observed mostly among the patients?
select Medical_Condition,count(*)count_of_patients from healthcare
group by Medical_Condition
order by 2 desc;
#Q3. Which year had the highest number of people admitted into the hospitals?
select Admission_Year,count(*)count_of_patients from healthcare
group by Admission_Year
order by 2 desc;
#Q4. What's the average billing amount for different medical conditions?
select Medical_Condition,round(avg(Billing_Amount),2)avg_bill from healthcare
group by Medical_Condition
order by 2 desc;
#Q5. Which medication is prescribed the most to the patients for different medical conditions?
with medication_ranking as
(select Medication,Medical_Condition,count(*)patient_count,
dense_rank() over(partition by Medical_Condition order by count(*)desc)rk from healthcare
group by Medication,Medical_Condition)
select Medication,Medical_Condition,patient_count
from medication_ranking
where rk=1;
#Q6. Which Medical Condition did each Insurance Provider covered the most?
with condition_ranking as
(select Medical_Condition,Insurance_Provider,count(*)count_of_patients,dense_rank()over(partition by Insurance_Provider
order by count(*)desc)ranking
from healthcare
group by Medical_Condition,Insurance_Provider)
select Insurance_Provider,Medical_Condition,count_of_patients from condition_ranking
where ranking=1;
#Q7. On average how many days a patient stays for different medical condition?
select Medical_Condition,round(avg(Length_Of_Stay),2)avg_days from healthcare
group by Medical_Condition
order by 2 desc;