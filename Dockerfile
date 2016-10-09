
FROM centos:centos6

MAINTAINER hays.clark@gmail.com

# Install the minimal requirements for Backburner 2014
RUN yum update -y && yum install -y \
    php \
    httpd \
    tcsh \
    glibc.i686 \
    libgcc.i686 \
    libstdc++.i686 \
    libuuid.i686 \
    wget && \
    yum clean all

# Download and unpack distribution first, Docker's caching
# mechanism will ensure that this only happens once.
ARG MAYA_URL=http://download.autodesk.com/us/support/files/maya_2014_service_pack4/Autodesk_Maya_2014sp4_English_Linux_64bit.gz
ARG TEMP_PATH=/tmp/maya
RUN mkdir -p $TEMP_PATH && cd $TEMP_PATH && \
    wget --progress=bar:force $MAYA_URL && \
    tar -zxvf *.gz && rm *.gz && \
    rpm -Uvhi *backburner.monitor*.rpm *base*.rpm *webmonitor*.rpm && \
    rm -rf ${TEMP_PATH}

# CREATE missing file that caused Web service error.
RUN mkdir /usr/discreet/cfg && touch /usr/discreet/cfg/network.cfg

# Set the workspace to boackburners home
WORKDIR /usr/discreet/backburner

# WWW Port
EXPOSE 80

# Manager Port
EXPOSE 3234

# Server Port
EXPOSE 3233

# Start container in "Machine mode"
CMD ["/sbin/init"]