# Configuration files
Save these two files under ``` /etc/7heaven/ ```

telegram_bot.conf
```bash
sample values: 
BOT_TOKEN="123456789:ABCDEF1234567890abcdef"
CHAT_ID="987654321"
```

clamav_scan.conf
```bash
default values:
LOG_FILE="/var/log/clamav/daily_scan.log"
QUARANTINE_DIR="/opt/1panel/tmp/ClamAV/Infected_Files"
SCAN_DIRS="/home /var/www /var/mail /tmp /var/tmp /dev/shm"
```
