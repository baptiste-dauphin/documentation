alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias hashtag="echo \"grep -iv '^\s*[#\;]\|^\s*$'\""
alias post_login="bash ~/Git/documentation/scripts/post_login_scripts/startup.sh"
alias ggbn="git branch | grep \* | cut -d ' ' -f2"

if [ $commands[ccze] ]; then
  alias color="ccze -A"
fi

if [ $commands[subl] ]; then
	alias sshconfig='subl ~/.ssh/config'
fi