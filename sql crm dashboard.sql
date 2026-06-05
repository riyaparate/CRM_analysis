-- CRM  PROJECT QUERY SQL 
-- 1 Total Expected Amount
SELECT 
    SUM(
        CAST(
            TRIM(REPLACE(REPLACE(`Expected Amount`, '$', ''), ',', '')) 
        AS DECIMAL(18,2))
    ) AS total_expected_amount
FROM `oppertuninty table`
WHERE `Stage` <> 'Closed Won'
  AND `Stage` <> 'Closed Lost';
  
  -- 2 Opportunity Conversion Rate
  SELECT 
    ROUND(
        SUM(CASE WHEN `Stage` = 'Closed Won' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(1),
    2) AS conversion_rate
FROM `oppertuninty table`;

-- 3 Revenue by Stage
SELECT 
    Stage,
    SUM(
        CAST(
            TRIM(REPLACE(REPLACE(`Expected Amount`, '$', ''), ',', '')) 
        AS DECIMAL(18,2))
    ) AS revenue
FROM `oppertuninty table`
GROUP BY Stage
ORDER BY revenue DESC;

-- 4 Active Opportunities
SELECT 
    COUNT(1) AS active_opps
FROM `oppertuninty table`
WHERE `Stage` NOT IN ('Closed Won', 'Closed Lost');

-- 5 Win Rate
SELECT 
    ROUND(
        SUM(CASE WHEN `Stage` = 'Closed Won' THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN `Stage` IN ('Closed Won','Closed Lost') THEN 1 ELSE 0 END),0),
    2) AS win_rate
FROM `oppertuninty table`;

-- 6 Loss Rate
SELECT 
    ROUND(
        SUM(CASE WHEN `Stage` = 'Closed Lost' THEN 1 ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN `Stage` IN ('Closed Won','Closed Lost') THEN 1 ELSE 0 END),0),
    2) AS loss_rate
FROM `oppertuninty table`;

-- 7 Total Leads
SELECT 
    COUNT(1) AS total_leads
FROM `lead`;

-- 8 Converted Opportunities
SELECT 
    SUM(COALESCE(`# Converted Opportunities`,0)) AS total_converted_opps
FROM `lead`;

-- 9 Lead Conversion Rate
SELECT 
    ROUND(
        SUM(`# Converted Opportunities`) * 100.0 / COUNT(1),
    2) AS lead_conversion_rate
FROM `lead`;

-- 10 Opportunities & Revenue by Industry
SELECT 
    a.Industry,
    COUNT(*) AS opp_count,
    SUM(
        CAST(
            TRIM(REPLACE(REPLACE(o.`Expected Amount`, '$', ''), ',', '')) 
        AS DECIMAL(18,2))
    ) AS revenue
FROM `oppertuninty table` o
LEFT JOIN `account` a
    ON a.`Account ID` = o.`Account ID`
WHERE COALESCE(TRIM(a.Industry),'') NOT IN ('', 'FALSE')
GROUP BY a.Industry
ORDER BY revenue DESC;