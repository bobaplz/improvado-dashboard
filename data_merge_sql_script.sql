IF OBJECT_ID('dbo.unified_ads','U') IS NOT NULL
    DROP TABLE dbo.unified_ads;

SELECT
    CAST([date] AS date)        AS [date],
    'Facebook'                  AS platform,
    campaign_id,
    campaign_name,
    ad_set_id                   AS ad_group_id,
    ad_set_name                 AS ad_group_name,
    impressions,
    clicks,
    CAST(spend AS decimal(18,2)) AS spend,
    conversions,
    CAST(NULL AS decimal(18,2))  AS revenue
INTO dbo.unified_ads                       
FROM dbo.facebook_ads

UNION ALL

SELECT
    CAST([date] AS date),
    'Google',
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,
    impressions,
    clicks,
    CAST(cost AS decimal(18,2)),
    conversions,
    CAST(conversion_value AS decimal(18,2))
FROM dbo.google_ads

UNION ALL

SELECT
    CAST([date] AS date),
    'TikTok',
    campaign_id,
    campaign_name,
    adgroup_id,
    adgroup_name,
    impressions,
    clicks,
    CAST(cost AS decimal(18,2)),
    conversions,
    CAST(NULL AS decimal(18,2))
FROM dbo.tiktok_ads;