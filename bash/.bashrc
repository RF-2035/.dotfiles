# ┌───────────┐
# │ ~/.bashrc │
# └───────────┘

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ┌─────────────────┐
# │ Prompt & Colors │
# └─────────────────┘

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
PS1='\e[32;1m\u@\h: \e[36m\W\e[0m\$ '

# ┌───────────────┐
# │ Shell Options │
# └───────────────┘
#  - autocd - change directory without entering the 'cd' command
#  - cdspell - automatically fix directory typos when changing directory
#  - direxpand - automatically expand directory globs when completing
#  - dirspell - automatically fix directory typos when completing
#  - globstar - ** recursive glob
#  - histappend - append to history, don't overwrite
#  - histverify - expand, but don't automatically execute, history expansions
#  - nocaseglob - case-insensitive globbing
#  - no_empty_cmd_completion - do not TAB expand empty lines
shopt -s autocd cdspell direxpand dirspell globstar histappend histverify \
    nocaseglob no_empty_cmd_completion

# ┌─────────┐
# │ History │
# └─────────┘

export HISTTIMEFORMAT='%s '
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# ┌──────────────────┐
# │ conda initialize │
# └──────────────────┘

# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# ┌─────┐
# │ fzf │
# └─────┘

# [[ $- == *i* ]] && source /usr/share/blesh/ble.sh
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# ┌─────────────────┐
# │ bash-completion │
# └─────────────────┘

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
