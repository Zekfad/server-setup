# ls aliases
alias lls='ls --color=auto -1lpA'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# leave and clear logs
alias leave='rm -f ~/.bash_history && history -cw && exit'

# alias rm='rm -i'

# Windows-like aliases
alias cls='clear'
alias cd..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# tmux
alias tls='tmux list-sessions'
alias tn='tmux new-session -t'
alias ta='tmux attach -t'
