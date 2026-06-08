# README

## Project Overview

This repository implements a **FIFO/LIFO warehouse management system** built with **Ruby on Rails**. The application provides a full‑stack solution for tracking inventory items, handling receiving and shipment processes, and generating various stock reports. It follows the [lintity gem](https://github.com/fatshinobi/lintity) architecture pattern.
The project applies FILFO LIFO logic implementation in [acts_as_fifo_lifo gem](https://github.com/fatshinobi/acts_as_fifo_lifo)

Key capabilities include:

* **Item catalog** – CRUD operations for items stored in the warehouse.
* **Storage locations** – Manage multiple storages with location metadata.
* **Receiving workflow** – Record incoming stock, automatically update item quantities, and maintain receiving items.
* **Shipment workflow** – Process outgoing shipments, adjust stock levels, and track shipment items.
* **Transfer workflow** – Move stock between storages while preserving FIFO/LIFO rules.
* **Reporting** – Generate basic stock balance reports and detailed entity reports (e.g., stock movement, inventory transactions) using the `Lintity::EntityReportController` conventions.
* **Background processing** – Recalculation jobs run asynchronously to keep stock states consistent.

## Demo video
  * FIFO logic:
[![FIFO logic](https://github.com/user-attachments/assets/4b9b139e-95d4-47ee-a849-96f46a32ed0b)](https://www.youtube.com/watch?v=Wm-CKXMB9Wg)

  * LIFO logic:
[![LIFO logic](https://github.com/user-attachments/assets/c1f48249-81a4-4411-9643-0b9f3234f6ec)](https://www.youtube.com/watch?v=eTGfoYHL3V4)

  * Recalculation feature:
[![Recalculation feature](https://github.com/user-attachments/assets/c90ed762-8899-40d4-b4fb-047ed6786128)](https://www.youtube.com/watch?v=UXhjoJGGBEk)

## Application features
* **Item catalog**

| List | Form |
| --- | --- | --- |
| [![Items List](https://github.com/user-attachments/assets/dd0a71c3-c117-46d4-b20f-9c5d0e6a3386)](https://github.com/user-attachments/assets/fe851348-32a5-400e-b42d-79d73e08a5a4) | [![Item Form](https://github.com/user-attachments/assets/2103e3c6-9c23-4492-b52b-bfefeee6976a)](https://github.com/user-attachments/assets/e4fff78c-f986-4b4f-81c0-ab80484152f4) |

* **Storage locations**
* **Receiving workflow**
* **Shipment workflow**
* **Transfer workflow**
* **Reporting**

## Getting Started

* **Ruby version** – See `.ruby-version`.
* **System dependencies** – MySQL

For detailed contribution guidelines, see the `CONTRIBUTING.md` file.

