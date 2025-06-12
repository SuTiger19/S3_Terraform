# S3_Terraform



# Gateway DataSecure Inc. - Secure Document Storage & Web Upload System

This project implements a secure, scalable document storage system and a browser-based file upload interface for Gateway DataSecure Inc., a cybersecurity firm that handles sensitive client data. The solution is split into two modules:

---

##  Module 1: Secure Document Storage System

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

#### ✅ Task 2: Bucket Policy

* Enforced HTTPS-only access via bucket policy
* Granted permissions to the provided `LabRole`

#### ✅ Task 3: Lifecycle Management

* Transition to **Standard-IA** after 30 days
* Transition to **Glacier** after 90 days

