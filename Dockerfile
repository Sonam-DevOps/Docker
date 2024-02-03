FROM python:3.8 as build
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /application

RUN apt-get update
RUN apt-get -y install curl autoconf automake libtool pkg-config
RUN apt-get -y install git

RUN git clone https://github.com/openvenues/libpostal
RUN cd libpostal && ./bootstrap.sh && ./configure --datadir=/application && make && make install
RUN ldconfig
RUN pip3 install postal

COPY . .
RUN pip3 install -r requirements.txt

ARG RELEASE_VERSION
ENV RELEASE_VERSION=${RELEASE_VERSION}

EXPOSE 8000
RUN chgrp -R 0 /application && chmod -R g=u /application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
