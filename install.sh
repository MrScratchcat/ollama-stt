#!/bin/bash
continue=0
echo "1. run ollama locally"
echo "2. run from server"
read -r -p "Option: " choice

if [[ "$choice" == "1" ]]; then
  continue=1
elif [[ "$choice" == "2" ]]; then
  continue=1
fi 

if [[ "$continue" == "0" ]]; then
  echo "didn't make a choice exiting..."
  exit
elif [[ "$continue" == "1" ]]; then
  continue=0
fi

if [[ "$choice" == "1" ]]; then
    curl -fsSL https://ollama.com/install.sh | sh
elif [[ "$choice" == "2" ]]; then
    echo "edit the link in ollama-chat and save changes"
    read -p "If you have changed the file then press enter to continue"
fi 

# Check if the folder exists
if [ ! -d "${HOME}/.ollama-chat" ]; then
    mkdir ${HOME}/.ollama-chat
    mkdir ${HOME}/.ollama-chat/voskmodels
fi

cp *.wav ${HOME}/.ollama-chat
sudo cp ollama-chat /bin
sudo chmod +x /bin/ollama-chat

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        case $ID in
            "ubuntu"|"debian"|"linuxmint"|"pop"|"kubuntu"|"xubuntu"|"elementary"|"zorin"|"ubuntu-mate"|"neon"|"kali"|"ubuntu-studio")
                DISTRO="debian-based"
                ;;
            "fedora")
                DISTRO="fedora"
                ;;
            "opensuse-tumbleweed"|"opensuse-leap")
                DISTRO="opensuse"
                ;;
            "manjaro"|"arch"|"archlinux"|"endeavouros")
                DISTRO="arch"
                ;;
            *)
                echo "Unsupported distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "Unsupported distribution"
        exit 1
    fi
}
detect_distro
echo "installing software..."
if [ "$DISTRO" == debian-based ]; then
    sudo apt update  > /dev/null
    sudo apt install python3 python3-pipx jq python-pipx python zenity mpv sox curl -y > /dev/null
    pipx install vosk edge-tts > /dev/null
elif [ "$DISTRO" == fedora ]; then
    sudo dnf update -y  > /dev/null
    sudo dnf install python3 python3-pipx jq python-pipx python zenity mpv sox curl -y  > /dev/null
    pipx install vosk edge-tts > /dev/null
elif [ "$DISTRO" == arch ]; then
    sudo pacman -Syyu --noconfirm  > /dev/null
    sudo pacman -S python python-pipx jq python-pipx python zenity mpv sox curl --noconfirm > /dev/null
    pipx install vosk edge-tts > /dev/null
elif [ "$DISTRO" == opensuse ]; then
    sudo zypper update
    sudo zypper install python python-pipxjq python-pipx python zenity mpv sox curl -y > /dev/null
    pipx install vosk edge-tts > /dev/null
fi
echo "now type: ollama-chat"