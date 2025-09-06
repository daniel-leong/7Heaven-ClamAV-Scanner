#!/bin/bash
# ClamAV Scan with Quarantine + Telegram Alert

# Get telegram token and other parameters
source /etc/7heaven/telegram_bot.conf 
source /etc/7heaven/clamav_scan.conf

# Create required files and folder if not already had
# === Pre-checks ===

# Check clamscan exists
if ! command -v clamscan &> /dev/null; then
    echo "❌ ERROR: clamscan not found. Please install ClamAV." >&2
    exit 1
fi

# Ensure BOT_TOKEN and CHAT_ID are set
if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "❌ ERROR: Telegram BOT_TOKEN or CHAT_ID not set. Export them as env vars." >&2
    exit 1
fi

# Ensure quarantine folder exists
if [ ! -d "$QUARANTINE_DIR" ]; then
    mkdir -p "$QUARANTINE_DIR"
    chown clamav:clamav "$QUARANTINE_DIR"
fi

# Ensure log file exists
if [ ! -f "$LOG_FILE" ]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    chown clamav:clamav "$LOG_FILE"
fi

# === Run scan ===
SCAN_OUTPUT=$(/usr/bin/clamscan -ri --move="$QUARANTINE_DIR" \
  --exclude-dir="^/sys" \
  --exclude-dir="^/proc" \
  --exclude-dir="^/dev" \
  $SCAN_DIRS --log="$LOG_FILE")

# Extract summary (last 10 lines typically contain summary)
SUMMARY=$(echo "$SCAN_OUTPUT" | tail -n 10)

# Extract infected count
INFECTED=$(echo "$SUMMARY" | grep "Infected files:" | awk '{print $3}')

# === Post-check ===

# Send Telegram message 
if [ "$INFECTED" -gt 0 ]; then
    MSG="🚨 ClamAV Alert 🚨

Summary:
$SUMMARY

⚠️ $INFECTED infected file(s) were found and moved to:
$QUARANTINE_DIR

Log: $LOG_FILE"
else
    MSG="✅ ClamAV Daily Scan Completed

Summary:
$SUMMARY

No infected files detected."
fi

# Check if infection found
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
      -d chat_id="$CHAT_ID" \
      -d text="$MSG"

