{{ config(materialized='table') }}

with stock_pct as (
  SELECT distinct stock_code, stock_name, total_pct
  FROM {{ ref('fund_portfolio_stats') }}
),
stock_industry_pct as (
  select stock_pct.stock_code, 
         stock_pct.stock_name,
         coalesce(stock_info.industry, 'Others') as industry,
         stock_pct.total_pct
  from {{ ref('stock_info') }}
  right join stock_pct using (stock_code)
  order by total_pct desc
  limit 100
)
select industry, sum(total_pct)
from stock_industry_pct
group by industry