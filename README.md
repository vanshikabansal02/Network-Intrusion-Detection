# Network Intrusion Detection System (NSL-KDD)

A machine learning system that classifies network traffic as **normal** or **malicious** using the [NSL-KDD dataset](https://www.unb.ca/cic/datasets/nsl.html), an improved version of the original KDD Cup 1999 dataset with duplicate records removed and more realistic difficulty distribution.

## Overview

This project:
- Loads 100K+ network traffic records (41 features each) into a relational **SQL schema**, with indexes and example feature-analysis queries
- Trains and compares three classifiers — **Logistic Regression**, **Decision Tree**, and **Random Forest** — on both binary (normal/attack) and multi-class (normal/DoS/Probe/R2L/U2R) classification tasks
- Evaluates using precision, recall, and F1-score, with particular focus on **false negative rate** — since in security, a missed attack is far more costly than a false alarm
- Selects a final model based on that security-first tradeoff rather than raw accuracy alone

## Dataset

NSL-KDD contains network connection records labeled as either `normal` or one of ~40 specific attack types, which roll up into 4 broad categories:
- **DoS** (Denial of Service) — e.g. neptune, smurf, back
- **Probe** (surveillance/scanning) — e.g. satan, ipsweep, portsweep
- **R2L** (Remote-to-Local unauthorized access) — e.g. guess_passwd, ftp_write
- **U2R** (User-to-Root privilege escalation) — e.g. buffer_overflow, rootkit

A key feature of NSL-KDD: the **test set includes attack types never seen in training**, simulating the real-world challenge of detecting novel attacks — this is why the results below are meaningfully lower than the ~99% accuracy sometimes reported on the older KDD Cup '99 dataset, and is a more realistic benchmark.

## Project Structure
nids-project/
├── data/
│ └── raw/
│ ├── KDDTrain.txt # 125,973 records (not committed — see setup)
│ └── KDDTest.txt # 22,544 records (not committed — see setup)
├── sql/
│ └── schema.sql # Relational schema + indexes + attack category lookup
├── notebooks/
│ └── network_intrusion_detection.ipynb
└── README.md
## Setup

1. Clone this repo
2. Install dependencies:
```bash
   pip install pandas scikit-learn matplotlib seaborn jupyter
```
3. Download the dataset into `data/raw/`:
```bash
   curl -L -o data/raw/KDDTrain.txt https://raw.githubusercontent.com/jmnwong/NSL-KDD-Dataset/master/KDDTrain%2B.txt
   curl -L -o data/raw/KDDTest.txt https://raw.githubusercontent.com/jmnwong/NSL-KDD-Dataset/master/KDDTest%2B.txt
```
4. Launch Jupyter and run `notebooks/network_intrusion_detection.ipynb` top to bottom:
```bash
   jupyter notebook
```

## Results — Binary Classification (Normal vs. Attack)

| Model | Accuracy | Precision | Recall | F1-Score | False Negatives | False Negative Rate |
|---|---|---|---|---|---|---|
| **Decision Tree** | 0.778 | 0.965 | 0.633 | **0.765** | 4,712 | **0.367** |
| Random Forest | 0.770 | 0.967 | 0.617 | 0.753 | 4,915 | 0.383 |
| Logistic Regression | 0.754 | 0.925 | 0.618 | 0.741 | 4,906 | 0.382 |

**Decision Tree** was selected as the final model: it achieved the lowest false negative rate and best F1-score. All three models show precision above 0.92 (false alarms are rare); the harder problem is recall on unfamiliar attack types, driven by NSL-KDD's test set deliberately including attacks not seen during training.

Model selection prioritized **false negative rate over raw accuracy**, since a missed attack (false negative) that reaches its target is far costlier in a security context than a false alarm a human analyst has to dismiss.

## Multi-Class Classification

Extending to 5-way classification (normal/DoS/Probe/R2L/U2R) shows strong performance on DoS and Probe, but weaker recall on R2L and U2R — expected, given those categories have far fewer training examples. A production system would likely add class rebalancing (e.g. SMOTE) or a two-stage detect-then-classify pipeline to improve detection of these rarer, often more severe attack types.

## Tech Stack

- **Python**: pandas, scikit-learn, matplotlib, seaborn
- **SQL**: SQLite (schema portable to PostgreSQL/MySQL)
- **Models**: Logistic Regression, Decision Tree, Random Forest

## License

MIT