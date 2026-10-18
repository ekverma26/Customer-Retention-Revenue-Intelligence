select * from customer;

--Q1. Which contract types have the highest churn rate and monthly revenue exposure?
select contract, count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customer,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate,
round(sum(
case when churn = 'Yes'
then monthlycharges
else 0.0
end
):: numeric,2) as monthly_revenue_exposure
from customer 
group by contract order by churn_rate desc;

--Question 2: How does churn vary across customer tenure groups?
select 
case
when tenure<=6 then '0-6 months'
when tenure<=12 then '7-12 months'
when tenure<=24 then '13-24 months'
when tenure<=48 then '25-48 months'
else '49-72 months' 
end as tenure_group,
count(*) as total_customer,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate
from customer
group by 
case
when tenure<=6 then '0-6 months'
when tenure<=12 then '7-12 months'
when tenure<=24 then '13-24 months'
when tenure<=48 then '25-48 months'
else '49-72 months' 
end
order by min(tenure);

--Question 3 — Which payment methods are associated with the highest churn and revenue exposure?

select paymentmethod,
count(*) as total_customer,
count(*) filter(where churn='Yes') as churned_customer,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate,
ROUND(
SUM(monthlycharges)::numeric,2
) AS total_monthly_revenue,
round(
sum(
case when churn='Yes'
then monthlycharges
else 0
end
)::numeric,
2) as churned_monthly_revenue_exposure
from customer
group by paymentmethod
order by churn_rate desc;


--Question 4 — Which internet service types have the highest churn and revenue exposure?
select Internetservice, 
count(*) as total_customer,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate,
ROUND(
SUM(monthlycharges)::numeric,2
) AS total_monthly_revenue,
round(
sum(
case when churn='Yes'
then monthlycharges
else 0
end
)::numeric,
2) as churned_monthly_revenue_exposure
from customer
group by Internetservice
order by churn_rate desc;

--Question 5 — Which combinations of contract type and internet service have the highest churn?
select contract, Internetservice, 
count(*) as total_customer,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate
from customer
group by contract, Internetservice
order by churn_rate desc;

--Question 6 — Which customer segments have the highest monthly revenue exposure from churn?
with segment_analysis as(
select contract, internetservice, paymentmethod,
count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate,
ROUND(
SUM(monthlycharges)::numeric,2
) AS total_monthly_revenue,
round(
sum(
case when churn='Yes'
then monthlycharges
else 0
end
)::numeric,
2) as churned_monthly_revenue_exposure
from customer
group by contract, internetservice, paymentmethod
)

select * from segment_analysis where churned_customers>0
order by churned_monthly_revenue_exposure desc
limit 10;


-- Question 7 — Which customers are high-value and high-risk?
select customerid, contract, internetservice, paymentmethod, 
tenure, monthlycharges, totalcharges, churn,
case
when monthlycharges>=89.85
and tenure>=55
and churn ='Yes'
then 'High valure churned customer'
else 'other customer'
end as customer_risk_category
from customer
where monthlycharges>=89.85
and tenure>=55
and churn ='Yes'
order by monthlycharges desc;

-- Question 8 — How does churn vary by technical support and online security?
select 'TechSupport' AS service_type,
techsupport as service_status,
count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate
from customer
group by techsupport
union all
select 
'OnlineSecurity' AS service_type,
onlinesecurity as service_status,
count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customers,
round(
100.0 * count(*) filter(where churn='Yes')/count(*),2 
) as churn_rate
from customer
group by onlinesecurity
order by service_type, churn_rate desc;

--Question 9 — Find high-risk segments with above-average monthly charges
with overall_metrics as(
select avg(monthlycharges) as avg_monthly_charges,
100.0*count(*) filter(where churn='Yes')/ count(*) as overall_churn_rate
from customer
),
segment_metrics as(
select contract, internetservice, paymentmethod,
count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customers,
100.0 * count(*) filter(where churn='Yes')/count(*) as churn_rate,
avg(monthlycharges) AS avg_monthly_charges
from customer
group by contract, internetservice, paymentmethod
having count(*)>=30
)

select s.contract, s.internetservice, s.paymentmethod,
s.total_customers, s.churned_customers,
round(s.churn_rate::numeric,2) as churn_rate,
round(s.avg_monthly_charges::numeric,2) as avg_monthly_charges,
round(o.overall_churn_rate::numeric,2) as overall_churn_rate,
round(o.avg_monthly_charges::numeric,2) as avg_monthly_charges
from segment_metrics s cross join overall_metrics o 
where s.churn_rate>o.overall_churn_rate
and s.avg_monthly_charges>o.avg_monthly_charges
order by s.churn_rate desc;

--Question 10 — Rank customer segments using SQL window functions
with segment_metrics as(
select contract, internetservice, paymentmethod,
count(*) as total_customers,
count(*) filter(where churn='Yes') as churned_customers,
100.0 * count(*) filter(where churn='Yes')/count(*) as churn_rate
from customer
group by contract, internetservice, paymentmethod
having count(*)>=30
)
select internetservice, contract, paymentmethod, total_customers,churned_customers,
round(churn_rate::numeric,2) as churn_rate,
rank() over(
partition by internetservice
order by churn_rate desc
) as risk_rank
from segment_metrics
order by internetservice, risk_rank;
