# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER=$(whoami)
# ZSH_THEME="random"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  common-aliases
  last-working-dir
  zsh-syntax-highlighting
  kubectl
  helm
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Load my (professinal + personal) datas
source ~/Git/git.values

## export
export EDITOR=$editor
export KUBE_EDITOR='${=EDITOR}'
export VAULT_ADDR=$vault_addr
export TERM="xterm-256color"
# add personal repo scripts to PATH
export PATH=$PATH:$personal_git_dir_path/documentation/scripts/bin

## alias
# source $personal_git_dir_path/documentation/scripts/alias.bash
alias ll='ls -l'
alias hashtag="echo \"grep -iv '^\s*[#\;]\|^\s*$'\""
alias post_login='bash $personal_git_dir_path/documentation/scripts/post_login_scripts/startup.sh'
alias ggbn="git branch | grep \* | cut -d ' ' -f2"
alias myaliases='grep ^alias ~/.zshrc'
alias cdoverlord='cd $company_git_dir_path/$overlord_dir'
alias cdinfra='cd $company_git_dir_path/infra'
alias cddoc='cd $personal_git_dir_path/documentation'
alias cdk8s='cdinfra && cd k8s-deployment'
alias new_working_sheet_of_the_the_day="new_working_sheet_of_the_the_day $company_git_dir_path/doc_perso_fatalis/working_sheet_of_the_day"
# zshrc='${=EDITOR} ~/.zshrc'
alias i3config='${=EDITOR} ~/.config/i3/config'
alias backup_i3config='cat ~/.config/i3/config > $personal_git_dir_path/documentation/dot_files/i3_config'
alias backup_zshrc='cat ~/.zshrc > $personal_git_dir_path/documentation/dot_files/.zshrc'
alias color='ccze -A'
alias sshconfig='${=EDITOR} ~/.ssh/config'


## eval
eval $(dircolors $personal_git_dir_path/dircolors-solarized/dircolors.ansi-dark)


# Autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/bin/vault vault