# S3_Terraform


Here's a clean, human-readable `README.md` document for your GitHub project that organizes both **Module 1** and **Module 2** clearly, using plain language and no special formatting. You can copy this into your GitHub repo:

---

# Gateway DataSecure Inc. - Secure Document Storage & Web Upload System

This project implements a secure, scalable document storage system and a browser-based file upload interface for Gateway DataSecure Inc., a cybersecurity firm that handles sensitive client data. The solution is split into two modules:

---

## 🔐 Module 1: Secure Document Storage System

### Objective

To design a secure Amazon S3-based document storage solution meeting regulations like HIPAA and GDPR using Infrastructure as Code (Terraform), with the following features:

* Encryption at rest (SSE-KMS) and in transit (HTTPS)
* Data lifecycle management for cost optimization
* Versioning and cross-region replication
* Monitoring using AWS CloudTrail

---

### Tasks Completed

#### ✅ Task 1: Secure S3 Bucket

* Created bucket: `gateway-datasecure-inc-docs-XXXX` in `us-east-1`
* Enabled **SSE-KMS** encryption using a customer-managed key with rotation

