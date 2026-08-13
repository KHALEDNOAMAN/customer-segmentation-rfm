# Customer Segmentation using RFM Analysis & K-Means Clustering

Segmenting e-commerce customers by purchase behavior to enable targeted marketing — built as part of my data analyst portfolio.

## The Problem

Not all customers are the same. A win-back email sent to someone who purchased yesterday is a waste of budget, and a generic promo blast ignores your highest-value repeat buyers. Before you can market smart, you need to know who your customers actually are.

This project answers that using real transaction data from a UK-based online retailer — about 540,000 rows spanning a full year of sales.

## Approach

I used the **RFM framework** (Recency, Frequency, Monetary) — a classic, proven method in marketing analytics — to compress raw transaction-level data into a behavioral profile per customer. Then I applied **K-Means clustering** to group customers into segments based on those profiles.

**Pipeline:**
1. **Clean the data** — drop transactions with no customer ID, remove cancelled orders and invalid quantities/prices
2. **Compute RFM metrics** — Recency (days since last purchase), Frequency (number of orders), Monetary (total spend)
3. **Scale the features** — StandardScaler, so Monetary (in the thousands) doesn't dominate over Recency (in days)
4. **Find the right number of clusters** — Elbow Method to pick K
5. **Cluster & label** — K-Means groups customers, then I map each cluster to a business-readable segment (Champions, Loyal, At-Risk, Lost)
6. **Visualize** — dashboard showing segment sizes, spend distribution, and geography

## Results

| Data Stage | Rows |
|---|---|
| Raw dataset | 541,909 |
| After dropping null CustomerID | 406,829 |
| After removing cancellations | 397,924 |
| After removing invalid quantity/price | 397,884 |

Final cleaned dataset: **397,884 transactions** across **~4,300 unique customers**.

*(Segment breakdown and key insights go here once clustering is complete — e.g. % of customers per segment, revenue concentration, geographic patterns.)*

## Tech Stack

- **Python** — pandas, numpy for data cleaning and RFM computation
- **scikit-learn** — StandardScaler, KMeans for clustering
- **matplotlib / seaborn** — EDA and cluster visualization
- **Tableau Public** — interactive segment dashboard

## Project Structure

```
customer-segmentation-rfm/
├── data/
│   └── online_retail.xlsx
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_rfm_analysis.ipynb
│   └── 03_kmeans_clustering.ipynb
├── outputs/
│   └── rfm_segments.csv
├── dashboard/
│   └── customer_segmentation.twbx
├── requirements.txt
└── README.md
```

## Running It Locally

```bash
git clone https://github.com/YOUR_USERNAME/customer-segmentation-rfm.git
cd customer-segmentation-rfm
pip install -r requirements.txt
```

Then open the notebooks in order — `01_data_cleaning.ipynb` → `02_rfm_analysis.ipynb` → `03_kmeans_clustering.ipynb`.

## What I Learned

Working through this project reinforced why scaling matters before distance-based clustering, and how much of a real analytics project is actually just cleaning — the modeling itself was a small fraction of the total time compared to getting the data into a trustworthy state.

---

**Yash Sharma** — [LinkedIn](https://www.linkedin.com/in/yash-sharma-8a77581b5) · [GitHub](https://www.github.com/yash00003)