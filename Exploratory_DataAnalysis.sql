select * 
from layoffs_staging2;

select max(total_laid_off)As Total_laid_off ,
 max(percentage_laid_off)As Percentage_laid_off
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`)As MinDate, max(`date`)As MaxDate
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select `date`,sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 1 desc;

select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date`,6,2)As Month, sum(total_laid_off)
from layoffs_staging2
group by `Month`
order by 1 asc;

select substring(`date`,1,7)As Month, sum(total_laid_off)
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

with Rolling_Total as
(
select substring(`date`,1,7)As Month, sum(total_laid_off) as Total_off
from layoffs_staging2 
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc
)
select `Month`,Total_off,
 sum(Total_off) over(order by `Month`) as rolling_total
from Rolling_Total;

with Rolling_Total as
(
select company,`date`, sum(total_laid_off) as Total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by company,`date`
order by 1 
)
select company,`date`,Total_off,
sum(Total_off) over(order by `date`) as rolling_total
from Rolling_Total;

select company, year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;


with company_year(company,years,total_laid_off) as
(
select company,year(`date`), sum(total_laid_off) as Total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by company,year(`date`) 
), company_Rank_year as
(select *, dense_rank() over(partition by years order by total_laid_off desc)as company_rank
from company_year
order by company_rank)
select *from company_Rank_year
where company_rank >5;
















