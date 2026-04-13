#!/usr/bin/env bash

# REPO CONFIGURATION

. /etc/os-release

curl -fsSL \
    "https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-${VERSION_ID}/scottames-ghostty-fedora-${VERSION_ID}.repo" \
    | sudo tee /etc/yum.repos.d/_copr:ghostty.repo > /dev/null

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

rpm-ostree refresh-md

# BREW CONFIGURATION

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# APPLICATIONS LIST

REMOVED=(
    firefox
    firefox-langpacks-143.0.3-1.fc43.x86_64
)

LAYERED=(
    akmod-nvidia
    xorg-x11-drv-nvidia-cuda
    nautilus
    gvfs-smb
    gvfs-mtp
    ddcutil
    distrobox
    ghostty
)

FLATPAK=(
    io.github.kolunmi.Bazaar
    io.gitlab.librewolf-community
    com.github.tchx84.Flatseal
    com.ranfdev.DistroShelf
    com.rtosta.zapzap
    org.signal.Signal
    com.todoist.Todoist
    com.visualstudio.code
    com.bitwarden.desktop
    org.videolan.VLC
    dev.aunetx.deezer
    dev.geopjr.Tuba
    dev.vencord.Vesktop
    io.freetubeapp.FreeTube
    io.missioncenter.MissionCenter
    com.github.IsmaelMartinez.teams_for_linux
    com.valvesoftware.Steam
    com.valvesoftware.Steam.CompatibilityTool.Proton-GE
    org.freedesktop.Platform.VulkanLayer.gamescope
    org.pulseaudio.pavucontrol
    org.filezillaproject.Filezilla
    org.libreoffice.LibreOffice
    org.localsend.localsend_app
    md.obsidian.Obsidian
    org.flameshot.Flameshot
    org.gnome.Boxes
    org.gnome.Calculator
    org.gnome.TextEditor
    org.gnome.clocks
    org.gnome.eog
)

HOMEBREW=(
    ansible
    btop
    fastfetch
    tmux
)

# DEPLOYMENT

rpm-ostree override remove "${REMOVED[@]}"
rpm-ostree install "${LAYERED[@]}"
flatpak install -y --user "${FLATPAK[@]}"
brew install "${HOMEBREW[@]}"

# GAMING PERMISSIONS

flatpak override --user --device=all com.valvesoftware.Steam
flatpak override --user --talk-name=org.freedesktop.Flatpak com.valvesoftware.Steam

# THEME

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
bash WhiteSur-icon-theme/install.sh -a

# DOTFILES

cp -r ./cosmic/com.system76.CosmicBackground "$HOME/.config/cosmic/"
cp -r ./cosmic/com.system76.CosmicAppList "$HOME/.config/cosmic/"
cp -r ./cosmic/com.system76.CosmicTk "$HOME/.config/cosmic/"
cp -r ./cosmic/com.system76.CosmicSettings.Shortcuts "$HOME/.config/cosmic/"
cp ./wallpaper.jpg "$HOME/.config/wallpaper.jpg"
