# 🛒 Shoppers Intent MLOps Project

A production-grade, end-to-end MLOps project that predicts whether an online shopper will complete a purchase, built with a full **ETL → Train → Track → Serve → Monitor → Retrain** pipeline.

[![Python](https://img.shields.io/badge/Python-3.11-blue)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/API-FastAPI-009688)](https://fastapi.tiangolo.com/)
[![MLflow](https://img.shields.io/badge/Tracking-MLflow-0194E2)](https://mlflow.org/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED)](https://www.docker.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF)](https://github.com/features/actions)

---

## 📖 Overview

Online retailers lose revenue when they can't tell, in real time, which browsing sessions are likely to convert. **Shoppers Intent MLOps** solves this by wrapping a purchase-intent classifier in a complete MLOps lifecycle — not just a notebook model, but a system that ingests data, tracks experiments, serves predictions via an API, watches for drift, and retrains itself on a schedule.

- 🔗 **Live App**: [https://shoppers-intent-mlops-project.onrender.com](https://shoppers-intent-mlops-project.onrender.com)
- 📑 **Swagger / API Docs**: [[shoppers-intent-mlops-project.onrender.com/docs]](https://shoppers-intent-mlops-project.onrender.com/docs)

> ⚠️ Hosted on Render's free tier — the first request after idle time may take 30–60s to spin up.

---

## ✨ Key Features

- **Full ETL pipeline** — MySQL (source) → Python transform/validation → PostgreSQL (warehouse)
- **Multi-model training** — Random Forest, XGBoost, and LightGBM compared automatically, with GridSearchCV tuning
- **Class imbalance handling** — SMOTE oversampling on the minority (purchase) class
- **Experiment tracking & model registry** — every run logged to MLflow, best model promoted automatically
- **REST API** — FastAPI service exposing predictions, health checks, and a simple web frontend
- **Drift monitoring** — Evidently AI reports comparing live traffic to training data
- **Scheduled retraining** — APScheduler job re-trains the model daily
- **CI/CD** — GitHub Actions builds, tests, and deploys on every push; images pushed to Docker Hub
- **Structured logging & tests** — centralized logger + Pytest suite for the API layer

---

## 🏗️ Architecture

```
                MySQL (source)
                      │
                 ┌────▼────┐
                 │   ETL   │  extract → transform → load
                 └────┬────┘
                      │
              PostgreSQL (warehouse)
                      │
                 ┌────▼────┐
                 │Preprocess│ StandardScaler + SelectKBest + SMOTE
                 └────┬────┘
                      │
        ┌─────────────▼─────────────┐
        │   Train: RF / XGB / LGBM  │  GridSearchCV tuning
        └─────────────┬─────────────┘
                      │
              ┌───────▼───────┐
              │     MLflow     │  tracking + model registry
              └───────┬───────┘
                      │
               ┌──────▼──────┐
               │   FastAPI   │  /predict, /health, /docs, UI
               └──────┬──────┘
                      │
        ┌─────────────┼─────────────┐
        │                           │
┌───────▼────────┐        ┌─────────▼─────────┐
│ Evidently drift │        │ APScheduler daily │
│   monitoring    │        │  auto-retrain      │
└─────────────────┘        └────────────────────┘
```

---

## 🧰 Tech Stack

| Layer                 | Technology                          |
| ---------------------- | ------------------------------------ |
| Source DB              | MySQL                                |
| Data Warehouse         | PostgreSQL                           |
| ETL                     | Python (Extract → Transform → Load)  |
| Data Validation         | Pandas                               |
| ML Models               | Random Forest, XGBoost, LightGBM     |
| Hyperparameter Tuning   | GridSearchCV                         |
| Experiment Tracking     | MLflow                               |
| Model Registry          | MLflow Model Registry                |
| API                     | FastAPI                              |
| Monitoring              | Evidently AI                         |
| Scheduler               | APScheduler                          |
| Logging                 | Python `logging` module              |
| Testing                 | Pytest                               |
| Containerization        | Docker                               |
| CI/CD                   | GitHub Actions                       |
| Image Registry          | Docker Hub                           |
| Deployment              | Render (Free Tier)                   |

---

## 📁 Project Structure

```text
Shoppers_Intent_MLOPS_Project/
│
├── .github/
│   └── workflows/
│       └── ci_cd.yml              # GitHub Actions CI/CD pipeline
│
├── api/
│   ├── templates/
│   │   └── index.html             # Web application frontend
│   │
│   ├── static/
│   │   ├── style.css              # Frontend styling
│   │   └── script.js              # Frontend JavaScript
│   │
│   └── main.py                    # FastAPI application
│
├── data/
│   ├── online_shoppers_intention.csv  # Raw dataset
│   └── reload_data.py              # Load dataset into MySQL
│
├── etl/
│   ├── extract.py                  # Extract data from MySQL
│   ├── transform.py                # Clean and transform data
│   └── load.py                     # Load processed data into PostgreSQL
│
├── ml/
│   ├── preprocess.py               # Scaling, feature selection & SMOTE
│   ├── train.py                    # Model training & hyperparameter tuning
│   ├── evaluate.py                 # Model evaluation
│   ├── predict.py                  # Generate predictions
│   └── mlflow_tracker.py           # MLflow experiment tracking & registry
│
├── monitoring/
│   └── drift_report.py             # Evidently AI data drift monitoring
│
├── notebook/                       # Exploratory analysis / notebooks
│
├── scheduler/
│   └── retrain_job.py              # Scheduled model retraining
│
├── tests/
│   └── test_api.py                 # API tests using Pytest
│
├── utils/
│   └── logger.py                   # Centralized application logging
│
├── .dockerignore                   # Docker ignore rules
├── .env.example                    # Environment variable template
├── .gitignore                      # Git ignore rules
├── Dockerfile                      # Docker container configuration
├── README.md                       # Project documentation
├── apt.txt                         # System-level dependencies
└── requirements.txt                # Python dependencies


---

## 📊 Dataset

- **Source**: [Online Shoppers Purchasing Intention Dataset](https://archive.ics.uci.edu/dataset/468/online+shoppers+purchasing+intention+dataset) (UCI)
- **Rows**: 12,330 sessions
- **Target**: `Revenue` (purchase made or not)
- **Features**: 17 behavioral and session-level features (page values, bounce rate, visitor type, month, etc.)
- **Class imbalance**: corrected with SMOTE during preprocessing

---

## 🔄 ML Pipeline

1. **Extract** — pull raw session data from MySQL
2. **Validate** — check schema, nulls, and value ranges
3. **Transform** — encode categoricals, clean, deduplicate
4. **Load** — push cleaned data into the PostgreSQL warehouse
5. **Preprocess** — `StandardScaler` + `SelectKBest` + SMOTE
6. **Train** — Random Forest, XGBoost, and LightGBM, tuned with `GridSearchCV`
7. **Select** — best model auto-selected by ROC AUC
8. **Track** — logged to MLflow (experiments + model registry)
9. **Serve** — predictions exposed via the FastAPI `/predict` endpoint
10. **Monitor** — Evidently AI generates data drift reports
11. **Retrain** — APScheduler triggers a full retrain daily at 2 AM

---

## 📈 Model Performance

| Metric    | Score  |
| --------- | ------ |
| Accuracy  | 91.82% |
| Precision | 89.96% |
| Recall    | 94.33% |
| F1 Score  | 92.09% |
| ROC AUC   | 97.32% |

*(Best model selected automatically across RF / XGBoost / LightGBM by ROC AUC.)*

---

## 🔌 API Endpoints

| Method | Endpoint   | Description       |
| ------ | ---------- | ------------------ |
| GET    | `/`        | Frontend UI         |
| GET    | `/health`  | Health check         |
| POST   | `/predict` | Make a prediction    |
| GET    | `/docs`    | Swagger UI            |

**Example request:**

```bash
curl -X POST "https://shoppers-intent-mlops-project.onrender.com/predict" \
  -H "Content-Type: application/json" \
  -d '{
        "Administrative": 2,
        "Administrative_Duration": 15.5,
        "Informational": 0,
        "Informational_Duration": 0,
        "ProductRelated": 30,
        "ProductRelated_Duration": 500.0,
        "BounceRates": 0.02,
        "ExitRates": 0.03,
        "PageValues": 12.5,
        "SpecialDay": 0,
        "Month": "Nov",
        "OperatingSystems": 2,
        "Browser": 2,
        "Region": 1,
        "TrafficType": 2,
        "VisitorType": "Returning_Visitor",
        "Weekend": false
      }'
```

> Adjust the payload to match the exact feature schema expected by `api/main.py`.

---

## 🚀 Setup and Run Locally

### Prerequisites

- Python 3.11
- MySQL 8.0
- PostgreSQL 15+
- Docker (optional, for containerized run)

### 1. Clone the repository

```bash
git clone https://github.com/AkhileshPatil07/Shoppers_Intent_MLOPS_Project.git
cd Shoppers_Intent_MLOPS_Project
```

### 2. Create a virtual environment and install dependencies

```bash
python -m venv venv
source venv/bin/activate    # on Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 3. Configure environment variables

Copy the example env file and fill in your local database credentials:

```bash
cp .env.example .env
```



### 4. Load the raw dataset into MySQL

```bash
python data/reload_data.py
```

### 5. Run the ETL pipeline

```bash
python etl/extract.py
python etl/transform.py
python etl/load.py
```

### 6. Train the model

```bash
python ml/train.py
```

This preprocesses the data, trains RF/XGBoost/LightGBM with `GridSearchCV`, logs runs to MLflow, and registers the best model.

### 7. (Optional) Launch the MLflow UI

```bash
mlflow ui --backend-store-uri ./mlruns
```

### 8. Start the API

```bash
uvicorn api.main:app --reload
```

Visit `http://localhost:8000` for the UI or `http://localhost:8000/docs` for Swagger.

### 9. Run tests

```bash
pytest tests/
```

### Run with Docker instead

```bash
docker build -t shoppers-intent-mlops .
docker run --env-file .env -p 8000:8000 shoppers-intent-mlops
```

---

## 🩺 Monitoring & Retraining

- **Drift detection**: `python monitoring/drift_report.py` generates an Evidently AI HTML report comparing recent prediction traffic against the training distribution.
- **Scheduled retraining**: `scheduler/retrain_job.py` runs the full training pipeline daily at 2 AM via APScheduler, re-registering a new model version in MLflow if it outperforms the current one.

---

## 🧾 Logging

All modules log to:

- **Console** — real-time output during execution
- **`logs/app.log`** — persistent log file for later inspection

---

## ⚙️ CI/CD

`.github/workflows/ci_cd.yml` runs on every push to `main`:

1. Install dependencies and run Pytest
2. Build the Docker image
3. Push the image to Docker Hub
4. Trigger deployment to Render

---

## 🗺️ Roadmap

- [ ] Move infrastructure to the cloud (e.g., AWS) with IaC (Terraform)
- [ ] Add batch/streaming inference options
- [ ] Expand monitoring to include model performance decay, not just data drift
- [ ] Add authentication to the API and frontend

---

## 👤 Author

**Akhilesh Patil**
[GitHub](https://github.com/AkhileshPatil07)

---

## 📄 License

No license file is currently present in the repository. Add a `LICENSE` file (MIT is a common default for portfolio MLOps projects) to clarify usage terms for others.
