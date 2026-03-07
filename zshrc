# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HYPHEN_INSENSITIVE="true"

DISABLE_UPDATE_PROMPT="true"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="[%f/%m/%y] %T"

# Plugins for oh-my-zsh
plugins=(git
zsh-autosuggestions
zsh-syntax-highlighting
sudo
extract
)

source $ZSH/oh-my-zsh.sh

# zoxide (smarter cd - jump to frequent dirs with 'z')
eval "$(zoxide init zsh)"

# fzf (fuzzy finder - Ctrl+R history, Ctrl+T files)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# User configuration

# Preferred editor
export EDITOR='nano'

# Aliases
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"

# Custom Functions
function crtsh(){
        curl -sk "https://crt.sh/?q=%25.$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Styx Aliases
alias ls='eza'
alias l.='eza -d .*'
alias ll='eza -la'
alias lt='eza -1 --sort=size'
alias cat='bat --pager=never'
alias filesize='wc -c'
alias bc='bc -l'
alias diff='colordiff'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias c="clear"

# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'


# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

function rcons
{
    netstat -tn | awk '{print $5}' | grep -Ev '(localhost|\*\:\*|Address|and|servers|fff|127\.0\.0)'
}

# Add an "chk" point, so you can return to a directory that you are jumping back and forth from.
alias chk="echo No check point set: chkset to set checkpoint"
alias chkdel='unalias chk && alias chk="echo No check point set: chkset to set checkpoint"'



fuck() { sudo $(fc -ln -1) }

# Additional Functions
function mkcd() { mkdir -p "$1" && cd "$1" }
function myip() { curl -s ifconfig.me && echo }
function listening() { ss -tlnp 2>/dev/null || lsof -iTCP -sTCP:LISTEN -P -n }

# "chkset" sets the current directory as a check point
# "chkdel" clears the set check point and returns it to blank
# "chk"    moves you to the check point
function chkset
{
    c=$(pwd)
    alias chk="cd $c"
}
