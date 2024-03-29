FROM opensuse/leap:15.5

LABEL maintainer="Michael Maffait"
LABEL org.opencontainers.image.source="https://github.com/Pandemonium1986/docker-sles15sp5"

# Configure environment variables
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PYTHONIOENCODING=utf8

# Systemd configuration
STOPSIGNAL SIGRTMIN+3
ENV container=docker

# Install dependencies
RUN zypper install -y dbus-1 \
  openssh-server \
  python3 \
  systemd-sysvinit \
  update-alternatives && \
  zypper clean --all

# Update alternative
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 0

# Remove systemd target
WORKDIR /usr/lib/systemd/system/sysinit.target.wants
RUN for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done ; \
  rm -f /usr/lib/systemd/system/multi-user.target.wants/* ; \
  rm -f /etc/systemd/system/*.wants/* ; \
  rm -f /usr/lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /usr/lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /usr/lib/systemd/system/basic.target.wants/* ; \
  rm -f /usr/lib/systemd/system/anaconda.target.wants/*

WORKDIR /

VOLUME [ "/tmp", "/run" ]

CMD ["/usr/lib/systemd/systemd"]

