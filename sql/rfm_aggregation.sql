-- ============================================================
-- rfm_aggregation.sql
--
-- Collapses transaction-level data (one row per line item) into
-- customer-level RFM metrics (one row per customer):
--   Recency   -- days since the customer's most recent order
--   Frequency -- number of distinct orders placed
--   Monetary  -- total revenue generated
--
-- Expects a table `transactions` with columns:
--   CustomerID, InvoiceNo, InvoiceDate (text, 'YYYY-MM-DD HH:MM:SS'),
--   Revenue (= Quantity * UnitPrice, computed during data cleaning)
--
-- Run with: sqlite3, or any engine after minor date-function tweaks
-- (SQLite's julianday()/date() differ from MySQL's DATEDIFF/SQL Server's
-- DATEDIFF -- the underlying logic is identical, only the syntax changes).
-- ============================================================

WITH reference_date AS (
    -- "Today" for this dataset = the day AFTER the last recorded purchase.
    -- Using max+1 (not max) means the most recent purchaser gets Recency = 1,
    -- never 0 -- a Recency of 0 would make that customer indistinguishable
    -- from "no time has passed," which breaks distance-based comparisons
    -- later in K-Means. Classic off-by-one to avoid in RFM.
    SELECT date(MAX(date(InvoiceDate)), '+1 day') AS ref_date
    FROM transactions
)

SELECT
    CustomerID,

    -- Recency: days between the reference date and this customer's last order
    CAST(
        julianday((SELECT ref_date FROM reference_date)) - julianday(MAX(date(InvoiceDate)))
        AS INTEGER
    ) AS Recency,

    -- Frequency: distinct ORDERS, not line items. One order = many product
    -- rows; COUNT(*) would reward buying many items in a single order as if
    -- it were repeat loyalty, so we count unique InvoiceNo instead.
    COUNT(DISTINCT InvoiceNo) AS Frequency,

    -- Monetary: total revenue across all of the customer's orders
    ROUND(SUM(Revenue), 2) AS Monetary

FROM transactions
GROUP BY CustomerID
ORDER BY Monetary DESC;
