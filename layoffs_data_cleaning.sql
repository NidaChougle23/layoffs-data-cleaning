-- Data Cleaning

select * from layoffs;

-- 1. Remove duplicates 
-- 2. standardize data
-- 3. null/blank values
-- 4. remove any columns or rows

create table layoffs_staging
like layoffs;

select * from layoffs;

insert layoffs_staging
select * 
from layoffs; 

select * from layoffs;

with duplicate_cte as
(
select *,
row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * from 
duplicate_cte
where row_num>1;

select * 
from layoffs_staging
where company='Oda';

Select * from layoffs_staging
where company='Casper';

with duplicate_cte as
(
select *,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete 
from duplicate_cte
where row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(
partition by company,industry,total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

select *
from layoffs_staging2;

select * from 
layoffs_staging2
where row_num>1;

delete from 
layoffs_staging2
where row_num > 1;

select * from 
layoffs_staging2
where row_num>1;

select * from 
layoffs_staging2;

-- standardization

SELECT DISTINCT company
FROM layoffs_staging2;

UPDATE layoffs_staging2 SET 
company = TRIM(company); 

SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country='United States'
WHERE country like 'United States%';

-- OR YOU CAN ALSO USE TRAILING 

SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country= TRIM(TRAILING '.' FROM country)
;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`	= STR_TO_DATE(`date`,'%m/%d/%Y')
;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2;


-- NULL OR BLANK values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR INDUSTRY =''
ORDER BY 1;

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 
SET industry = null
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;