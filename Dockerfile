FROM ubuntu:xenial
MAINTAINER Josh Lukens <jlukens@botch.com>
LABEL org.opencontainers.image.source=https://github.com/apnar/docker-image-logitech-media-server

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV BASESERVER_URL=http://downloads.slimdevices.com/nightly/
ENV RELEASE=8.3
ENV PERL_MM_USE_DEFAULT 1

RUN buildDeps='build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev python-pip python-dev' && \
        apt-get update && \
	apt-get -y install sudo curl wget faad flac lame sox libio-socket-ssl-perl libpython2.7 libfreetype6 \
             libfont-freetype-perl libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl \
             libcrypt-openssl-bignum-perl libcrypt-openssl-random-perl libcrypt-ssleay-perl avahi-utils ffmpeg \
             libinline-python-perl libnet-ssleay-perl opus-tools $buildDeps && \
	MEDIAFILE=`curl -Lsf -o - "${BASESERVER_URL}?ver=${RELEASE}" | grep _amd64.deb | sed -e '$!d' -e 's/.*href="//' -e 's/".*//'` && \
	MEDIASERVER_URL="${BASESERVER_URL}${MEDIAFILE}" && \
        echo Downloading ${MEDIASERVER_URL} && \
	curl -Lsf -o /tmp/logitechmediaserver.deb $MEDIASERVER_URL && \
	dpkg -i /tmp/logitechmediaserver.deb && \
	rm -rf /usr/share/squeezeboxserver/CPAN/Font && \
	rm -f /tmp/logitechmediaserver.deb && \
	cpan App::cpanminus && \
	cpanm --notest Inline && \
	cpanm --notest Inline::Python && \
	cpanm --notest IO::Socket::SSL && \
	apt-get purge -y --auto-remove $buildDeps && \
	apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        awk '/sub serverAddr {/{print $0 " \nif(defined $ENV{'\''PUBLIC_IP'\''}) { return $ENV{'\''PUBLIC_IP'\''} }"; next}1' /usr/share/perl5/Slim/Utils/Network.pm > /tmp/Network.pm && \
	mv /tmp/Network.pm /usr/share/perl5/Slim/Utils/Network.pm && \
  rm /usr/share/squeezeboxserver/Plugins && ln -s ${SQUEEZE_VOL}/Plugins /usr/share/squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

