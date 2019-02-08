FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

ARG WEBHOST

WORKDIR /tmp
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        locales apt-transport-https \
        # Опциональные зависимости толстого клиента (см. ИТС)
        # Разработка и администрирование - 1С:Предприятие <версия> документация - Руководство администратора
        # - Требования к аппаратуре и программному обеспечению - Прочие требования - Для ОС Linux
        libwebkit-dev libcanberra-gtk-module \
        imagemagick \
        libfreetype6 \
        libfontconfig1 \
        libgsf-1-114 \
        libglib2.0-bin \
        unixodbc \        
    # Костыль по установке шритов MS из репо Debian.
    # Родные из Ubuntu Multiverse сломаны в текущей версии
    && apt-get install -y --no-install-recommends \
        wget cabextract xfonts-utils libmspack0 xfonts-encodings \
    # Шрифты MS из репо Debian работают стабильно в отличие от 
    && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.6_all.deb -O ttf-mscorefonts-installer.deb \
    # Принимаем EULA Microfost на использование шрифтов
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && dpkg -i ttf-mscorefonts-installer.deb \
    && rm ttf-mscorefonts-installer.deb \
    && cp -R /usr/share/fonts/truetype/msttcorefonts/ /usr/share/fonts/truetype/msttcorefonts_/ \
    && apt-get autoremove -y --purge \
        wget cabextract xfonts-utils libmspack0 xfonts-encodings \
    && mv /usr/share/fonts/truetype/msttcorefonts_/ /usr/share/fonts/truetype/msttcorefonts/ \
    #
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# Даже для выполнения консольных команд платформы необходим X сервер
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        xserver-xorg-video-dummy \
        dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl dpkg-dev \
    && curl -O http://$WEBHOST/client.tar.gz \
    && curl -O http://$WEBHOST/server.tar.gz \
    # Подготовка локального apt репозитария
    && for f in *.tar.gz; do tar xzvf $f; done \    
    && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz \
    && mkdir -p /etc/apt/sources.list.d \
    && echo deb file:/tmp ./ > /etc/apt/sources.list.d/onec.list \
    && apt-get update \
    && apt-get -y --force-yes install \
        1c-enterprise83-client \
    # Очистка от мусора
    && apt-get autoremove -y --purge \
        curl dpkg-dev \
    #
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -f /etc/apt/sources.list.d/onec.list

ENV DISPLAY :100

ENV LANG ru_RU.utf8

ADD xorg.conf /usr/share/X11/xorg.conf.d/10-dummy.conf
ADD xstart.sh /usr/local/bin/xstart
