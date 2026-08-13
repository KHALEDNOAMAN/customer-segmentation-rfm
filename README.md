# Customer Segmentation using RFM Analysis & K-Means Clustering

Segmenting e-commerce customers by purchase behavior to enable targeted marketing — built as part of my data analyst portfolio.

**[→ Open the interactive dashboard](https://yash00003.github.io/customer-segmentation-rfm/)**

## The Problem

Not all customers are the same. A win-back email sent to someone who purchased yesterday is a waste of budget, and a generic promo blast ignores your highest-value repeat buyers. Before you can market smart, you need to know who your customers actually are.

This project answers that using real transaction data from a UK-based online retailer — 541,909 transactions spanning a full year.

## Approach

I used the **RFM framework** (Recency, Frequency, Monetary) to compress raw transaction-level data into a behavioral profile per customer, computed it two independent ways (SQL and pandas) to cross-check correctness, then applied **K-Means clustering** to group customers into segments.

**Pipeline:**
1. **Clean the data** — drop transactions with no customer ID, remove cancelled orders and invalid quantities/prices
2. **Compute RFM metrics** — Recency (days since last purchase), Frequency (distinct orders), Monetary (total spend) — via a real SQL query (`sql/rfm_aggregation.sql`) run against SQLite, cross-checked against an independently-written pandas `groupby` implementation
3. **Log-transform + scale the features** — Frequency and Monetary are heavily right-skewed (a handful of very high-value customers stretch the tail); `log1p` compresses that before `StandardScaler`, so Monetary (in the thousands) doesn't dominate Recency (in days). Skipping the log step was tested and produced degenerate, outlier-driven clusters — documented in `notebooks/03_elbow_method.ipynb`
4. **Find the right number of clusters** — Elbow Method + silhouette score across K=2–10
5. **Cluster & label** — K-Means (K=4) groups customers; cluster numbers are mapped to business labels (Champions / Loyal Customers / At-Risk / Lost) via a reproducible rank-based rule, not a hardcoded lookup
6. **Visualize** — an interactive dashboard with segment filtering, KPI cards, a Recency-vs-Monetary scatter of every customer, and a country breakdown

## Results

| Data Stage | Rows |
|---|---|
| Raw dataset | 541,909 |
| After dropping null CustomerID | 406,829 |
| After removing cancellations | 397,924 |
| After removing invalid quantity/price | 397,884 |

Final cleaned dataset: **397,884 transactions** across **4,338 unique customers**, £8,911,408 in total revenue.

### Segments

| Segment | Avg Recency | Avg Frequency | Avg Monetary | % of Customers | % of Revenue |
|---|---|---|---|---|---|
| **Champions** | 20 days | 15.8 orders | £9,801 | 13.2% | **63.1%** |
| **Loyal Customers** | 47 days | 4.2 orders | £1,650 | 33.4% | 26.8% |
| **At-Risk** | 59 days | 1.5 orders | £386 | 31.7% | 6.0% |
| **Lost** | 260 days | 1.4 orders | £387 | 21.6% | 4.1% |

**Key insight:** 13.2% of customers (Champions) generate 63.1% of total revenue — extreme concentration that justifies a "protect at all costs" retention strategy over blanket marketing. At-Risk and Lost customers have nearly identical historical value (~£386 avg spend) — the only real difference is Recency (59 days vs. 260 days). At-Risk customers represent **£532,118** in historical revenue; even a 30% win-back campaign recovers an estimated **£160,405**.

## Tech Stack

- **SQL (SQLite)** — real, executed RFM aggregation query (`GROUP BY`, `COUNT(DISTINCT)`, date arithmetic), cross-validated against pandas
- **Python** — pandas, numpy for data cleaning, RFM computation, and feature engineering
- **scikit-learn** — StandardScaler, KMeans, silhouette_score
- **matplotlib / seaborn** — EDA, elbow/silhouette plots, cluster visualization
- **HTML / CSS / JS (SVG)** — self-contained interactive dashboard (segment filtering, KPI cards, scatter, country breakdown) — built as a portable, dependency-free alternative to Power BI/Tableau, which required Windows/a desktop app unavailable in this environment

## Project Structure

```
customer-segmentation-rfm/
├── data/
│   ├── Online_Retail.csv           # raw dataset (not committed — see below)
│   ├── cleaned_transactions.csv    # output of 01_data_cleaning.ipynb (gitignored)
│   └── rfm.csv                     # output of 02_rfm_analysis.ipynb (gitignored)
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_rfm_analysis.ipynb       # SQL + pandas, cross-validated
│   ├── 03_elbow_method.ipynb       # scaling, log-transform, K selection
│   └── 04_kmeans_clustering.ipynb  # final model, labeling, exports
├── sql/
│   └── rfm_aggregation.sql         # executable SQL, not decorative
├── outputs/
│   ├── rfm_table.csv               # final per-customer segment table
│   ├── segment_summary.csv
│   ├── elbow_silhouette.png
│   └── segment_scatter.png
├── dashboard/
│   └── segment_dashboard.html      # interactive dashboard (self-contained)
├── docs/
│   └── index.html                  # copy of the dashboard, served via GitHub Pages
├── requirements.txt
└── README.md
```

## Running It Locally

```bash
git clone https://github.com/yash00003/customer-segmentation-rfm.git
cd customer-segmentation-rfm
pip install -r requirements.txt
```

Download the [UCI Online Retail dataset](https://www.kaggle.com/datasets/vijayuv/onlineretail) into `data/Online_Retail.csv`, then run the notebooks in order:
`01_data_cleaning.ipynb` → `02_rfm_analysis.ipynb` → `03_elbow_method.ipynb` → `04_kmeans_clustering.ipynb`

Then open `dashboard/segment_dashboard.html` directly in a browser — no server needed, the data is embedded.

## What I Learned

Scaling isn't the whole story for K-Means on this kind of data — `StandardScaler` alone on raw RFM values produced one dominant cluster plus outlier-driven noise, because Frequency and Monetary are heavily right-skewed. Log-transforming those two features first, *then* scaling, was the fix, and it's the kind of thing you only catch by inspecting cluster sizes rather than trusting default settings.

Labeling clusters also needed more care than "eyeball the table" — cluster numbers from K-Means are arbitrary, so I built a rank-based rule (sum of Recency/Frequency/Monetary ranks per cluster) that assigns business labels reproducibly, regardless of how the raw cluster IDs happen to come out.

As with most real analytics projects, cleaning and validating the data (and cross-checking SQL against pandas) took longer than the modeling itself.

## Resume Bullet

> Performed RFM-based customer segmentation on 541K+ e-commerce transactions (UCI Online Retail); cleaned data with pandas and cross-validated RFM aggregation via SQL (SQLite) against an independent pandas implementation; applied log-transformation, StandardScaler, and K-Means clustering (K=4, selected via Elbow Method + silhouette score); identified 4 behavioral segments — Champions (13.2% of customers, 63.1% of revenue), Loyal (33.4%), At-Risk (31.7%), Lost (21.6%) — and built an interactive web dashboard surfacing an estimated £160K in recoverable revenue from a targeted At-Risk win-back campaign.

---

**Yash Sharma** — [LinkedIn](https://www.linkedin.com/in/yash-sharma-8a77581b5) · [GitHub](https://www.github.com/yash00003)
