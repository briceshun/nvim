#!/usr/bin/env bash

set -e  # Exit on error

echo "🚀 Setting up development tools..."

# Detect OS
OS="$(uname -s)"

install_lazygit() {
    echo "📦 Installing lazygit..."
    
    case "$OS" in
        Darwin*)
            # macOS
            if command -v brew &> /dev/null; then
                brew install lazygit
            else
                echo "❌ Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        Linux*)
            # Linux
            if command -v apt-get &> /dev/null; then
                # Debian/Ubuntu
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz
            elif command -v pacman &> /dev/null; then
                # Arch Linux
                sudo pacman -S --noconfirm lazygit
            elif command -v dnf &> /dev/null; then
                # Fedora
                sudo dnf copr enable atim/lazygit -y
                sudo dnf install lazygit -y
            else
                echo "❌ Unsupported Linux distribution"
                exit 1
            fi
            ;;
        *)
            echo "❌ Unsupported operating system: $OS"
            exit 1
            ;;
    esac
    
    echo "✅ lazygit installed successfully"
}

install_superfile() {
    echo "📦 Installing superfile..."
    
    case "$OS" in
        Darwin*)
            # macOS
            if command -v brew &> /dev/null; then
                brew install superfile
            else
                echo "❌ Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            ;;
        Linux*)
            # Linux - using the install script from superfile repo
            bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"
            ;;
        *)
            echo "❌ Unsupported operating system: $OS"
            exit 1
            ;;
    esac
    
    echo "✅ superfile installed successfully"
}

# Check if lazygit is already installed
if command -v lazygit &> /dev/null; then
    echo "✓ lazygit is already installed ($(lazygit --version))"
else
    install_lazygit
fi

# Check if superfile is already installed
if command -v spf &> /dev/null; then
    echo "✓ superfile is already installed"
else
    install_superfile
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "You can now use:"
echo "  - lazygit: Run 'lazygit' in any git repository"
echo "  - superfile: Run 'spf' to launch the file manager"
