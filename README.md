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
* **Dashboard**

[![Dashboard](https://github.com/user-attachments/assets/958616ec-34e3-449d-bef8-d7df3996e7e7)](https://github.com/user-attachments/assets/4f58bc4c-9595-4292-9c61-958963ba2c24)

* **Item catalog**

| List  | Form |
| ------------- | ------------- |
| [![Items List](https://github.com/user-attachments/assets/dd0a71c3-c117-46d4-b20f-9c5d0e6a3386)](https://github.com/user-attachments/assets/fe851348-32a5-400e-b42d-79d73e08a5a4)  | [![Item Form](https://github.com/user-attachments/assets/2103e3c6-9c23-4492-b52b-bfefeee6976a)](https://github.com/user-attachments/assets/e4fff78c-f986-4b4f-81c0-ab80484152f4)  |


* **Storage locations**

| List  | Form |
| ------------- | ------------- |
| [![Storages List](https://github.com/user-attachments/assets/933710ce-df1f-49cf-8b8d-00dc91f3c3e1)](https://github.com/user-attachments/assets/561b736c-5627-4e9d-809f-9982f4834820)  | [![Storage Form](https://github.com/user-attachments/assets/e5a8e44b-5e4e-4a73-9d8d-711ce13e7177)](https://github.com/user-attachments/assets/51b24392-0733-4daa-9775-5fc5a06301ba)  |

* **Receiving workflow**

| List  | Form | Transactions |
| ------------- | ------------- | ------------- |
| [![Receiving List](https://github.com/user-attachments/assets/e3dfed6f-7b87-4dac-8728-9102cc644e32)](https://github.com/user-attachments/assets/a1009ad1-f8a7-4846-9609-d3c922b5b06b)  | [![Receiving Form](https://github.com/user-attachments/assets/677361a3-c800-495a-90fd-b5fc0f1a51ec)](https://github.com/user-attachments/assets/d83662dd-61e8-4d99-a0ab-95d2b6053b44)  | [![Receiving Transactions](https://github.com/user-attachments/assets/7d713f6a-addd-4f4b-975f-10284cf4d671)](https://github.com/user-attachments/assets/aaa62fea-18fd-4b8d-a53a-daf5e7bc8875)  |
* **Shipment workflow**

| List  | Form | Transactions |
| ------------- | ------------- | ------------- |
| [![Shipment List](https://github.com/user-attachments/assets/c489a2d5-3629-4274-9993-08029af5e174)](https://github.com/user-attachments/assets/c4ae4e42-8dcb-4ec4-a3fb-d1bf766a2bb2)  | [![Shipment Form](https://github.com/user-attachments/assets/4a63b4b3-a716-45fb-b0cd-cd95202c09e8)](https://github.com/user-attachments/assets/f1d50759-8f40-4df3-b6aa-aebb12d93deb)  | [![Shipment Transactions](https://github.com/user-attachments/assets/43bb60aa-552e-49fb-b782-b21d44e2c5d2)](https://github.com/user-attachments/assets/b70a2f90-cc7f-4e94-b99d-ac8c10e3edeb)  |
* **Transfer workflow**

| List  | Form | Transactions |
| ------------- | ------------- | ------------- |
| [![Transfer List](https://github.com/user-attachments/assets/068c7fda-831b-4d0f-b236-557f8ada8527)](https://github.com/user-attachments/assets/0a14a719-d9e4-4116-b5f8-fe97571d24a3)  | [![Transfer Form](https://github.com/user-attachments/assets/f7d8f21a-4981-4032-b062-3320734f44a4)](https://github.com/user-attachments/assets/cf37c384-e85e-4c71-81d8-277889cf28b6)  | [![Transfer Transactions](https://github.com/user-attachments/assets/74016408-892b-4e27-b1cd-1e44f58df5c9)](https://github.com/user-attachments/assets/758ade16-2b00-432f-9373-c806e20b69ee)  |
* **Reporting**

| Report  | Filters | Result |
| ------------- | ------------- | ------------- |
| Stock Balance Report  | [![Filters](https://github.com/user-attachments/assets/07d1d6ac-b5e8-40b0-a228-de11e493b6ce)](https://github.com/user-attachments/assets/3197cfac-11fd-400a-8283-ddcceb0273ae)  | [![Result](https://github.com/user-attachments/assets/4db94c74-6f9b-4467-a18b-c6168459d592)](https://github.com/user-attachments/assets/b292fc28-6c64-4133-8db6-290cb56a6cb8)  |
| Basic Stock Balance Report  | [![Filters](https://github.com/user-attachments/assets/73446e3a-3011-4747-addb-1b367de4d3b6)](https://github.com/user-attachments/assets/4de2aed5-9c56-47f2-8146-8178bd3053a7)  | [![Result](https://github.com/user-attachments/assets/cb336408-e479-41df-9418-151d6d7e12ad)](https://github.com/user-attachments/assets/472b0487-2869-4a80-9bd5-4c0922215fb7)  |
| Items Stock Balance Report  | [![Filters](https://github.com/user-attachments/assets/582a1aa1-9ad1-44ae-b246-513b2d1f61bc)](https://github.com/user-attachments/assets/8170e96d-60ec-416d-9d36-5f96c2a5477b)  | [![Result](https://github.com/user-attachments/assets/c79bcfed-9183-4687-8a0e-efb0d04d864a)](https://github.com/user-attachments/assets/b90effb5-35ff-40b6-8dd8-996e3f7c49c3)  |
| Stock Movement Report  | [![Filters](https://github.com/user-attachments/assets/0bdeaaf3-4a25-46b9-9694-6ef7692e5d93)](https://github.com/user-attachments/assets/33e1b1fd-4644-480c-82c3-bb92bac4636a)  | [![Result](https://github.com/user-attachments/assets/0908e857-acf5-4c93-9eeb-c5d20e3549f5)](https://github.com/user-attachments/assets/b7590399-e9b6-40f7-8467-be9d3213157c)  |

## Getting Started

* **Ruby version** – See `.ruby-version`.
* **System dependencies** – MySQL

For detailed contribution guidelines, see the `CONTRIBUTING.md` file.

