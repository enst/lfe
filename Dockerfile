FROM debian:7
MAINTAINER Bing Li <enst.bupt@gmail.com>

ENV OTP_VERSION R16B03-1
ENV REBAR_VERSION 2.5.1
ENV RELX_VERSION v1.1.0

RUN DEBIAN_FRONTEND=noninteractive  \
    apt-get update -qq \
    && apt-get install -y \
       build-essential \
       git \
       libncurses5-dev \
       openssl \
       libssl-dev \
       fop \
       xsltproc \
       unixodbc-dev \
       curl

ADD http://erlang.org/download/otp_src_${OTP_VERSION}.tar.gz /usr/src/
RUN cd /usr/src \
    && tar xf otp_src_${OTP_VERSION}.tar.gz \
    && cd otp_src_${OTP_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd / && rm -rf /usr/src/otp_src_${OTP_VERSION}

ADD https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz  /usr/src/rebar-${REBAR_VERSION}.tar.gz
RUN cd /usr/src \
    && tar zxf rebar-${REBAR_VERSION}.tar.gz \
    && cd rebar-${REBAR_VERSION} \
    && make \
    && cp rebar /usr/bin/rebar \
    && cd / && rm -rf /usr/src/rebar-${REBAR_VERSION}

ADD https://github.com/erlware/relx/archive/${RELX_VERSION}.tar.gz /usr/src/relx-${RELX_VERSION}.tar.gz
RUN cd /usr/src \
    && tar zxf relx-${RELX_VERSION}.tar.gz \
    && cd relx-${RELX_VERSION#v} \
    && make \
    && cp relx /usr/bin/relx \
    && cd / && rm -rf /usr/src/relx-${RELX_VERSION#v}


WORKDIR /opt/erlang/
ADD https://github.com/rvirding/lfe/archive/master.tar.gz /opt/erlang/lfe.tar.gz
RUN tar zxvf lfe.tar.gz
RUN mv /opt/erlang/lfe-master /opt/erlang/lfe
RUN cd /opt/erlang/lfe && make && make install

WORKDIR /root

RUN curl -L -o ./lfetool https://raw.github.com/lfe/lfetool/stable/lfetool
RUN bash ./lfetool install
RUN rm -rf /root/lfetool

RUN lfetool -x
