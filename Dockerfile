FROM debian:buster-slim

LABEL maintainer="david.rigaudie@itarverne.com"

ENV GID 33411
ENV UID 33411

RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg && \
    curl -s https://packages.mailpile.is/deb/key.asc | apt-key add - && \
    echo "deb https://packages.mailpile.is/deb release main" | tee /etc/apt/sources.list.d/000-mailpile.list && \
    apt-get update && \
    apt-get install -y mailpile && \
    # TODO Enable apache for multi users
    # apt-get install -y mailpile-apache2
    update-rc.d tor defaults && \
    service tor start && \
    groupadd -g $GID mailpile && \
    useradd -u $UID -g $GID -m mailpile && \
    su - mailpile -c 'mailpile setup' && \
    apt-get clean

WORKDIR /home/mailpile
USER mailpile

VOLUME /home/mailpile/.local/share/Mailpile
VOLUME /home/mailpile/.gnupg
EXPOSE 33411

ENTRYPOINT ["service tor start;","mailpile"]
CMD ["--www=0.0.0.0:33411/","--wait"]

