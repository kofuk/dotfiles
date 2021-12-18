if [ -f "/opt/bin-overrides" ]; then
    PATH="$(sed s/$/:/g /opt/bin-overrides|tr -d \\n)$PATH"
fi
