#!/bin/bash

# 既存のインストール部分
# oh-my-zshがインストールされていなければインストール
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zshをインストールします..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# バックアップを作成
if [ -f "$HOME/.zshrc" ]; then
  echo "既存の.zshrcをバックアップします..."
  cp $HOME/.zshrc $HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)
fi

# シンボリックリンクを作成
echo "シンボリックリンクを設定します..."
ln -sf "$(pwd)/zshrc" "$HOME/.zshrc"

# カスタムディレクトリがなければ作成
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  echo "zsh-autosuggestions プラグインをインストールします..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  echo "zsh-syntax-highlighting プラグインをインストールします..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Powerlevel10k テーマのインストール
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "Powerlevel10k テーマをインストールします..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Linux向け Nerd Fonts のインストール（Ubuntu/Debian系）
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ ! -d "$HOME/.local/share/fonts/NerdFonts" ]; then
    echo "Meslo Nerd Fontをインストールしています..."
    mkdir -p "$HOME/.local/share/fonts/NerdFonts"
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o "$HOME/.local/share/fonts/NerdFonts/MesloLGS NF Regular.ttf"
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o "$HOME/.local/share/fonts/NerdFonts/MesloLGS NF Bold.ttf"
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o "$HOME/.local/share/fonts/NerdFonts/MesloLGS NF Italic.ttf"
    curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o "$HOME/.local/share/fonts/NerdFonts/MesloLGS NF Bold Italic.ttf"
    fc-cache -f -v
    echo "フォントをインストールしました。ターミナルの設定でMesloLGS NFフォントを選択してください。"
  fi
fi

echo "インストール完了！新しいシェルを開始するか、source ~/.zshrcを実行してください。"
echo "Powerlevel10kの初期設定は最初のシェル起動時に行われます。"