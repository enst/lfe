FROM correl/erlang:R16
MAINTAINER Bing Li <enst.bupt@gmail.com>

RUN apt-get update && apt-get install -y curl

WORKDIR /root/

RUN curl -L -o /usr/local/bin/lfetool https://raw.github.com/lfe/lfetool/stable/lfetool
RUN chmod +x /usr/local/bin/lfetool

RUN lfetool -x

#have to work around an unknown lfe install issue
RUN lfetool install lfe || true
RUN lfetool install lfe || true

CMD lfe
