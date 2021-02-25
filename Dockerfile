FROM debian:10
LABEL maintainer="ben.cowling@xarios.com"

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV GOROOT /root/go
ENV GOPATH /root/code

RUN echo "Installing... " \
#
# install golang
&& apt update && apt install -y wget curl gnupg2 \
&& wget -qO- https://golang.org/dl/go1.15.linux-amd64.tar.gz | tar xzf - -C /root/ \
#
# install cgrates
&& wget -O - http://apt.cgrates.org/apt.cgrates.org.gpg.key | apt-key add - \
&& echo "deb http://apt.cgrates.org/debian/ nightly main" | tee /etc/apt/sources.list.d/cgrates.list \
&& apt-get update && apt-get install -y cgrates \
#
# cleanup
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 2012 

# set start command
ENTRYPOINT ["/opt/entrypoint.sh"]