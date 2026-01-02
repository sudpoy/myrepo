#!/bin/bash

# Configuration
IDLE_MINUTES=15
CHECK_INTERVAL=300

while true; do
    if git-crypt status | grep -q "encrypted: entries/"; then
        LAST_MOD=$(stat -c %Y entries/ 2>/dev/null || date +%s)
        CURRENT=$(date +%s)
        ELAPSED=$(( (CURRENT - LAST_MOD) / 60 ))

        if [ "$ELAPSED" -ge "$IDLE_MINUTES" ]; then
            # 1. Sync and push
            git add entries/ && git commit -m "Auto-save" && git push
            
            # 2. Lock the files on disk
            git-crypt lock
            
            # 3. CRITICAL: Wipe the passphrase from memory
            gpgconf --kill gpg-agent
            
            echo "Vault Locked and GPG memory wiped at $(date)" >> /tmp/auto-lock.log
        fi
    fi
    sleep $CHECK_INTERVAL
done
