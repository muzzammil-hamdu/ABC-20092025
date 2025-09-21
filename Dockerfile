FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y cron bash && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash abc

RUN mkdir -p /home/abc/myfolder && chown -R abc:abc /home/abc/myfolder

WORKDIR /home/abc/myfolder

FROM base AS intermediate

COPY task.sh /home/abc/myfolder/task.sh

RUN chmod +x /home/abc/myfolder/task.sh

RUN echo "* * * * * /home/abc/myfolder/task.sh 1 >> /home/abc/myfolder/cron.log 2>&1" > /etc/cron.d/mycron \
    && chmod 0644 /etc/cron.d/mycron \
    && crontab -u abc /etc/cron.d/mycron

FROM intermediate AS cleanup

USER abc
RUN /home/abc/myfolder/task.sh 0

FROM cleanup AS create

USER abc
RUN /home/abc/myfolder/task.sh 1

CMD ["cron", "-f"]
