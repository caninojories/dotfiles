# pongstr ZSH Theme for Oh-My-Zsh
# https://github.com/pongstr/dotfiles
#
# Features:
# - Shows current time with clock emoji
# - Skull emoji indicates command exit status (green=success, red=error)
# - Shows current directory
# - Git branch with dirty/clean status
#
# Requirements: Oh-My-Zsh, Unicode-capable terminal, Nerd Font (optional)

# Exit status indicator (skull changes color based on last command's exit status)
local ret_status="%(?:%{$fg_bold[green]%}💀 :%{$fg_bold[red]%}💀 %s)"

# Main prompt
# Format: ⌚ HH:MM AM/PM
#         💀 directory git:(branch) ✗
PROMPT='⌚  %{$fg_bold[red]%}%t%{$reset_color%}
${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

# Git prompt configuration
ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Optional: Right prompt with user@host (uncomment if desired)
# RPROMPT='%{$fg[green]%}%n@%m%{$reset_color%}'

# Optional: Show full path instead of current directory (change %c to %~)
# PROMPT='⌚  %{$fg_bold[red]%}%t%{$reset_color%}
# ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
