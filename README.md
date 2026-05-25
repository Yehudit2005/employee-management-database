# Employee & Attendance Management Database System

A robust, production-ready relational database system designed to manage enterprise human resources, worker attendance, shifting, and automated payroll systems. This project is implemented entirely using **T-SQL** within **Microsoft SQL Server**, focusing on data integrity, automation, and advanced querying techniques.

---

## 🛠️ Core Features

* **Automated Attendance System:** Smart check-in/check-out procedures that dynamically create or update daily attendance logs.
* **Dynamic Wage Calculation:** Programmatic salary calculation based on precise daily work hours and customized worker hourly rates using procedural logic.
* **Role & Department Management:** Subquery-driven employee relocation procedures ensuring modular architecture.
* **Data Integrity Enforcement:** Trigger-based state-machine protection to restrict illegal project status updates and maintain clean analytical views.
* **Comprehensive Executive Reporting:** High-level views abstracting relational complexities for managerial assessment.

---

## 🚀 Advanced T-SQL Techniques Implemented

* **Procedural Database Programming:** Heavy usage of `STORED PROCEDURES` with `OUTPUT` parameters and custom scalar/table-valued `FUNCTIONS`.
* **Control Flow & Error Handling:** Implementation of `WHILE` loops for iterative data manipulation alongside strict `TRY...CATCH` blocks for robust error boundaries.
* **Data Integrity & Triggers:** Automated `AFTER UPDATE` triggers executing state validations and database `ROLLBACK` operations to maintain business rules.
* **Advanced Querying:** Complex reporting scripts leveraging Window Functions (`ROW_NUMBER() OVER (PARTITION BY...)`), `CTE` (Common Table Expressions), `UNION` operations, and `CROSS/OUTER APPLY`.
* **Dynamic SQL & Metadata Inspection:** Advanced metadata automation utilizing `sys.tables` and `sys.columns` paired with `STRING_AGG` to generate dynamic queries at runtime.

---

## 📊 Database Schema Summary

The relational structure consists of the following interconnected tables:
* `Workers` (Central Entity)
* `Departments` & `Roles`
* `Attendance` (Daily clock-in/out tracking)
* `Salaries` (Hourly rate schemas)
* `Projects` (Task and management distribution)
* `Cities` & `ShiftTypes`

---

## 💻 How to Use

1. Clone this repository.
2. Execute the schema generation script in **SQL Server Management Studio (SSMS)**.
3. Use the following core procedures for system interactions:
   * Execute `updateHours` to simulate daily clock-in/out events.
   * Execute `checkSalaryDay` to print payroll calculations for specific dates.
