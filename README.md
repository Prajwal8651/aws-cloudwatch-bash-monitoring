# 📊 AWS EC2 Monitoring System using Bash & CloudWatch

## 📌 Overview

This project demonstrates a **real-world server monitoring solution** built using **Bash scripting** and **AWS CloudWatch**.
It continuously monitors **CPU, Memory, and Disk usage** of a Linux EC2 instance and automatically sends **email alerts** when usage crosses defined thresholds.

The solution uses **custom CloudWatch metrics**, **CloudWatch alarms**, and **Amazon SNS**, making it a lightweight yet production-relevant monitoring system.

---

## 🎯 Key Objectives

* Monitor system-level metrics on a Linux server
* Publish custom metrics to AWS CloudWatch
* Trigger alerts when thresholds are breached
* Automate metric collection using cron
* Gain hands-on experience with AWS monitoring services

---

## 🏗 High-Level Architecture

```
EC2 (Linux Server)
   |
   |-- Bash Script (CPU, Memory, Disk)
   |
CloudWatch Custom Metrics
   |
CloudWatch Alarms
   |
Amazon SNS
   |
Email Notifications
```

---

## 🧰 Tech Stack

* **AWS EC2** – Linux server
* **Bash** – Metric collection
* **AWS CloudWatch** – Monitoring & alarms
* **Amazon SNS** – Email notifications
* **AWS CLI** – AWS interaction
* **Cron (cronie)** – Automation

---

## 📂 Repository Structure

```
aws-cloudwatch-bash-monitoring/
├── monitoring.sh        # Bash script for metric collection
├── README.md            # Project documentation
```

---

## 🚀 Step-by-Step Implementation

---

## Step 1: EC2 Setup

* Launch an **Amazon Linux 2** EC2 instance
* Instance type: `t2.micro`
* Enable SSH (port 22)
* Connect using SSH

```bash
ssh -i key.pem ec2-user@<public-ip>
```

---

## Step 2: Install Dependencies

```bash
sudo yum update -y
sudo yum install -y awscli
```

Verify:

```bash
aws --version
```

---

## Step 3: Configure AWS CLI

```bash
aws configure
```

Provide:

* Access Key & Secret Key
* Region (e.g., ap-south-1)
* Output format: json

Verify identity:

```bash
aws sts get-caller-identity
```

---

## Step 4: Create Monitoring Script

Create file:

```bash
vi monitoring.sh
```

```bash
#!/bin/bash

CPU=$(top -bn1 | awk '/Cpu/ {print 100-$8}')
MEM=$(free | awk '/Mem/ {print ($3/$2)*100}')
DISK=$(df / | awk 'END {print $5}' | sed 's/%//')

aws cloudwatch put-metric-data \
--namespace "Custom/ServerMonitoring" \
--metric-data \
MetricName=CPUUsage,Value=$CPU,Unit=Percent \
MetricName=MemoryUsage,Value=$MEM,Unit=Percent \
MetricName=DiskUsage,Value=$DISK,Unit=Percent
```

Make executable:

```bash
chmod +x monitoring.sh
```

Test manually:

```bash
./monitoring.sh
```

---

## Step 5: Verify Metrics in CloudWatch

Path:

```
CloudWatch → Metrics → All metrics → Custom namespaces → Custom/ServerMonitoring
```

Metrics visible:

* CPUUsage
* MemoryUsage
* DiskUsage

---

## Step 6: Create SNS Topic

* Create SNS topic: `server-alerts`
* Add email subscription
* Confirm subscription via email

---

## Step 7: Configure CloudWatch Alarms

| Metric      | Threshold | Alarm Name      |
| ----------- | --------- | --------------- |
| CPUUsage    | > 70%     | HighCPUUsage    |
| MemoryUsage | > 75%     | HighMemoryUsage |
| DiskUsage   | > 80%     | HighDiskUsage   |

* Period: 5 minutes
* Notification: SNS email alert

---

## Step 8: Automate Using Cron

Install cron:

```bash
sudo yum install -y cronie
```

Enable service:

```bash
sudo systemctl start crond
sudo systemctl enable crond
```

Add cron job:

```bash
crontab -e
```

```bash
*/5 * * * * /home/ec2-user/monitoring.sh >> /home/ec2-user/monitor.log 2>&1
```

---

## Step 9: Testing & Validation

Generate CPU load:

```bash
yes > /dev/null &
```

Expected:

* Alarm state → **In alarm**
* Email notification received

Stop load:

```bash
killall yes
```

Alarm returns to **OK**.

---

## ⚠️ Troubleshooting

### Alarm shows *Insufficient data*

* Cron not running
* Script not executed
* EC2 restarted

Verify:

```bash
crontab -l
sudo systemctl status crond
```

---

## ✅ Final Outcome

* Fully automated monitoring
* Custom CloudWatch metrics
* Real-time alerts
* Production-style AWS monitoring setup

---

## 🧠 Interview Explanation (Concise)

> “I implemented a Linux server monitoring solution using Bash and AWS CloudWatch. The script collects CPU, memory, and disk metrics and publishes them as custom metrics. CloudWatch alarms trigger SNS email alerts when thresholds are breached, and the system runs automatically using cron.”

---

## 📌 Resume Bullet Point

* Designed and implemented an EC2 monitoring system using Bash and AWS CloudWatch with automated SNS email alerts and cron-based metric collection.

---

## 🔮 Future Enhancements

* Slack / Teams notifications
* Terraform automation
* Log-based monitoring
* Multi-instance monitoring
* Auto-remediation scripts

---

## 🏁 Project Status

✅ **Completed & Production-Ready**

---
