FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/home/tresorit:${PATH}"

# install dependencies
RUN apt-get update && apt-get install -y \
    curl && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*

# add tresorit user and set workdir to it's home directory
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo tresorit
WORKDIR /home/tresorit


RUN mkdir -p /home/tresorit/Profiles /home/tresorit/Logs \
             /external

USER tresorit

# install tresorit
RUN curl -LO https://installer.tresorit.com/tresorit_installer.run && \
    chmod +x ./tresorit_installer.run && \
    echo "N " | ./tresorit_installer.run --update-v2 . && \
    rm ./tresorit_installer.run 


VOLUME /home/tresorit/Profiles /home/tresorit/Logs
#USER root

COPY command.sh /usr/local/bin/command.sh
#RUN chmod +x /usr/local/bin/entrypoint.sh

USER tresorit

CMD /usr/local/bin/command.sh
