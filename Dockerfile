FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y tmate tzdata expect && \
    ln -fs /usr/share/zoneinfo/Asia/Kathmandu /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Bind to a dummy port so Render doesn't kill the service
EXPOSE 8080

CMD ["/start.sh"]
