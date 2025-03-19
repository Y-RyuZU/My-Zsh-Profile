# oh-my-zsh設定
export ZSH="$HOME/.oh-my-zsh"

# テーマ設定
ZSH_THEME="powerlevel10k/powerlevel10k"

# Powerlevel10k の即時初期化を有効にする
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# abbr関連の出力を抑制

export ABBR_QUIET=1

# シンボリックリンクのパスを取得（より堅牢な方法）
if command -v readlink >/dev/null 2>&1; then
  CURRENT_DIR=$(dirname $(readlink -f $HOME/.zshrc 2>/dev/null || readlink $HOME/.zshrc))
else
  CURRENT_DIR=$(cd $(dirname $HOME/.zshrc) && pwd)
fi

# プラグインの設定
if [ -f "$CURRENT_DIR/plugins.zsh" ]; then
  source $CURRENT_DIR/plugins.zsh
fi

# oh-my-zshを読み込む
source $ZSH/oh-my-zsh.sh

# abbrを個別に読み込む
source $ZSH_CUSTOM/plugins/abbr/abbr.plugin.zsh

# 追加の設定ファイルを読み込む（存在する場合のみ）
[ -f "$CURRENT_DIR/aliases.zsh" ] && source $CURRENT_DIR/aliases.zsh
[ -f "$CURRENT_DIR/environment.zsh" ] && source $CURRENT_DIR/environment.zsh

# カスタムディレクトリの設定
if [ -d "$CURRENT_DIR/custom" ]; then
  for file in $CURRENT_DIR/custom/*.zsh; do
    [ -f "$file" ] && source "$file"
  done
fi

# Powerlevel10kの設定ファイルを読み込む
# まずリポジトリ内のp10k.zshを試し、なければホームディレクトリの設定を使用
if [ -f "$CURRENT_DIR/p10k.zsh" ]; then
  source $CURRENT_DIR/p10k.zsh
elif [ -f "$HOME/.p10k.zsh" ]; then
  source $HOME/.p10k.zsh
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8