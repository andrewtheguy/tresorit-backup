FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/home/tresorit:${PATH}"

# install dependencies
RUN apt-get update && apt-get install -y \
    curl tini && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/*

# add tresorit user and set workdir to it's home directory
RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo tresorit



USER root

RUN mkdir -p /home/tresorit/workdir/Profiles /home/tresorit/workdir/Logs \
             /external && chown tresorit:tresorit /home/tresorit/workdir/ -R

USER tresorit

WORKDIR /home/tresorit/workdir

# install tresorit
RUN curl -LO https://installer.tresorit.com/tresorit_installer.run && \
    chmod +x ./tresorit_installer.run && \
    echo "N " | ./tresorit_installer.run --update-v2 /home/tresorit/workdir && \
    rm ./tresorit_installer.run 


VOLUME /home/tresorit/workdir/Profiles /home/tresorit/workdir/Logs
#USER root

COPY command.sh /usr/local/bin/command.sh
#RUN chmod +x /usr/local/bin/entrypoint.sh

ENV PATH="${PATH}:/home/tresorit/workdir"

CMD ["/usr/bin/tini", "--", "/usr/local/bin/command.sh"]
