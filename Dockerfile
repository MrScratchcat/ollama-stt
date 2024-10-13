#kali dockerfile
FROM archlinux
RUN mkdir ollama-chat
WORKDIR ollama-chat
COPY ollama-chat .
COPY voskmodels .
COPY start-talking.wav .
RUN pacman -Syyu --noconfirm
RUN pacman -S --needed base-devel python python-pip python-pipx nano sudo jq mpv sox curl --noconfirm
RUN pipx install vosk edge-tts
RUN curl -fsSL https://ollama.com/install.sh | sh
CMD ["bash", "ollama-chat"]
EXPOSE 11434


