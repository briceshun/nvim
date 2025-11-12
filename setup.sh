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

install_dev_tools() {
    echo "📦 Installing development tools for LazyVim..."
    
    case "$OS" in
        Darwin*)
            if ! command -v brew &> /dev/null; then
                echo "❌ Homebrew not found. Please install Homebrew first."
                exit 1
            fi
            
            # Install ripgrep (rg) for searching
            if ! command -v rg &> /dev/null; then
                echo "  → Installing ripgrep..."
                brew install ripgrep
            fi
            
            # Install fd for file finding
            if ! command -v fd &> /dev/null; then
                echo "  → Installing fd..."
                brew install fd
            fi
            
            # Install fzf for fuzzy finding
            if ! command -v fzf &> /dev/null; then
                echo "  → Installing fzf..."
                brew install fzf
            fi
            
            # Install tree-sitter CLI
            if ! command -v tree-sitter &> /dev/null; then
                echo "  → Installing tree-sitter-cli..."
                brew install tree-sitter-cli
            fi
            
            # Install ImageMagick for image support
            if ! command -v magick &> /dev/null; then
                echo "  → Installing imagemagick..."
                brew install imagemagick
            fi
            
            # Install neovim Python module
            echo "  → Installing neovim Python module..."
            pip3 install --user --upgrade pynvim
            
            # Install neovim Node.js module
            if command -v npm &> /dev/null; then
                echo "  → Installing neovim npm package..."
                npm install -g neovim
            fi
            ;;
        Linux*)
            if command -v apt-get &> /dev/null; then
                echo "  → Installing tools via apt..."
                sudo apt-get update
                sudo apt-get install -y ripgrep fd-find fzf
                
                # tree-sitter
                if ! command -v tree-sitter &> /dev/null; then
                    npm install -g tree-sitter-cli
                fi
            elif command -v pacman &> /dev/null; then
                echo "  → Installing tools via pacman..."
                sudo pacman -S --noconfirm ripgrep fd fzf tree-sitter
            elif command -v dnf &> /dev/null; then
                echo "  → Installing tools via dnf..."
                sudo dnf install -y ripgrep fd-find fzf
            fi
            
            # Install Python neovim module
            pip3 install --user --upgrade pynvim
            
            # Install Node.js neovim module
            if command -v npm &> /dev/null; then
                npm install -g neovim
            fi
            ;;
    esac
    
    echo "✅ Development tools installed successfully"
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

# Install development tools
echo ""
install_dev_tools

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Installed tools:"
echo "  - lazygit: Run 'lazygit' in any git repository"
echo "  - superfile: Run 'spf' to launch the file manager"
echo "  - ripgrep: Fast text search (rg)"
echo "  - fd: Fast file finder"
echo "  - fzf: Fuzzy finder"
echo "  - tree-sitter: Parser generator tool"
echo "  - imagemagick: Image conversion (for terminal images)"
echo ""
echo "📝 Don't forget to:"
echo "  1. Set EDITOR in your shell config: export EDITOR='nvim'"
echo "  2. Restart your terminal or run: source ~/.zshrc"
echo "  3. Run :checkhealth in Neovim to verify everything works"
