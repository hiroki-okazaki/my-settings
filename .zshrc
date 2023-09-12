# Set up the prompt
autoload -Uz promptinit
autoload -Uz colors; colors
promptinit

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zinit light zsh-users/zsh-syntax-highlighting ## シンタックスハイライト
## コマンド補完
zinit ice wait'0'; zinit light zsh-users/zsh-completions
# zinit light marlonrichert/zsh-autocomplete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' ## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*:default' menu select=1 ## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zinit light zsh-users/zsh-autosuggestions ## 履歴補完

HISTFILE=$HOME/.zsh_history # 履歴ファイルの保存先
HISTSIZE=100000 # メモリに保存される履歴の件数
SAVEHIST=100000 # HISTFILE で指定したファイルに保存される履歴の件数
setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除します
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_keys # カッコを自動補完
setopt mark_dirs # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt auto_menu # 補完キー連打で順に補完候補を自動で補完
setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word # 語の途中でもカーソル位置で補完
setopt print_eight_bit # 日本語ファイル名を表示可能にする
setopt no_beep # ビープ音を消す
setopt prompt_subst # プロンプトが表示されるたびにプロンプト文字列を評価、置換する
PROMPT='$🐢'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # ファイル補完候補に色を付ける

#------------------- fzf -------------------
export FZF_DEFAULT_OPTS='--height 80% --sort --reverse --border'
# export FZF_TMUX=1
function select-history() {
  BUFFER=$(history -n -r 1 | fzf +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N select-history
bindkey '^r' select-history

#-------------------------------------------

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PIPENV_VERBOSITY=-1
export PIPENV_VENV_IN_PROJECT=1
##

## nodebrew
export PATH=$PATH:/Users/hirokiokazaki/.nodebrew/current/bin

## alias
# alias history='history -t "%F %T " 1'
### kubernetes
alias kc='kubectl'
alias kcd='kubectl describe'
alias kce='kubectl exec -it'
alias kcc='aws eks update-kubeconfig --name'
alias kcg='kubectl get pods --all-namespaces'

### terraform
alias tf='terraform'

### aws-vault
alias ave='aws-vault exec' 
alias aved='aws-vault exec jtp-dev'
alias avep='aws-vault exec jtp-prod'
alias avewp='aws-vault exec welcia-prod'

### aws-vaultでログイン
alias avl='aws-vault login'
alias avlc='(){ open -a "Google Chrome" --args --incognito --user-data-dir=$HOME/Library/Application\ Support/Google/Chrome/aws-vault/$@ $(aws-vault login $@ --stdout) }'

### emission-monitoring
alias aveed='aws-vault exec em-dev-sso --'
alias avees='aws-vault exec em-stg-sso --'
alias aveep='aws-vault exec em-prd-sso --'


### git 系
alias g='git'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gct='git commit'
alias gt='git tag -a $1 -m $2 && git push origin $1'
alias gg='git grep'
alias ga='git add'
alias gd='git diff'
alias gl='git log'
alias gcma='git checkout master'
alias gf='git fetch -p'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gmod='git merge origin/develop'
alias gmud='git merge upstream/develop'
alias gmom='git merge origin/master'
alias gcm='git commit -m'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gst='git stash'
alias gsl='git stash list'
alias gsu='git stash -u'
alias gsp='git stash pop'
alias gga="git log --graph --all --abbrev-commit --date=relative --pretty=format:'%C(red)%h %C(reset)-%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

### その他
alias his='history -t "%F %T " 1'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='vim'
alias vi='vim'
alias so='source'
##

# git のカラー表示
git config --global color.ui auto

# itermのタブにカレントディレクトリを表示
echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
function chpwd() { echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}

# zの導入
zinit load agkozak/zsh-z
