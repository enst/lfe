FROM lfex/debian
MAINTAINER Bing Li <enst.bupt@gmail.com>

WORKDIR /

RUN curl -L -o ./lfetool https://raw.github.com/lfe/lfetool/stable/lfetool \
  && bash ./lfetool install \
  && rm -rf /root/lfetool \
  && lfetool -x

RUN apt-get update -y && apt-get install -f -y && apt-get clean -y 

CMD lfe
