#!/bin/bash

echo "-------------------------------"
echo "  SERVER PERFORMANCE STATS  "
echo "-------------------------------"

echo "🕒 System Uptime:"
uptime -p
echo ""

echo "📊 CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU: " $2 "% used"}'

echo "💾 Memory Usage:"
free -h | awk 'NR==2{printf "Used: %s / Total: %s\n", $3, $2}'
echo ""

echo "🖴 Disk Usage:"
df -h | awk '$NF=="/"{printf "Used: %s / Total: %s (%s used)\n", $3, $2, $5}'
echo ""

echo "🔥 Top 5 CPU-consuming processes:"
ps aux --sort=-%cpu | awk 'NR<=6{printf "%-10s %-10s %-10s %s\n", $2, $3, $4, $11}'
echo ""

echo "🧠 Top 5 RAM-consuming processes:"
ps aux --sort=-%mem | awk 'NR<=6{printf "%-10s %-10s %-10s %s\n", $2, $3, $4, $11}'
echo ""

echo "👤 Logged-in Users:"
who
echo ""

echo "❌ Banned IPs in the last 24 hours:"

if sudo test -r /var/log/auth.log; then
    BANNED_IP_COUNT=$(sudo grep "Ban" /var/log/auth.log | grep "$(date --date='yesterday' '+%b %d')" | wc -l)
    echo "Total banned: $BANNED_IP_COUNT"
else
    echo "No permission to read /var/log/auth.log (run as sudo for details)"
fi

echo ""
