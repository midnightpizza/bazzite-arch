FROM archlinux:base-devel

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        vim nano clang cmake ninja python git sudo htop && \
    pacman -S --clean --clean && \
    rm -rf /var/cache/pacman/pkg/*

RUN printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf

RUN useradd -m -G wheel --shell=/bin/bash build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
WORKDIR /home/build
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && makepkg -si --noconfirm && \
    cd .. && rm -rf yay
USER root
WORKDIR /

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        intel-media-driver \
        vulkan-mesa-layers \
        lib32-vulkan-mesa-layers \
        lib32-libnm \
        openal \
        pipewire pipewire-pulse pipewire-alsa pipewire-jack \
        wireplumber \
        lib32-pipewire lib32-pipewire-jack lib32-libpulse \
        yad xdg-user-dirs xdotool xorg-xwininfo wmctrl \
        wxwidgets-gtk3 \
        rocm-opencl-runtime rocm-hip-runtime \
        libbsd noto-fonts-cjk glibc-locales \
        firefox thunar mousepad dolphin \
        steam mangohud lib32-mangohud && \
    pacman -S --clean --clean && \
    rm -rf /var/cache/pacman/pkg/*

USER build
WORKDIR /home/build
RUN yay -S --noconfirm \
        protontricks \
        vkbasalt \
        lib32-vkbasalt \
        obs-vkcapture-git \
        lib32-obs-vkcapture-git \
        lib32-gperftools \
        steamcmd && \
    rm -rf /home/build/.cache/*

USER root
WORKDIR /

 RUN userdel -r build && \
     sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers

RUN rm -rf /tmp/* /var/cache/pacman/pkg/*

CMD ["/bin/bash"]
