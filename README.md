# Staymetrics
StayMetrics

An end-to-end personal Data Engineering project built to understand how raw booking data moves from cloud storage to analytics-ready business metrics.

Architecture

AWS S3
  │
  ▼
Snowflake STAGING
  │
  ▼
┌──────────────┐
│    BRONZE    │  ← Incremental ingestion
└──────┬───────┘
       ▼
┌──────────────┐
│    SILVER    │  ← Cleaning & transformation
└──────┬───────┘
       ▼
┌──────────────┐
│     GOLD     │  ← OBT / analytics-ready data
└──────┬───────┘
       │
       ├──────────────► Time Spine
       │
       ▼
┌─────────────────────┐
│ dbt Semantic Layer  │
│                     │
│ Dimensions          │
│ Measures            │
│ Metrics             │
└──────────┬──────────┘
           ▼
       Analytics / BI


       What is StayMetrics?

StayMetrics is a personal data engineering project based on a fictional accommodation-booking dataset containing information about:

Listings
Hosts
Bookings

The goal was to build a complete transformation pipeline and understand how raw operational data can be converted into analytics-ready data and reusable business metrics.

The project uses dummy data and is intended for learning and portfolio purposes.

Tech Stack
Technology	Purpose
AWS S3	Raw data source
Snowflake	Cloud data warehouse
dbt	Data transformation and modeling
SQL	Data manipulation and transformations
Jinja	Dynamic dbt SQL and macros
Python	Supporting data engineering work
MetricFlow	Semantic-layer concepts
Git/GitHub	Version control
Pipeline Layers
STAGING

Raw source tables are made available in Snowflake and defined as dbt sources.

STAGING
├── LISTINGS
├── BOOKINGS
└── HOSTS
BRONZE

The Bronze layer handles the initial ingestion from the staging sources.

Implemented using dbt incremental models to avoid unnecessarily processing the entire source dataset on every run.

STAGING → BRONZE
SILVER

The Silver layer applies business transformations and standardization.

Examples include:

Cleaning host names
Categorizing response rates
Categorizing property pricing
Calculating booking amounts
Standardizing analytical fields
BRONZE → SILVER
GOLD

The Gold layer contains an OBT (One Big Table) designed for analytics consumption.

The OBT combines booking, listing, and host information into a single analytical dataset.

SILVER BOOKINGS
       │
       ├──────────────┐
       ▼              ▼
SILVER LISTINGS → GOLD OBT ← SILVER HOSTS
dbt Semantic Layer

A semantic layer was added on top of the Gold OBT to centralize business definitions.

Current semantic concepts include:

Entities
Booking
Listing
Host
Dimensions
Booking Date
Booking Status
Property Type
Room Type
City
Country
Price Per Night Tag
Response Rate Quality
Is Superhost
Measures

Current measures include:

Total Revenue
Booking Count

A daily time spine is also included to support time-based analytics.

Example Business Metrics

The semantic layer can define reusable metrics such as:

Total Revenue
= SUM(TOTAL_AMOUNT)

Booking Count
= COUNT(BOOKING_ID)

The purpose is to centralize business logic rather than repeatedly implementing the same calculations in downstream dashboards.

dbt Features Used
Sources
Models
Incremental materializations
ref()
source()
Jinja templating
Custom macros
Model configurations
Semantic models
Measures
Metrics
Time spine
Example Jinja Macro

A reusable multiplication macro was created for transformations:

{% macro multiply(x, y, precision) %}
    round({{ x }} * {{ y }}, {{ precision }})
{% endmacro %}

Example usage:

{{ multiply(NIGHTS_BOOKED, BOOKING_AMOUNT, 2) }}
Project Structure
Staymetrics/
│
├── Staymetrics_data_pipeline/
│   │
│   ├── models/
│   │   └── example/
│   │       └── sources/
│   │           ├── Bronze/
│   │           ├── silver/
│   │           └── Gold/
│   │
│   ├── macros/
│   │
│   ├── seeds/
│   │
│   ├── dbt_project.yml
│   └── ...
│
└── README.md
Running the Project

Create/activate the uv environment:

source /workspaces/Staymetrics/.venv/bin/activate

Install dependencies:

uv pip install -r requirements.txt

Verify dbt:

dbt --version

Validate the project:

dbt parse

Run the pipeline:

dbt run

Run a specific model:

dbt run --select OBT

For an incremental model that has undergone structural changes:

dbt run --select OBT --full-refresh
Validation

The semantic model can be checked with:

dbt ls --resource-type semantic_model

Expected output includes:

semantic_model.Staymetrics_data_pipeline.staymetrics_obt
Key Learning

The main objective of StayMetrics was not simply to build another ETL pipeline.

It was to understand the progression:

Raw Data
   ↓
Reliable Data
   ↓
Transformed Data
   ↓
Analytics-Ready Data
   ↓
Business Definitions
   ↓
Reusable Metrics

This project helped connect data ingestion, transformation, warehouse modeling, and semantic modeling into one end-to-end workflow.

Disclaimer

This is a personal learning project using dummy data. It is not intended to represent a production-scale architecture or real customer data pipeline.
