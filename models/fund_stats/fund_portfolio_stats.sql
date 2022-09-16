
-- 统计基金组合按权重买入后的重仓股占比


with fund_info AS (
  SELECT fund_name, fund_code
  FROM {{ ref('fund_name_em') }}
  WHERE fund_code IN (select fund_code from {{ ref('fund_portfolio_fund_percent') }})
),
stock_sum AS (
  SELECT stock_code, stock_name,
        cast(SUM(percent) AS DECIMAL(18,2)) pct
  from {{ ref('fund_portfolio_fund_percent') }}
  GROUP BY stock_code, stock_name
  HAVING SUM(percent) > 0
)
SELECT stock_sum.stock_code, stock_sum.stock_name, stock_sum.pct AS total_pct, 
       fund_info.fund_code, fund_info.fund_name, fund_portfolio_fund_percent.percent AS indiv_pct
FROM stock_sum
JOIN {{ ref('fund_portfolio_fund_percent') }} using (stock_code)
JOIN fund_info using (fund_code)
order by pct desc