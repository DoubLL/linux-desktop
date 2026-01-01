#!/bin/bash
# Custom disk usage script showing used/total instead of free space

DIR="${1:-$HOME}"
ALERT_THRESHOLD="${2:-90}" # Alert when used% exceeds 90%

# Get disk usage info
df -h -P -l "$DIR" | awk -v alert_threshold=$ALERT_THRESHOLD '
/\/.*/ {
    used=$3
    total=$2
    use_percent=$5
    
    # Display as used/total
    print used "/" total
    
    # Short text (same as long for clarity)
    print used "/" total
    
    # Parse percentage for alert
    gsub(/%$/,"",use_percent)
    
    # Alert if used percentage exceeds threshold (red at 90%+)
    if (use_percent >= alert_threshold) {
        print "#FF0000"
    }
    
    exit 0
}
'
