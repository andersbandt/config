# Backup Script

Monthly backup script for Ubuntu that archives the system to an external HDD.

## What it does

- Creates a compressed tarball of your entire system
- Excludes `~/Pictures` and `~/.cache`
- Automatically deletes backups older than 2 weeks
- Checks that the backup drive is mounted before running

## Requirements

- Backup drive mounted at `/mnt/backdrive_1`
- Directory `/mnt/backdrive_1/backup` must exist

## Installation

1. Make the script executable:
   ```bash
   chmod +x /home/anders/Code/bash/backup.sh
   ```

2. Copy the systemd files:
   ```bash
   sudo cp backup.service /etc/systemd/system/
   sudo cp backup.timer /etc/systemd/system/
   ```

3. Enable and start the timer:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now backup.timer
   ```

## Managing the timer

Check timer status:
```bash
systemctl status backup.timer
systemctl list-timers | grep backup
```

Run backup manually:
```bash
sudo systemctl start backup.service
```

View logs:
```bash
journalctl -u backup.service
```

Disable the timer:
```bash
sudo systemctl disable --now backup.timer
```

## Notes

- `Persistent=true` ensures missed backups run at next boot if the PC was off
- `RandomizedDelaySec=1h` adds a random delay up to 1 hour to avoid running immediately at boot

---

# Raspberry Pi Backup Script

Lightweight backup script for Raspberry Pi that only backs up home directory and system configs.

## What it backs up

- `/home/pi` — user files
- `/etc/systemd/system` — custom services
- `/etc/cron.d`, `/etc/crontab` — scheduled jobs
- `/etc/fstab`, `/etc/hosts`, `/etc/hostname` — system identity
- `/etc/network`, `/etc/wpa_supplicant` — network/wifi config
- `/etc/apt/sources.list.d` — custom apt repos
- `/opt` — manually installed software

## Setup on Pi

1. Copy the script to your Pi:
   ```bash
   scp backup-pi.sh pi@<pi-ip>:~/
   ```

2. Make it executable:
   ```bash
   chmod +x ~/backup-pi.sh
   ```

3. Edit the script to set your USB mount point (default is `/mnt/usb`):
   ```bash
   nano ~/backup-pi.sh
   ```

4. Test it:
   ```bash
   sudo ./backup-pi.sh
   ```

## Scheduling with anacron

Since Pis often get powered off, use anacron instead of cron:

```bash
# Add to /etc/anacrontab
@monthly 10 pi-backup /home/pi/backup-pi.sh
```

## Restoring

```bash
# Extract everything
sudo tar xzvf pi-backup-2024-01-15.tar.gz -C /

# Or extract specific paths
sudo tar xzvf pi-backup-2024-01-15.tar.gz -C / home/pi
sudo tar xzvf pi-backup-2024-01-15.tar.gz -C / etc/systemd/system
```
