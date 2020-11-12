# Development Dockerfile for raw2ometiff
# -----------------------------------------

# To install the built distribution into other runtimes
# pass a build argument, e.g.:
#
#   docker build --build-arg IMAGE=openjdk:9 ...
#

# Similarly, the BUILD_IMAGE argument can be overwritten
# but this is generally not needed.
ARG BUILD_IMAGE=gradle:6.2.1-jdk8

#
# Build phase: Use the gradle image for building.
#
FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq zeroc-ice-all-runtime libblosc1
RUN mkdir /raw2ometiff && chown 1000:1000 /raw2ometiff

# Build all
USER 1000

COPY --chown=1000:1000 . /raw2ometiff
WORKDIR /raw2ometiff
RUN gradle build
RUN cd build/distributions && rm raw2ometiff*tar && unzip raw2ometiff*zip && rm -rf raw2ometiff*zip
USER root
RUN mv /raw2ometiff/build/distributions/raw2ometiff* /opt/raw2ometiff
USER 1000
WORKDIR /opt/raw2ometiff
ENTRYPOINT ["/opt/raw2ometiff/bin/raw2ometiff"]
