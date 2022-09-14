
-- 统计3只基金等权重买入后的重仓股占比

with fund_stock_map AS (
  SELECT fund_code, stock_code, stock_name, cast(percent / 3 AS DECIMAL(18,2)) AS percent
  from {{ ref('fund_portfolio_hold_em') }}
  WHERE fund_code IN ('001716', '002446', '005094')
    AND season = '2022年2季度股票投资明细'
    and percent > 0
),
fund_info AS (
  SELECT fund_name, fund_code
  FROM {{ ref('fund_name_em') }}
  WHERE fund_code IN ('001716', '002446', '005094')
),
stock_sum AS (
	SELECT stock_code, stock_name,
	       cast(SUM(percent) AS DECIMAL(18,2)) pct
	from fund_stock_map
	GROUP BY stock_code, stock_name
	HAVING SUM(percent) > 0.5
)
SELECT stock_sum.stock_code, stock_sum.stock_name, stock_sum.pct AS total_pct, 
       fund_info.fund_code, fund_info.fund_name, fund_stock_map.percent AS indiv_pct
FROM stock_sum
JOIN fund_stock_map ON (fund_stock_map.stock_code = stock_sum.stock_code)
JOIN fund_info ON (fund_info.fund_code = fund_stock_map.fund_code)
order by pct desc