# Property Rental Management System (MySQL)

## 📌 Project Overview
This project is a **relational database system** for managing property rentals.  
It handles:
- Property owners and tenants
- Lease agreements
- Rent payments
- Maintenance requests
- Agents managing properties

## 🗂 Database Schema
- **owners** → Property owners  
- **tenants** → People renting properties  
- **properties** → Property details (address, type, rent, status)  
- **leases** → Lease agreements linking tenants and properties  
- **payments** → Records of rent payments  
- **maintenance_requests** → Service/repair requests from tenants  
- **property_images** → Property listing images  
- **agents** and **agent_properties** → Agents managing properties (M:N)

## ⚙️ How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/iampunit123/week-8-database-assignment-final-.git
   cd property-rental-db
   Import the SQL file into MySQL:
   mysql -u your_username -p < property_rental_db.sql
✅ Constraints & Relationships

One-to-Many: owners → properties

One-to-Many: properties → leases → payments

Many-to-Many: agents ↔ properties

Constraints:

Lease end date must be greater than start date

Unique emails for owners/tenants/agents

📅 Submission Info

Assignment: Database Management System

Student Name: punit mugoh


