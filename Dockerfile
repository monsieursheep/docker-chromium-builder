FROM ubuntu:16.04

# Docker image to build Chromium.  You can continue from this step using this container:
# https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md#Get-the-code

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV SRC="/src"

RUN sed -i -E -e 's/archive.ubuntu.com\/ubuntu\//archive.ubuntu.com\/mirrors.txt/' -e 's/http:\/\/([[:alpha:]]+.)?archive/mirror:\/\/mirrors/' /etc/apt/sources.list \
    && apt-get update \
	&& apt-get -y install locales lsb-release \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& locale-gen \
	&& apt-get -y install sudo curl \
	&& useradd -m docker \
    && mkdir $SRC \
    && chown -R docker:docker $SRC \
	&& adduser docker sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# The following package has interactive prompts, if you don't install it here the following RUN step will hang
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | debconf-set-selections

RUN curl https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT | base64 -d > /usr/local/bin/install-build-deps.sh \
    && chmod a+x /usr/local/bin/install-build-deps.sh \
	&& /usr/local/bin/install-build-deps.sh --no-prompt --no-chromeos-fonts \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
	&& git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/sbin

# TODO depot_tools needs to writable, make /url/local/sbin a symlink to /src/depot_tools.  Clone depot_tools for each version build
# When you spin up the container you can use sudo to chown the depot_tools dir, fix this

WORKDIR ${SRC}
VOLUME ${SRC}
USER docker

CMD ["/bin/bash"]
