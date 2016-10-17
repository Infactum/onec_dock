FROM daald/ubuntu32:precise

ENV DEBIAN_FRONTEND noninteractive

ARG WEBHOST

WORKDIR /tmp
RUN set -e \
    # Шрифты MS содержатся в отдельном репозитории
    && echo "deb http://archive.ubuntu.com/ubuntu precise multiverse" >> /etc/apt/sources.list \
    # Принимаем EULA Microfost на использование шрифтов
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && apt-get update \
    && apt-get install -y --no-install-recommends \        
        curl \
        dpkg-dev \
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
        # необходим multiverse
        ttf-mscorefonts-installer \        
    && curl -O http://$WEBHOST/client32.tar.gz \
    && curl -O http://$WEBHOST/server32.tar.gz \
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
        curl \
        dpkg-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /tmp/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANG ru_RU.utf8      
