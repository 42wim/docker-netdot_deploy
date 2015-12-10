FROM blalor/centos
MAINTAINER @42wim
RUN curl https://get.docker.com/builds/Linux/x86_64/docker-latest -o /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker
ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ENTRYPOINT ["/usr/local/bin/run"]
