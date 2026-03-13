# configFiles
Setup and deployment scripts for shell, terminal, and tooling config across hosts.

## Directory Structure

| Directory/File | Purpose |
|---------------|---------|
| `claude/` | Claude Code portability — RAPTOR, SuperClaude, and Lab Controller setup |
| `MacSetup/` | macOS-specific setup |
| `zsh-setup.sh` | Zsh + Oh My Zsh + plugins installer |
| `zshrc` | Zsh config |
| `windowsTerm_profile.json` | Windows Terminal profile |

## Zsh Setup
`zsh-setup.sh` will install zsh and the plugins, along with some other setup :-)

## Windows Terminal Config
I've setup some bits and pieces on my windows terminal env too, included the profile.json for easy config too!


### Setting up Powerlevel Theme
`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k`

### Setting up Font
- https://github.com/microsoft/cascadia-code

### Plugins in use
- zsh-autosuggestions
- zsh-syntax-highlighting


