#!/bin/bash

# Zshがインストールされているか確認し、なければインストール
if ! command -v zsh &> /dev/null; then
  echo "Zshがインストールされていません。インストールを開始します..."

  # OS種別に応じたインストールコマンドを実行
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &> /dev/null; then
      echo "Ubuntu/Debian系OSを検出しました。Zshをインストールします..."
      sudo apt update && sudo apt install -y zsh
    elif command -v dnf &> /dev/null; then
      echo "Fedora系OSを検出しました。Zshをインストールします..."
      sudo dnf install -y zsh
    elif command -v yum &> /dev/null; then
      echo "RHEL/CentOS系OSを検出しました。Zshをインストールします..."
      sudo yum install -y zsh
    elif command -v pacman &> /dev/null; then
      echo "Arch Linux系OSを検出しました。Zshをインストールします..."
      sudo pacman -S --noconfirm zsh
    else
      echo "サポートされていないLinuxディストリビューションです。"
      echo "手動でZshをインストールしてから再実行してください。"
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &> /dev/null; then
      echo "macOSを検出しました。Homebrewを使用してZshをインストールします..."
      brew install zsh
    else
      echo "Homebrewがインストールされていません。"
      echo "Homebrewをインストールしますか？ (y/n)"
      read -r install_homebrew
      if [[ "$install_homebrew" == "y" ]]; then
        echo "Homebrewをインストールしています..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if command -v brew &> /dev/null; then
          echo "Homebrewをインストールしました。Zshをインストールしています..."
          brew install zsh
        else
          echo "Homebrewのインストールに失敗しました。"
          echo "https://brew.sh/ からHomebrewをインストール後、再実行してください。"
          exit 1
        fi
      else
        echo "インストールをスキップしました。"
        echo "手動でZshをインストールしてから再実行してください。"
        exit 1
      fi
    fi
  else
    echo "サポートされていないOSです。手動でZshをインストールしてから再実行してください。"
    exit 1
  fi

  # インストール結果を確認
  if ! command -v zsh &> /dev/null; then
    echo "Zshのインストールに失敗しました。手動でインストールしてから再実行してください。"
    exit 1
  else
    echo "Zshが正常にインストールされました。"
  fi
fi

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

# zsh-abbrプラグインのインストール
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-abbr" ]; then
  echo "zsh-abbr プラグインをインストールします..."
  git clone https://github.com/olets/zsh-abbr ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-abbr
fi

# history-substring-search（必要な場合）
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/history-substring-search" ]; then
  echo "history-substring-search プラグインをインストールします..."
  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-substring-search
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

# デフォルトシェルをZshに設定
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "デフォルトシェルをZshに設定します..."

  # Zshのパスを取得
  ZSH_PATH=$(which zsh)

  # /etc/shellsにZshのパスが登録されているか確認し、なければ追加を試みる
  if [[ -f /etc/shells ]]; then
    if ! grep -q "$ZSH_PATH" /etc/shells; then
      echo "Zshのパス($ZSH_PATH)を/etc/shellsに追加します..."
      echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null || {
        echo "警告: /etc/shellsにZshのパスを追加できませんでした。"
        echo "root権限で以下のコマンドを実行してください:"
        echo "echo $ZSH_PATH >> /etc/shells"
      }
    fi
  fi

  # デフォルトシェルを変更
  if command -v chsh &> /dev/null; then
    echo "シェルを$ZSH_PATHに変更します..."
    echo "シェルを変更するにはパスワードが必要かもしれません。"
    chsh -s "$ZSH_PATH" || {
      echo "chshコマンドでエラーが発生しました。"
      echo "手動で以下のコマンドを実行してください："
      echo "chsh -s $ZSH_PATH"
    }
  else
    echo "chshコマンドが見つかりません。手動でシェルを変更するには："
    echo "chsh -s $ZSH_PATH"
  fi
else
  echo "既にZshがデフォルトシェルとして設定されています。"
fi

echo "インストール完了！新しいシェルを開始するか、source ~/.zshrcを実行してください。"
echo "Powerlevel10kの初期設定は最初のシェル起動時に行われます。"