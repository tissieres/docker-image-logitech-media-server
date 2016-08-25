FROM ubuntu:xenial
MAINTAINER Josh Lukens <jlukens@botch.com>

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV MEDIASERVER_URL=http://downloads.slimdevices.com/nightly/7.9/sc/a452af8/logitechmediaserver_7.9.0~1471849136_amd64.deb
ENV PERL_MM_USE_DEFAULT 1

RUN buildDeps='build-essential libssl-dev libffi-dev python-pip python-dev' && \
        apt-get update && \
	apt-get -y install curl wget faad flac lame sox libio-socket-ssl-perl libpython2.7 $buildDeps && \
	curl -Lsf -o /tmp/logitechmediaserver.deb $MEDIASERVER_URL && \
	dpkg -i /tmp/logitechmediaserver.deb && \
	rm -f /tmp/logitechmediaserver.deb && \
	pip install --upgrade pip && \
	pip install gmusicapi==10.0.1 && \
	cpan App::cpanminus && \
	cpanm --notest Inline && \
	cpanm --notest Inline::Python && \
	apt-get purge -y --auto-remove $buildDeps && \
	apt-get clean && \
        rm -rf /var/lib/apt/lists/*

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]

