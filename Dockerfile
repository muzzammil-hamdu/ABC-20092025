FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y cron bash dos2unix && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash abc

WORKDIR /home/abc/myfolder

COPY task.sh .
RUN dos2unix task.sh && chmod +x task.sh && chown abc:abc task.sh

RUN echo "* * * * * /bin/bash /home/abc/myfolder/task.sh 1 >> /home/abc/myfolder/cron.log 2>&1" > /etc/cron.d/mycron \
    && chmod 0644 /etc/cron.d/mycron \
    && crontab -u abc /etc/cron.d/mycron

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y bash cron && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash abc

USER abc
WORKDIR /home/abc/myfolder

COPY --from=builder /home/abc/myfolder/task.sh .
COPY --from=builder /etc/cron.d/mycron /etc/cron.d/mycron

RUN chmod +x task.sh

RUN /bin/bash task.sh 0

CMD ["cron", "-f"]
