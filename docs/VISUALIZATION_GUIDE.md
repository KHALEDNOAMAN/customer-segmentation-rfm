# RFM Segmentation - Visualization Guide

## Key Visualizations

### 1. RFM Score Distribution
```python
import matplotlib.pyplot as plt
import seaborn as sns

fig, axes = plt.subplots(1, 3, figsize=(15, 5))
for i, col in enumerate(['Recency', 'Frequency', 'Monetary']):
    sns.histplot(data=rfm, x=col, ax=axes[i], kde=True, color='steelblue')
    axes[i].set_title(f'{col} Distribution')
plt.tight_layout()
```

### 2. Customer Segments Treemap
```python
import squarify
segments = rfm['Segment'].value_counts()
squarify.plot(sizes=segments.values, label=segments.index,
              alpha=0.8, color=sns.color_palette('Set2'))
plt.title('Customer Segments')
```

### 3. 3D RFM Scatter
```python
from mpl_toolkits.mplot3d import Axes3D
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')
ax.scatter(rfm['Recency'], rfm['Frequency'], rfm['Monetary'],
           c=rfm['Cluster'], cmap='viridis', alpha=0.6)
```

## Segment Descriptions
| Segment | R | F | M | Action |
|---------|---|---|---|--------|
| Champions | Low | High | High | Reward & upsell |
| Loyal | Low | High | Mid | Cross-sell |
| At Risk | High | Mid | Mid | Win-back campaign |
| Lost | High | Low | Low | Re-engagement email |

## Presentation Tips
- Start with business impact numbers
- Show before/after segmentation results
- Include actionable recommendations for each segment
