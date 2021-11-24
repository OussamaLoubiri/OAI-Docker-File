FROM ubuntu:18.04
MAINTAINER Oussama <oussama.loubiri@telecom-sudparis.eu>

RUN DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git
RUN apt-get install -y apt-utils 

RUN mkdir gitlab
WORKDIR gitlab
RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
WORKDIR openairinterface5g
RUN git checkout develop
RUN /bin/bash -c 'source oaienv'
WORKDIR cmake_targets
RUN /bin/bash -c './build_oai -I'
RUN /bin/bash -c './build_oai --gNB --nrUE'
WORKDIR ran_build/build
RUN make rfsimulator
RUN ln -s librfsimulator.so liboai_device.so 

CMD ["echo", "Building a docker image that runs open air interface has finished Succesfully"]
