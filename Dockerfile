FROM ubuntu:16.04

# Docker image to build Chromium.  You can continue from this step using this container:
# https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md#Get-the-code

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV SRC="/src"

RUN apt-get update
RUN apt-get -y install sudo curl git locales lsb-release

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | debconf-set-selections

WORKDIR /opt
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/opt/depot_tools/:${PATH}"


WORKDIR /scratch
RUN curl https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh\?format\=TEXT | base64 -d > install-build-deps.sh
RUN curl https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps-android.sh\?format\=TEXT | base64 -d > install-build-deps-android.sh
RUN chmod +x install-build-deps*
RUN ./install-build-deps-android.sh --no-prompt

# TODO depot_tools needs to writable, make /url/local/sbin a symlink to /src/depot_tools.  Clone depot_tools for each version build
# When you spin up the container you can use sudo to chown the depot_tools dir, fix this
RUN apt-get clean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR ${SRC}

CMD ["/bin/bash"]
