# ClamAV Scan with Telegram Alerts

This script automates ClamAV antivirus scanning on Linux servers and integrates with Telegram for real-time notifications.

## ✨ Features
	•	Runs a recursive scan on specified directories.
	•	Automatically quarantines infected files into a safe folder.
	•	Sends a Telegram message with the full scan summary.
	•	Sends an urgent alert if infected files are detected.
	•	Self-healing: creates required log and quarantine folders if missing.

## 🔧 Requirements
	•	Linux server with clamscan (ClamAV) installed.
	•	A Telegram bot token and chat ID (from BotFather).
	•	Config files for storing secrets and paths (kept outside Git):
	•	/etc/7heaven/telegram_bot.conf
	•	/etc/7heaven/clamav_scan.conf

## 📂 Example Config Files

/etc/7heaven/telegram_bot.conf

```bash
BOT_TOKEN=your_telegram_bot_token_here
CHAT_ID=your_chat_id_here
```
/etc/7heaven/clamav_scan.conf
```bash
LOG_FILE=/var/log/clamav/daily_scan.log
QUARANTINE_DIR=/opt/1panel/tmp/ClamAV/Infected_Files
SCAN_DIRS="/home /var/www /var/mail /tmp /var/tmp /dev/shm"
```
## 🚀 Usage
1.	Copy the script to /usr/local/bin/clamav_scan.sh.
2.	Make it executable:
~~~bash
chmod +x /usr/local/bin/clamav_scan.sh
~~~

3.	Run manually or add to cron (e.g., daily at 2 AM):
~~~bash
0 2 * * * /usr/local/bin/clamav_scan.sh
~~~


🧪 Testing

To simulate a virus detection, use the harmless EICAR test file:
~~~bash
echo "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*" > /tmp/eicar.com
~~~
On the next scan, the file will be quarantined, and an alert sent to Telegram.

⸻
