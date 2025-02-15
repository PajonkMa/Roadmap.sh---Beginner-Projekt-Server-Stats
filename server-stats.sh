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

echo "🚨 Security Status: SSH Failures & Banned IPs 🚨"

# ✅ 1️⃣ Gebannte IPs in den letzten 24 Stunden
BANNED_IPS_24H=$(sudo grep "Ban" /var/log/auth.log | grep "$(date --date='yesterday' '+%b %d')" | wc -l)
echo "❌ Banned IPs in the last 24h: $BANNED_IPS_24H"

# ✅ 2️⃣ Fehlgeschlagene SSH-Login-Versuche in den letzten 24 Stunden
FAILED_LOGINS_24H=$(sudo grep "Failed password" /var/log/auth.log | grep "$(date --date='yesterday' '+%b %d')" | wc -l)
echo "🔑 Failed SSH logins in the last 24h: $FAILED_LOGINS_24H"

# ✅ 3️⃣ Letzter Login-Zeitpunkt holen
LAST_LOGIN_TIME=$(last -n 2 -F | awk 'NR==2 {print $4, $5, $6, $7, $8}')
echo "⏳ Last login was on: $LAST_LOGIN_TIME"

# ✅ 4️⃣ Gebannte IPs seit letztem Login
BANNED_SINCE_LAST_LOGIN=$(sudo awk -v lastlogin="$LAST_LOGIN_TIME" '$0 ~ lastlogin,0 {if ($0 ~ /Ban/) count++} END {print count+0}' /var/log/auth.log)
echo "🚫 Banned IPs since last login: $BANNED_SINCE_LAST_LOGIN"

# ✅ 5️⃣ Fehlgeschlagene Logins seit letztem Login
FAILED_SINCE_LAST_LOGIN=$(sudo awk -v lastlogin="$LAST_LOGIN_TIME" '$0 ~ lastlogin,0 {if ($0 ~ /Failed password/) count++} END {print count+0}' /var/log/auth.log)
echo "❗ Failed SSH logins since last login: $FAILED_SINCE_LAST_LOGIN"

echo ""

echo "📦 Checking for package updates..."

# Prüfen, ob Updates verfügbar sind
UPDATES=$(sudo apt list --upgradable 2>/dev/null | grep -c "upgradable")

# Falls Updates verfügbar sind, zeige die Anzahl und den Update-Befehl
if [ "$UPDATES" -gt 0 ]; then
    echo "✅ $UPDATES updates available!"
    echo "💡 To update, run:"
    echo -e "\033[1;32m sudo apt update && sudo apt upgrade -y \033[0m"
else
    echo "🎉 System is up to date!"
fi

echo ""
