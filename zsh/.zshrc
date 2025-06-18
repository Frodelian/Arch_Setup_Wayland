if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Установщик плагинов
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Автоматическая проверка наличия zinit и установка если zinit нету 
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source ~/.local/share/zinit/zinit.git/zinit.zsh

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Поцветка синтаксиза 
zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'   # sudo без underline
ZSH_HIGHLIGHT_STYLES[path]='fg=blue'          # пути без underline

# На таб посмотреть какие команды могут быть 
zinit light zsh-users/zsh-completions 
autoload -U compinit && compinit

# Фишка из fish
zinit load zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Автодополнение по истории 
zinit light zsh-users/zsh-autosuggestions
HISTSIZE=110000
HISTFILE=~/.config/zsh/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt correct                    # Автокоррекция команд
setopt extendedglob               # Расширенный globbing
setopt nocaseglob                 # Глоббинг без учёта регистра
setopt numericglobsort            # Числовая сортировка файлов
setopt nobeep                     # Без звукового сигнала
setopt appendhistory              # Добавлять в историю, не перезаписывать
setopt inc_append_history         # Немедленно сохранять команды в файл истории
setopt sharehistory               # Общая история между терминалами
setopt hist_ignore_all_dups       # Удалять все дубликаты команд
setopt hist_save_no_dups          # Не сохранять дубликаты в файл истории
setopt hist_ignore_dups           # Не сохранять подряд идущие дубликаты
setopt hist_find_no_dups          # Не показывать дубликаты при поиске

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down
bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[OA' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down
bindkey -M vicmd '^[OB' history-substring-search-down
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[OA' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M viins '^[OB' history-substring-search-down

# Для поиска в fzf 
bindkey '^j' history-search-forward # ctrl + j 
bindkey '^k' history-search-backward # ctrl + k

# Aliases
alias ls='ls --color'
alias df="duf"  
alias lf='/bin/lfub' 
if [ -x "$(command -v exa)" ]; then
    alias la="exa --long --all --group"
fi 

alias vim='nvim'
alias clear='echo -ne "\033c"' # для того чтобы clear всё очищал 
# alias clear='clear && tmux clear-history' # для того чтобы clear вс очищал в tmux

# ctrl + shift + r
eval "$(fzf --zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

