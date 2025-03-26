#!/bin/bash

export NONINTERACTIVE=1

if ! command -v brew &>/dev/null; then
  print_INFO "Installing Homebrew, an OSX package manager, follow the instructions..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if ! grep -qs "recommended by brew doctor" ~/.zshrc; then
    print_INFO "Put Homebrew location earlier in PATH ..."
      printf '\n# recommended by brew doctor\n' >> ~/.zshrc
      printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.zshrc
      export PATH="/usr/local/bin:$PATH"
  fi

  if ! grep -qs "HomeBrew" ~/.bashrc; then
    printf '\n# HomeBrew\n' >> ~/.bashrc
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
  fi

  if ! grep -qs "HomeBrew" ~/.profile; then
    print_INFO "Put Homebrew into fish profile ..."
    printf '\n# HomeBrew\n' >> ~/.profile
    (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile

    echo "if test -d (brew --prefix)"/share/fish/completions" \
        set -p fish_complete_path (brew --prefix)/share/fish/completions \
    end \
    \
    if test -d (brew --prefix)"/share/fish/vendor_completions.d" \
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d \
    end" > ~/.config/fish/completions/brew.fish
  fi

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

else
  print_INFO "You already have Homebrew installed...good job!"
fi




