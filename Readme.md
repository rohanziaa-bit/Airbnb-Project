# Airbnb End-to-End Data Engineering Project

## Overview

This project demonstrates an end-to-end data transformation pipeline using **Snowflake and dbt (Data Build Tool)**. It processes Airbnb bookings, hosts, and listings data through a structured Medallion Architecture: Bronze, Silver, and Gold.

The project focuses on transforming raw source data into clean, structured, and analytics-ready datasets while applying data engineering practices such as modular SQL transformations, reusable macros, data quality testing, and Slowly Changing Dimensions (SCD Type 2).

## Architecture

### Data Flow

```text
Airbnb Source Data
       |
       v
Snowflake Staging Layer
       |
       v
Bronze Layer
(Raw Data Transformations)
       |
       v
Silver Layer
(Data Cleaning & Standardization)
       |
       v
Gold Layer
(Analytics-Ready Models)
       |
       v
Business Intelligence & Analytics
```

### Technology Stack

| Technology | Purpose |
|---|---|
| Snowflake | Cloud Data Warehouse |
| dbt Core | Data Transformation |
| dbt-snowflake | Snowflake Integration |
| SQL | Data Modeling and Transformation |
| Jinja | Dynamic SQL Generation |
| Python 3.12+ | Development Environment |
| Git & GitHub | Version Control |

## Medallion Architecture

### Bronze Layer

The Bronze layer contains the initial transformations of Airbnb source data from Snowflake staging tables.

Models:

- `bronze_bookings`
- `bronze_hosts`
- `bronze_listings`

### Silver Layer

The Silver layer focuses on cleaning, standardizing, and preparing the data for downstream analytics.

Models:

- `silver_bookings`
- `silver_hosts`
- `silver_listings`

### Gold Layer

The Gold layer contains business-oriented transformations and analytics-ready datasets.

Models:

- `obt` – One Big Table combining relevant Airbnb datasets.
- `fact` – Fact-oriented transformation.
- Ephemeral models for bookings, hosts, listings, and fact transformations.

## Slowly Changing Dimensions (SCD Type 2)

The project uses dbt snapshots to track historical changes in source records.

Configured snapshots:

- `dim_bookings`
- `dim_hosts`
- `dim_listings`

SCD Type 2 helps preserve historical versions of records instead of simply overwriting previous values.

This supports historical analysis and tracking changes over time.

## Project Structure

```text
airbnb setup/
│
├── .gitignore
│
└── dbt_snowflake_setup/
    │
    └── airbnb_project/
        │
        ├── README.md
        ├── dbt_project.yml
        ├── properties.yml
        │
        ├── models/
        │   │
        │   ├── source/
        │   │   └── sources.yaml
        │   │
        │   ├── bronze/
        │   │   ├── bronze_bookings.sql
        │   │   ├── bronze_hosts.sql
        │   │   └── bronze_listings.sql
        │   │
        │   ├── silver/
        │   │   ├── silver_bookings.sql
        │   │   ├── silver_hosts.sql
        │   │   └── silver_listings.sql
        │   │
        │   └── gold/
        │       ├── obt.sql
        │       │
        │       └── ephemeral/
        │           ├── bookings.sql
        │           ├── fact.sql
        │           ├── hosts.sql
        │           └── listings.sql
        │
        ├── macros/
        │   ├── generate_schema_name.sql
        │   ├── multiply.sql
        │   ├── tag.sql
        │   └── trimmer.sql
        │
        ├── snapshots/
        │   ├── dim_bookings.yml
        │   ├── dim_hosts.yml
        │   └── dim_listings.yml
        │
        ├── tests/
        │   └── source_test.sql
        │
        ├── analyses/
        │   ├── explore.sql
        │   ├── if_else.sql
        │   └── loop.sql
        │
        └── seeds/
```

## Getting Started

### Prerequisites

- Python 3.12+
- Snowflake account
- dbt Core
- dbt Snowflake adapter
- Git

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd "airbnb setup/dbt_snowflake_setup/airbnb_project"
```

### 2. Create a Virtual Environment

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

### 3. Install Dependencies

```bash
pip install dbt-core dbt-snowflake
```

### 4. Configure Snowflake Connection

Create the dbt profile file:

```text
~/.dbt/profiles.yml
```

Configure your Snowflake credentials using the profile name specified in `dbt_project.yml`.

Example configuration:

```yaml
airbnb_project:
  outputs:
    dev:
      type: snowflake
      account: <your-account-identifier>
      user: <your-username>
      password: <your-password>
      role: ACCOUNTADMIN
      database: AIRBNB
      warehouse: <your-warehouse>
      schema: DBT_SCHEMA
      threads: 4

  target: dev
```

**Security:** Never commit your actual `profiles.yml` or Snowflake credentials to GitHub. Use environment variables or another secure credential-management method.

### 5. Configure Source Tables

The dbt source configuration is maintained in:

```text
models/source/sources.yaml
```

The project expects Airbnb source datasets to be available in the Snowflake staging layer:

- `BOOKINGS`
- `HOSTS`
- `LISTINGS`

Make sure your Snowflake source database and schema match the configuration in your dbt source YAML file.

## Running the Project

Run these commands from the `airbnb_project` directory.

### Test Snowflake Connection

```bash
dbt debug
```

### Run Bronze Models

```bash
dbt run --select bronze
```

### Run Silver Models

```bash
dbt run --select silver
```

### Run Gold Models

```bash
dbt run --select gold
```

### Run All Models

```bash
dbt run
```

### Execute Data Quality Tests

```bash
dbt test
```

### Execute Snapshots

```bash
dbt snapshot
```

### Build Models and Run Tests

```bash
dbt build
```

### Generate dbt Documentation

```bash
dbt docs generate
dbt docs serve
```

## Key dbt Features

### 1. Modular Data Modeling

The project separates transformations into Bronze, Silver, and Gold layers, making the pipeline easier to maintain and understand.

### 2. Custom Macros

Reusable macros reduce SQL duplication and make transformations easier to manage.

Implemented macros:

- `generate_schema_name` – Custom schema naming logic.
- `multiply` – Reusable multiplication logic.
- `tag` – Reusable categorization logic.
- `trimmer` – String trimming utility.

### 3. Jinja Templating

Jinja is used to write dynamic and reusable SQL, including conditional logic and loops.

### 4. Ephemeral Models

Ephemeral models allow intermediate transformations to be incorporated into downstream SQL without creating separate physical tables or views.

### 5. Data Quality Testing

Custom SQL tests and dbt testing capabilities help validate source data and transformation logic.

### 6. SCD Type 2 Snapshots

Snapshots preserve historical changes in bookings, hosts, and listings data.

## Data Quality and Documentation

The project uses dbt's testing and documentation capabilities to support data quality and maintainability.

Key areas include:

- Source data validation.
- Custom SQL tests.
- Model-level testing.
- Documentation of transformations.
- Model dependency tracking.
- Data lineage through the dbt DAG.

## Security Best Practices

- Keep Snowflake credentials outside the Git repository.
- Never expose passwords or sensitive connection details.
- Use `.gitignore` to exclude virtual environments and generated logs.
- Use appropriate Snowflake roles and permissions.
- Follow secure credential-management practices.

## Future Enhancements

The following improvements can extend this project:

- Integrate AWS S3 for source data storage.
- Implement automated ingestion into Snowflake.
- Add incremental loading for large datasets.
- Develop more comprehensive data quality tests.
- Implement CI/CD using GitHub Actions.
- Build a Power BI analytics dashboard.
- Add pipeline monitoring and alerting.
- Improve data security with masking and role-based access control.

## Author

**Project:** Airbnb End-to-End Data Engineering Project

**Technologies:** Snowflake | dbt | SQL | Python | Git | GitHub

**Focus:** Data Engineering | Data Warehousing | ELT | Medallion Architecture | Data Modeling

## License

This project is developed as a data engineering portfolio project for learning and demonstrating practical data engineering skills.
