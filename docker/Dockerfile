FROM ubuntu:18.04

LABEL Maintainer="Janar Juusu" Description="ctf-docker image" Version="2020.1"

# Set up the image so that apt-get works as expected (package list is updated,
# apt-utils is installed to avoid the 'debconf: delaying package configuration,
# since apt-utils is not installed' error messages, etc).

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get install -y sudo locales
RUN dpkg-reconfigure -u apt-utils

COPY setup.sh /tmp/setup.sh
RUN chmod a+x /tmp/setup.sh
RUN adduser ubuntu --gecos ",,,," --disabled-password
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN cd /home/ubuntu && sudo -iHu ubuntu /tmp/setup.sh

# Install decompile
COPY decompile /usr/bin/decompile
RUN chmod +x /usr/bin/decompile

# Setup ssh
RUN apt-get install -y openssh-server \
    && echo root:root | chpasswd \
    && sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && sed 's/UsePrivilegeSeparation yes/UsePrivilegeSeparation no/' -i /etc/ssh/sshd_config \
    && mkdir -p /root/.ssh \
    && mkdir -p /var/run/sshd
COPY insecure_id_rsa.pub /root/.ssh/authorized_keys
EXPOSE 22

# Clean up (commented until squash hits stable)
#RUN apt-get autoremove -y
#RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

RUN apt-get install nano most

# set locale
RUN unset DEBIAN_FRONTEND
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

CMD ["/usr/sbin/sshd", "-D"]
