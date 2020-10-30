#!/bin/bash -xe

if [ "$UID" -eq 0 ] ; then
    exit 1
fi

HOME=/home/ubuntu
mkdir -p $HOME

sudo locale-gen "en_US.UTF-8"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "LANG=en_US.UTF-8" | sudo tee /etc/default/locale > /dev/null
echo "LC_ALL=en_US.UTF-8" | sudo tee --append /etc/default/locale > /dev/null

cd $HOME
mkdir tools
cd tools

# apt-get install -y \
#     aircrack-ng autoconf automake autotools-dev bison bkhive build-essential \
#     clang cmake curl dos2unix dsniff exif exiv2 fcrackzip foremost g++ gcc gdb \
#     gdb-multiarch gdbserver git imagemagick libc6-arm64-cross libc6-armhf-cross \
#     libc6-dev-i386 libc6-i386 libcurl4-openssl-dev libevent-dev libffi-dev \
#     libfreetype6 libfreetype6-dev libglib2.0-dev libgmp3-dev libjpeg62-dev \
#     libjpeg8 liblzma-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev \
#     libpcap-dev libreadline-dev libsqlite3-dev libssl-dev libtool libtool-bin \
#     libxml2-dev libxslt1-dev llvm lsb-release masscan most nano net-tools nmap \
#     ophcrack outguess pandoc pngtools python python-dev python-gmpy python-pil \
#     python-magic python-pip python3-pip python2.7 python3 samdump2 silversearcher-ag \
#     socat squashfs-tools steghide subversion texinfo tmux tofrodos tree unzip \
#     virtualenvwrapper wamerican wget zlib1g-dev zmap libgmp-dev libsqlite3-dev

#     python-pip \

sudo apt-get install -y \
    build-essential \
    curl \
    git \
    libc6-arm64-cross \
    libc6-armhf-cross \
    libc6-dev-i386 \
    libc6-i386 \
    libffi-dev \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    python3-dev \
    python3-pip \
    python3 \
    tmux \
    tree \
    virtualenvwrapper \
    wget \
    silversearcher-ag \
    unzip \
    cmake \
    net-tools \
    clang \
    llvm \
    libtool-bin \
    squashfs-tools \
    zlib1g-dev liblzma-dev python-magic \
    libtool automake bison libglib2.0-dev \
    steghide \
    pngtools \
    outguess \
    exif \
    exiv2 \
    imagemagick \
    wamerican \
    python-pil \
    libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev \
    dsniff foremost texinfo subversion \
    pandoc libxml2-dev libxslt1-dev libcurl4-openssl-dev python-gmpy \
    tofrodos libsqlite3-dev libpcap-dev libgmp3-dev libevent-dev \
    autotools-dev libreadline-dev libncurses5-dev \
    gdb \
    gdb-multiarch \
    gdbserver \
    nmap zmap masscan \
    aircrack-ng samdump2 bkhive \
    ophcrack

# Install Pillow
pip3 install --user --upgrade Pillow

# Install r2pipe
pip3 install --user --upgrade r2pipe

# Install Frida
pip3 install --user --upgrade frida

# Install retdec decompiler
pip3 install --user retdec-python

# Set up env vars
echo "export WORKON_HOME=~/.virtualenvs" >> $HOME/.bashrc
echo "export PROJECT_HOME=~/.vewdevel" >> $HOME/.bashrc
echo "export VIRTUALENVWRAPPER_SCRIPT=/usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> $HOME/.bashrc
echo "source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh" >> $HOME/.bashrc

# Install pwndbg
cd $HOME/tools
git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh

pip3 install --user --upgrade ipython
pip3 install --user --upgrade angr
pip3 install --user --upgrade pwntools

# Install radare2
cd $HOME/tools \
    && git clone https://github.com/radare/radare2 \
    && cd radare2 \
    && ./sys/user.sh

# Install qemu
sudo apt-get install -y qemu qemu-user qemu-user-static
sudo apt-get install -y 'binfmt*'
sudo apt-get install -y libc6-armhf-armel-cross
sudo apt-get install -y debian-keyring
sudo apt-get install -y debian-archive-keyring
sudo apt-get install -y libc6-mipsel-cross
sudo apt-get install -y libc6-armel-cross libc6-dev-armel-cross
sudo apt-get install -y libc6-armhf-cross libc6-dev-armhf-cross
sudo apt-get install -y binutils-arm-linux-gnueabi
sudo apt-get install -y libncurses5-dev
sudo mkdir /etc/qemu-binfmt
sudo ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
sudo ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm

# Install binwalk
cd $HOME/tools \
    && git clone https://github.com/devttys0/binwalk \
    && cd binwalk \
    && python3 setup.py install --user

# Install firmware-mod-kit
cd $HOME/tools \
    && wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/firmware-mod-kit/fmk_099.tar.gz \
    && tar zxvf fmk_099.tar.gz \
    && rm fmk_099.tar.gz \
    && cd fmk/src \
    && ./configure \
    && make

# Install AFL with QEMU and clang-fast
cd $HOME/tools \
    && wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz \
    && tar -xzvf afl-latest.tgz \
    && rm afl-latest.tgz \
    && wget http://llvm.org/releases/3.8.0/clang+llvm-3.8.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
    && xz -d clang* \
    && tar xvf clang* \
    && cd clang* \
    && cd bin \
    && export PATH=$PWD:$PATH \
    && cd ../.. \
    && cd afl-* \
    && make \
    && cd llvm_mode \
    && make \
    && cd .. \
    && cd qemu* \
    && ./build_qemu_support.sh \
    && cd .. \
    && make install \
    && cd $HOME/tools \
    && rm -rf clang*

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386

# Install apktool
sudo apt install -y default-jre \
    && wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool \
    && wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.1.jar \
    && sudo mv apktool_2.4.1.jar /bin/apktool.jar \
    && sudo mv apktool /bin/ \
    && sudo chmod 755 /bin/apktool \
    && sudo chmod 755 /bin/apktool.jar

# Install dotfiles
cd $HOME \
    && git clone https://github.com/tkk2112/dotfiles.git \
    && cd dotfiles \
    && ./install.sh

hash -r

# Install stegdetect/stegbreak
wget http://old-releases.ubuntu.com/ubuntu/pool/universe/s/stegdetect/stegdetect_0.6-6_amd64.deb \
    && sudo dpkg -i stegdetect_0.6-6_amd64.deb \
    && rm -rf stegdetect*

# Install John The Jumbo
cd $HOME/tools \
    && git clone --depth 1 https://github.com/magnumripper/JohnTheRipper.git \
    && cd JohnTheRipper/src \
    && ./configure --prefix=$HOME/apps/johntheripper \
    && make -j2 install


# Install ctf-tools
echo "export PATH=\$PATH:~/tools/ctf-tools/bin" >> $HOME/.bashrc
export PATH=$PATH:~/tools/ctf-tools/bin
cd $HOME/tools && git clone https://github.com/zardus/ctf-tools \
    && cd ctf-tools \
    && bin/manage-tools setup

# missing testdisk
for x in subbrute sqlmap dirsearch dirb commix burpsuite exetractor pdf-parser peepdf scrdec18 \
    cribdrag foresight featherduster hashpump-partialhash hash-identifier littleblackbox \
    msieve pemcrack pkcrack python-paddingoracle reveng sslsplit xortool yafu elfkickers xrop \
    evilize checksec ; do
    $HOME/tools/ctf-tools/bin/manage-tools install $x
done

# Install XSSer
sudo apt install python3-pycurl python3-bs4 python3-geoip python3-gi python3-cairocffi python3-selenium firefoxdriver
pip3 install --upgrade pycurl BeautifulSoup
cd $HOME/tools \
    && wget https://xsser.03c8.net/xsser/xsser_1.8.3_all.deb \
    && sudo dpkg -i xsser_1.8.3_all.deb \
    && rm -rf xsser*

# Install uncompyle2
# cd $HOME/tools \
#     && git clone https://github.com/wibiti/uncompyle2.git \
#     && cd uncompyle2 \
#     && python3 setup.py install --user

pip3 install --user --upgrade gmpy
pip3 install --user --upgrade gmpy2
pip3 install --user --upgrade numpy

