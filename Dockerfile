# bananabread-ocp
#FROM ubuntu:18.04
FROM trzeci/emscripten-ubuntu

ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Bananabread game" \
      io.k8s.display-name="BananaBread builder 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.display-name="BananaBread builder (latest)" \
      io.openshift.tags="builder,1.0.0,bananabread"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
#RUN yum install -y rubygems && yum clean all -y
#RUN gem install asdf

ARG DEBIAN_FRONTEND=noninteractive

#install sdl2
RUN apt update
#RUN apt install -y emscripten
RUN apt install -y libsdl-*
RUN apt install -y libsdl2-*


ln -s /usr/local/include/SDL/SDL_image.h SDL_image.h
ln -s /usr/local/include/SDL/SDL_mixer.h /usr/include/SDL2/SDL_image.h

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 .

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
