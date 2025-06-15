
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

####  Task 1: Secure S3 Bucket

* Created bucket: `gateway-datasecure-inc-docs-XXXX` in `us-east-1`
* Enabled **SSE-KMS** encryption using a customer-managed key with rotation

####  Task 2: Bucket Policy

* Enforced HTTPS-only access via bucket policy
* Granted permissions to the provided `LabRole`

####  Task 3: Lifecycle Management

* Transition to **Standard-IA** after 30 days
* Transition to **Glacier** after 90 days


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

####  Task 1: Secure S3 Bucket

* Created bucket: `gateway-datasecure-inc-docs-XXXX` in `us-east-1`
* Enabled **SSE-KMS** encryption using a customer-managed key with rotation

####  Task 2: Bucket Policy

* Enforced HTTPS-only access via bucket policy
* Granted permissions to the provided `LabRole`

####  Task 3: Lifecycle Management

* Transition to **Standard-IA** after 30 days   
* Transition to **Glacier** after 90 days

##  Module 2: Web-based File Upload Interface

### Objective

To build a user-friendly interface for clients to securely upload files (PDF, DOC, TXT, PPT) directly to the S3 bucket, organized using structured paths and deployed as a static website.

---

### Tasks Completed

####  S3 Static Website Hosting

* Created S3 bucket: `skills-ontario-2025-[yourname]-web`
* Enabled static website hosting
* Deployed static files from `upload_to_s3` folder

####  Application Modifications

* Updated frontend to allow:

  * File selection
  * Input for `Client ID`, `Case ID`, `Document Type`
* Files are uploaded to path format:
  `uploads/{clientId}/{caseId}/{documentType}/{filename}`

####  IaC Deployment

* S3 bucket for static hosting created via Terraform
* Static web files deployed using Terraform `aws_s3_bucket_object`
* Configured CORS and S3 bucket policies for secure upload

---

### 🔧 Modifications Summary Table

| Component        | Change Made                                            | Reason                                                     |
| ---------------- | ------------------------------------------------------ | ---------------------------------------------------------- |
| `index.html`     | Added input fields for client ID, case ID, doc type    | To collect metadata before uploading                       |
| `script.js`      | Set bucket name and upload path structure              | Ensure files are organized and sent to correct S3 location |
| `script.js`      | Used HTTPS and verified MIME types                     | Prevent insecure uploads and validate files                |
| S3 Bucket Policy | Allowed PUT for specific paths with correct conditions | Secure access to uploads directory only                    |
| S3 CORS Config   | Allowed POST/PUT from web app domain                   | Enable secure cross-origin uploads                         |

---

###  Security Discussion

**Risks:**

* Web app initially had **hardcoded credentials**, which could be exposed in browser source.
* Without CORS and strict bucket policies, **unauthorized uploads** could happen.

**Best Practices:**

* Use **pre-signed URLs** to avoid exposing S3 write permissions.
* Use **temporary credentials** from AWS STS instead of hardcoded keys.
* Validate **file types and sizes** in frontend before uploading.



