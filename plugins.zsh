# oh-my-zshプラグイン設定
plugins=(
  git
  docker
  docker-compose
  npm
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  sudo
  web-search
  extract
  colored-man-pages
)

# プラグイン特有の設定
# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8f8f8f"

# history-substring-search キーバインド
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down