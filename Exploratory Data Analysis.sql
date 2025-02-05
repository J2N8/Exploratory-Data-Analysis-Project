-- Exploratory Data Analysis
-- Here I am just going to explore the data and find trends, patterns, or anything interesting like outliers.

SELECT *
FROM layoffs_staging;

 -- Looking at Percentage to see how big these layoffs were

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_staging
WHERE  percentage_laid_off = 1;

-- Companies with the biggest layoffs (based on a single day)
SELECT company, total_laid_off
FROM layoffs_staging
ORDER BY 2 DESC;

-- The most total layoffs
-- by company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY location
ORDER BY 2 DESC;

-- by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;

-- by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;

-- by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

-- by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY dates
ORDER BY dates ASC;

	-- USING CTE
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off
,SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

-- Total of Layoffs Per Year (ranking) -- USING CTE
WITH Company_Year AS 
(
  SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging
  GROUP BY company, YEAR(`date`)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years 
  ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;




