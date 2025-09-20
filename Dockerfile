FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y bash cron
RUN rm -rf /var/lib/apt/lists/*

COPY task.sh /usr/local/bin/task.sh
RUN chmod +x /usr/local/bin/task.sh

RUN echo "* * * * * /usr/local/bin/task.sh 1 >> /var/log/task.log 2>&1" > /etc/cron.d/task_cron
RUN chmod 0644 /etc/cron.d/task_cron
RUN crontab /etc/cron.d/task_cron

RUN touch /var/log/task.log

CMD cron -f
