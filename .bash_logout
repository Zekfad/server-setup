# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
	[ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

echo Goodbye.
echo Logout time: $(date +%c).

if [ ! "$SESSION_START_TS" -gt "0" ]; then
	SESSION_START_TS=$(date +%s)
fi

SESSION_DURATION=$(($(date +%s)-$SESSION_START_TS))

echo Session duration: $(date -u -d @${SESSION_DURATION} +%T)
