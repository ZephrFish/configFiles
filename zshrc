# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HYPHEN_INSENSITIVE="true"

DISABLE_UPDATE_PROMPT="true"

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="[%f/%m/%y] %T [UTC]"

# Plugins for oh-my-zsh 
plugins=(git
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# Aliases
alias zshconfig="nano ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"

# Custom Functions
## Create Logging Function
function precmd() {
echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/zsh-history-$(date "+%Y-%m-%d").log
}

function crtsh(){
        curl -sk "https://crt.sh/?q=%25.$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
}
alias crtsh="crtsh"


# In progress
#export PROMPT_COMMAND='echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/zsh-history-$(date "+%Y-%m-%d").log'
#PROMPT='%{$fg[green]%}[%D{%f/%m/%y} %D{%L:%M:%S}] '$PROMPT


# Timestamps
PROMPT='%{$fg[green]%}[%D{%f/%m/%y}  %T]'$PROMPT
