FROM ubuntu:16.04

# Install base dependencies
RUN apt-get update
RUN apt-get -y install sudo curl git locales lsb-release
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | debconf-set-selections

# Setup Google depot tools
WORKDIR /opt
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/opt/depot_tools/:${PATH}"

# Install Cr build deps
WORKDIR /scratch
RUN curl https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh\?format\=TEXT | base64 -d > install-build-deps.sh
RUN curl https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps-android.sh\?format\=TEXT | base64 -d > install-build-deps-android.sh
RUN chmod +x install-build-deps*
RUN ./install-build-deps-android.sh --no-prompt

# Remove apt cruft from image
RUN apt-get clean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

# Stage working dir for CMD
WORKDIR /work

# TODO: replace with Cr build script
CMD ["/bin/bash"]
