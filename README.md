**Cross-Channel Ad Performance Dashboard**

Unifying Facebook, Google, and TikTok advertising data into a single cloud data model and an interactive one-page dashboard.

(**https://bobaplz.github.io/improvado-dashboard/cross-channel-ad-performance.html**)

**Overview**
The task: take raw advertising exports from three platforms, unify them into one cloud database, and build a one-page dashboard surfacing cross-channel performance. This repo contains the end-to-end work — the data model, the unification logic, and the live interactive dashboard.
The dataset is 30 days of January 2024 daily campaign data: 330 rows across 3 platforms, 12 campaigns.

**Data pipeline**

1. Cloud database — Azure SQL
Provisioned an Azure SQL Database (serverless, free tier) and loaded the three raw exports as-is:

- facebook_ads
- google_ads
- tiktok_ads

2. Unified model — one table from three
The three sources don't share a schema, so a single unified_ads table is built in-database via UNION ALL. The key normalization decisions:
IssueResolutionSpend column named spend (FB) vs cost (Google, TikTok)Unified to a single spend measureSub-campaign level: ad_set (FB) / ad_group (Google) / adgroup (TikTok)Generalized to ad_group_id / ad_group_nameRevenue (conversion_value) exists only in GoogleKept as nullable revenue; ROAS scoped to Google rather than faked across channels
Additive base metrics only live in the table (impressions, clicks, spend, conversions, revenue). Ratio metrics (CTR, CPC, CPM, CPA, conversion rate, ROAS) are computed at query/visualization time so they aggregate correctly.
The unification SQL is in sql/build_unified_ads.sql.

3. Dashboard — two versions
v1 — Power BI (local)
The first build was in Power BI Desktop, connected directly to Azure SQL (Import mode): KPI cards, platform CPA/CTR comparison, a daily spend & conversions trend, a campaign table, and a CPC-vs-conversion-rate efficiency bubble chart.
It worked well locally, but the deliverable required a publicly shareable live link. Power BI's only anonymous-link option (Publish to Web) is gated by organization tenant settings, which were disabled on the accounts available to me. Rather than fight the tenant restrictions, I rebuilt the dashboard in a self-hostable format.
v2 — Interactive HTML (this repo)
A single self-contained index.html rebuilds the same dashboard with HTML/CSS/JavaScript + Chart.js — no account, license, or tenant gatekeeping. It carries the data inline, recomputes all metrics client-side, and supports interactive platform filtering. Hosted free on GitHub Pages, which gives the required public live link.
The visual layout and branding mirror the Power BI version.

**Key insights**

Facebook is the most cost-efficient channel — lowest CPA ($7.64) and highest CTR (1.96%).
TikTok drives the most scale — 57% of total spend and the most conversions — but at the highest CPA ($11.00, ~44% above Facebook). It trades efficiency for reach.
High-intent campaigns win on efficiency. Search_Brand_Terms (Google) has the best CPA ($5.10); Conversions_Retargeting (Facebook) is close behind.
Clearest reallocation candidate: Search_Generic_Terms (Google) — high CPC paired with weak conversion and the worst CPA ($24.80).
ROAS is computable for Google only (the sole channel with revenue data), so cross-channel return comparisons are intentionally constrained.


Tech stack

Database: Azure SQL Database (serverless)
Unification: T-SQL (UNION ALL)
Dashboard v1: Power BI Desktop
Dashboard v2: HTML / CSS / JavaScript, Chart.js
Hosting: GitHub Pages
