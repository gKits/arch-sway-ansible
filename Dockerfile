FROM archlinux:latest as base

RUN pacman -Syuu --noconfirm && \
    pacman -S --noconfirm sudo git ansible curl

FROM base as user
RUN groupadd --gid 1000 testuser
RUN useradd --uid 1000 --gid 1000 -m testuser
RUN usermod -aG wheel testuser
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
USER testuser
WORKDIR /home/testuser

FROM user
COPY . .
RUN ansible-galaxy collection install -r requirements.yml
CMD ["sh", "-c", "ansible-playbook local.yml"]
