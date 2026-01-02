#!/bin/bash

# Configuration: Minutes of inactivity before locking
IDLE_TIME=15

while true; do
    # Find the most recently accessed file in the entries directory
    LAST_ACCESS=$(find entries -type f -printf '%X\n' 2>/dev/null | sort -nr | head -n1)
    
    if [ -n "$LAST_ACCESS" ]; then
        CURRENT_TIME=$(date +%s)
        ELAPSED=$(( (CURRENT_TIME - LAST_ACCESS) / 60 ))

        if [ "$ELAPSED" -ge "$IDLE_TIME" ]; then
            # Lock the repository
            git-crypt lock
            echo "Security: Vault auto-locked due to $IDLE_TIME minutes of inactivity."
        fi
    fi
    # Check every 5 minutes
    sleep 300
done
