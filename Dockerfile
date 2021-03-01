FROM debian:latest
LABEL maintainer="ben.cowling@xarios.com"
LABEL description="Runs CGRates in a Docker container"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apt-get -y update && apt-get -y install openssh-server \
     && echo "root:Docker!" | chpasswd 

# Copy the sshd_config file to the /etc/ssh/ directory
COPY sshd_config /etc/ssh/

# Open port 2222 for SSH access
EXPOSE 2222

# Start the SSH service
RUN service ssh start

# Timezone
ENV TZ=${CONTAINER_TZ:-Europe/London}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Dependencies
RUN apt-get -y update && apt-get -y install git 
RUN apt-get -y update && apt-get -y install sudo 
RUN apt-get -y update && apt-get -y install wget 
RUN apt-get -y update && apt-get -y install nano 
RUN apt-get -y update && apt-get -y install rsyslog 
RUN apt-get -y update && apt-get -y install ngrep 
RUN apt-get -y update && apt-get -y install curl 
RUN apt-get -y update && apt-get -y install redis-server
RUN apt-get -y update && apt-get -y install gnupg2
RUN apt-get -y update && apt-get -y install ssh

# Mongo Db client
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 656408E390CFB1F5 \
&& echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list \
&& apt-get update && apt-get install -y mongodb-org-shell

# CGRates
RUN wget -O - http://apt.cgrates.org/apt.cgrates.org.gpg.key | apt-key add - \
&& echo "deb http://apt.cgrates.org/debian/ nightly main" | tee /etc/apt/sources.list.d/cgrates.list \
&& apt-get update && apt-get install -y cgrates

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

EXPOSE 2012 

# set start command
ENTRYPOINT ["/opt/entrypoint.sh"] 