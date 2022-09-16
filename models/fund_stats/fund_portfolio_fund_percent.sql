SELECT fund_code, stock_code, stock_name, cast(percent * percentage AS DECIMAL(18,4)) AS percent
from {{ ref('fund_portfolio_hold_em') }}
inner join {{ ref('fund_portfolio_detail') }} using (fund_code)
WHERE season = '2022年2季度股票投资明细'
and percent > 0.1