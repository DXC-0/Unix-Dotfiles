#!/bin/bash

set -e

BREW_APPS=(
    "git"
    "wget"
    "ansible"
    "btop"
    "fastfetch"
)

CASK_APPS=(
    "ghostty"
    "firefox"
    "vesktop"
    "steam"
    "docker-desktop"
    "flameshot"
    "bitwarden"
    "obsidian"
    "tor-browser"
    "localsend"
    "spotify"
    "signal"
    "whatsapp"
    "element"
    "freetube"
    "rectangle"
    "proton-mail"
    "protonvpn"
    "proton-drive"
)


check_homebrew() {
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

update_homebrew() {
    brew update
    brew upgrade
    brew cleanup
}

install_brew_apps() {
    for app in "${BREW_APPS[@]}"; do
        if brew list "$app" &> /dev/null; then
        else
            brew install "$app"
        fi
    done
}

install_cask_apps() {
    for app in "${CASK_APPS[@]}"; do
        if brew list "$app" &> /dev/null; then
        else
            brew install --cask "$app"
        fi
    done
}

remove_quarantine() {
    
    QUARANTINE_APPS=(
        "/Applications/FlameShot.app"
        "/Applications/FreeTube.app"
    )

    for app in "${QUARANTINE_APPS[@]}"; do
        if [[ -e "$app" ]]; then
            sudo xattr -r -d com.apple.quarantine "$app" 2>/dev/null || true
        fi
    done
}

configure_dock() {

    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock orientation -string bottom
    defaults write com.apple.dock persistent-others -array
    killall Dock
}

configure_startup_apps() {

    STARTUP_APPS=(
        "/Applications/FlameShot.app"
        "/Applications/Rectangle.app"
    )
    
    for app in "${STARTUP_APPS[@]}"; do
        if [[ -e "$app" ]]; then
            ln -sf "$app" ~/Library/LoginItems/$(basename "$app") 2>/dev/null || true
        fi
    done
    
}

configure_system_preferences() {
    
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    killall Finder
}


main() {
    
    check_homebrew
    update_homebrew
    install_brew_apps
    install_cask_apps
    configure_dock
    configure_startup_apps
    configure_system_preferences
    remove_quarantine
}

main "$@"