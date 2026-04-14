# ┌───────────┐
# │ ~/.bashrc │
# └───────────┘

if [[ -n "$TERMUX_VERSION" ]]; then
    _BIN_PATH="$PREFIX/bin"
    _SHARE_PATH="$PREFIX/share"
    _ETC_PATH="$PREFIX/etc"
else
    _BIN_PATH="/usr/bin"
    _SHARE_PATH="/usr/share"
    _ETC_PATH="/etc"
fi

if [ "$EUID" -eq 0 ] && [[ -z "$TERMUX_VERSION" ]]; then
    _HOME_PATH="/home/$(logname)"
else
    _HOME_PATH="$HOME"
fi

export PATH="${_HOME_PATH}/.local/bin:$PATH"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

export SHELL="${_BIN_PATH}/bash"
export EDITOR="${_BIN_PATH}/nvim"
export VISUAL="${_BIN_PATH}/nvim"

export NNN_TRASH=1

export QT_STYLE_OVERRIDE=kvantum

if [ "$XDG_SESSION_TYPE" = 'wayland' ]; then
    export QT_QPA_PLATFORM=wayland
    # export QT_WAYLAND_DECORATION=adwaita
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ┌─────────────────┐
# │ Prompt & Colors │
# └─────────────────┘

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
# PS1='[\u@\h \W]\$ '
# PS1='\[\e[32;1m\]\u@\h: \[\e[36m\]\W\[\e[0m\]\$ '
PS1='\[\e[38;2;46;194;126;1m\]\u@\h: \[\e[38;2;10;185;220;1m\]\W\[\e[0m\]\$ '

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
# │ nnn │
# └─────┘

nds() {
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    command nnn "$@"
    NNN_RETURN_DIR=""
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        NNN_RETURN_DIR="$PWD"
        rm -f -- "$NNN_TMPFILE" >/dev/null
    }
}

# ┌─────┐
# │ fzf │
# └─────┘

eval "$(fzf --bash)"

# ┌─────────────────┐
# │ bash-completion │
# └─────────────────┘

if ! shopt -oq posix; then
    if [ -f "${_SHARE_PATH}/bash-completion/bash_completion" ]; then
        . "${_SHARE_PATH}/bash-completion/bash_completion"
    elif [ -f "${_ETC_PATH}/bash_completion" ]; then
        . "${_ETC_PATH}/bash_completion"
    fi
fi
