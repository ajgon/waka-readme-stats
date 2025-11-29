FROM python:3.11-alpine

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN mkdir -p /waka-readme-stats/assets

ADD requirements.txt /waka-readme-stats/requirements.txt
RUN apk add --no-cache curl g++ jpeg-dev zlib-dev libjpeg make git && pip3 install -r /waka-readme-stats/requirements.txt

RUN git config --global user.name "readme-bot"
RUN git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

ADD homelab.pem /usr/local/share/ca-certificates/homelab.crt

RUN cat /usr/local/share/ca-certificates/homelab.crt >> /etc/ssl/certs/ca-certificates.crt

ENV REQUESTS_CA_BUNDLE "/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_FILE "/etc/ssl/certs/ca-certificates.crt"

ADD sources/* /waka-readme-stats/
ENTRYPOINT cd /waka-readme-stats/ && python3 main.py
