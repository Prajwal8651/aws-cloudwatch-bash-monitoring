#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100}')
DISK=$(df / | awk 'END{print $5}' | sed 's/%//')

aws cloudwatch put-metric-data \
--namespace "Custom/ServerMonitoring" \
--metric-data \
MetricName=CPUUsage,Value=$CPU,Unit=Percent \
MetricName=MemoryUsage,Value=$MEM,Unit=Percent \
MetricName=DiskUsage,Value=$DISK,Unit=Percent
