# 1. Stop the KDE Daemon service
systemctl --user stop plasma-kded6
pkill kded6

# 2. Kill your shell and legacy bridge
pkill -f noctalia-shell
pkill -f snixembed

# 3. Start snixembed
snixembed &

# 4. Wait a split second for the bus to settle
sleep 1

# 5. Start Noctalia
noctalia-shell & disown
