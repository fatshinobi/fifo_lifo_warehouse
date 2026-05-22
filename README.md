# README

## Project Overview

This repository implements a **FIFO/LIFO warehouse management system** built with **Ruby on Rails**. The application provides a full‑stack solution for tracking inventory items, handling receiving and shipment processes, and generating various stock reports. It follows the **Lintity** architecture pattern, leveraging custom base controllers such as `Lintity::EntityListController` and `Lintity::EntityReportController` to standardize list and report functionalities across the system.

Key capabilities include:

* **Item catalog** – CRUD operations for items stored in the warehouse.
* **Storage locations** – Manage multiple storages with location metadata.
* **Receiving workflow** – Record incoming stock, automatically update item quantities, and maintain receiving items.
* **Shipment workflow** – Process outgoing shipments, adjust stock levels, and track shipment items.
* **Transfer workflow** – Move stock between storages while preserving FIFO/LIFO rules.
* **Reporting** – Generate basic stock balance reports and detailed entity reports (e.g., stock movement, inventory transactions) using the `Lintity::EntityReportController` conventions.
* **Background processing** – Recalculation jobs run asynchronously to keep stock states consistent.

## Getting Started

* **Ruby version** – See `.ruby-version`.
* **System dependencies** – MySQL

For detailed contribution guidelines, see the `CONTRIBUTING.md` file.

