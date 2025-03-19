# oh-my-zsh設定
export ZSH="$HOME/.oh-my-zsh"

# テーマ設定
ZSH_THEME="powerlevel10k/powerlevel10k"

# Powerlevel10k の即時初期化を有効にする
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zshを読み込む
source $ZSH/oh-my-zsh.sh

# 追加の設定ファイルを読み込む
CURRENT_DIR=$(dirname $(readlink $HOME/.zshrc))
source $CURRENT_DIR/aliases.zsh
source $CURRENT_DIR/environment.zsh
source $CURRENT_DIR/plugins.zsh

# カスタムディレクトリの設定
if [ -d "$CURRENT_DIR/custom" ]; then
  for file in $CURRENT_DIR/custom/*.zsh; do
    [ -f "$file" ] && source "$file"
  done
fi

# Powerlevel10kの設定ファイルを読み込む
[[ ! -f $CURRENT_DIR/p10k.zsh ]] || source $CURRENT_DIR/p10k.zsh