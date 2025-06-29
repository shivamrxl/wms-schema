# 🏭 Warehouse Management System (WMS) – Database Engineer Submission

## 📌 Overview
This repository contains a normalized relational schema and sample analytical SQL queries designed for a scalable Warehouse Management System.

## 🗃️ Tables

| Table         | Description                                 |
|---------------|---------------------------------------------|
| `products`    | Stores SKU details and unit price           |
| `clients`     | Stores customer/company data                |
| `inventory`   | Tracks current stock per product            |
| `orders`      | Order header information                    |
| `order_items` | Line items belonging to each order          |

## ✅ Design Principles

- Normalization: 3rd Normal Form (3NF) to avoid redundancy
- Data Integrity: Foreign keys enforce strict relationships
- Performance: Indexed on commonly searched fields (e.g., product_id, order_date)

## 📊 Sample Queries Included

1. Current Stock Value – calculates inventory value per product
2. Recent Orders – shows last 30 days' order activity with totals
3. Top-Selling Products – aggregates order_items to rank products

## ▶️ How to Use

```bash
createdb wmsdb
psql -U <your-username> -d wmsdb -f wms_schema.sql
```

Replace <your-username> with your PostgreSQL user.

## 👤 Author

Shivam Kumar  
GitHub: [shivamrxl](https://github.com/shivamrxl)  
Date: June 2025