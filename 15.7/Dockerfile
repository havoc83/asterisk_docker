FROM ubuntu:18.04 as build
# Asterisk Certified
ARG VERSION=asterisk-15.7.2

LABEL name="Asterisk Build"

RUN apt-get update \
# DEBIAN_FRONTEND=noninteractive is needed otherwise 
# libvpb1 will attempt to prompt and break the build 
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    aptitude \
    aptitude-common \
    build-essential \
    g++ \
    libcgi-fast-perl \
    libcgi-pm-perl \
    libclass-accessor-perl \
    libcwidget3v5 \
    libencode-locale-perl \
    libfcgi-perl \
    libhtml-parser-perl \
    libhtml-tagset-perl \
    libhttp-date-perl \
    libhttp-message-perl \
    libio-html-perl \
    libio-string-perl \
    liblocale-gettext-perl \
    liblwp-mediatypes-perl \
    libparse-debianchangelog-perl \
    libsigc++-2.0-0v5 \
    libsub-name-perl \
    libtimedate-perl \
    liburi-perl \
    libssl-dev \
    libncurses5-dev \
    libnewt-dev \
    libvpb1 \
    libxml2-dev \
    linux-headers-generic \
    libsqlite3-dev \
    make \
    tzdata \
    uuid-dev \ 
    wget

WORKDIR /tmp/
# Download the version specified in the ARG above from the official asterisk site. 
RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/$VERSION.tar.gz \
    && mkdir -p /tmp/asterisk \
    && tar -xzvf $VERSION.tar.gz -C asterisk --strip-components=1
WORKDIR /tmp/asterisk/
# Install prereq should not install anything new as it should have already been installed
# above, but this should catch any unistalled packages, however since there is no -y option specified
# if there is a missing package it will likely break the build
RUN mkdir -p /opt/asterisk \
    && ./contrib/scripts/install_prereq install \
    && sh contrib/scripts/get_mp3_source.sh \
    #CFLAGS='-g -O2 -mtune=native'
    # -rpath,/usr/lib64 needs to be included so you do not receive an error on startup stating that libasteriskssl.so is not found.
    && LDFLAGS="-Wl,-rpath,/usr/lib64" \
       ./configure --with-pjproject-bundled --prefix=/opt/asterisk --libdir=/usr/lib64 \
    && ldconfig

# Copy in menuselect to let asterisk know what modules to install since we do not want to use the 
# interactive menuselect process.
COPY menuselect.makeopts /tmp/asterisk/
RUN make menuselect.makeopts \
    && menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts \
    && make \
    && make install \
    # Not necessary as users will likely install their own configs
    # but it does work well for testing to ensure asterisk starts properly
    && make samples

FROM ubuntu:18.04 as final
LABEL name="Asterisk Final"
ENV TZ=America/Chicago
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libavahi-client3 \
    libcurl4 \
    libgsm1 \
    libjansson4 \
    libneon27 \
    liburiparser1 \
    libedit2 \
    libgmime-2.6-0 \
    liblua5.2-0 \
    libpq5 \
    libiksemel3 \
    libsrtp0 \
    libssl1.0.0 \
    libsqlite3-0 \
    libspandsp2 \
    libspeex1 \
    libspeexdsp1 \
    libvorbis0a \
    libvorbisenc2 \
    libvorbisfile3 \
    libxml2 \
    libxslt1.1 \
    tzdata \
    unixodbc \
    && mkdir -p /opt/asterisk 
# Copy exectuables and all config for asterisk
COPY --from=build /opt/asterisk /opt/asterisk
# Copy over any asterisk libs
COPY --from=build /usr/lib64 /usr/lib64
# This will allow users to call `asterisk` 
# from the command line without adding /opt/asterisk to their path
# We will need a way to override this at runtime
RUN ln -s /opt/asterisk/sbin/asterisk /usr/sbin/asterisk \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone
# -f starts asterisk in the foreground so that the container does not stop after startup.
CMD ["asterisk", "-f"]