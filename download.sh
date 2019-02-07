#!/bin/bash
set -e

if [ -z "$USERNAME" ]
then
    echo "USERNAME not set"
    exit 1
fi

if [ -z "$PASSWORD" ]
then
    echo "PASSWORD not set"
    exit 1
fi

if [ -z "$VERSION" ]
then
    echo "VERSION not set"
    exit 1
fi

SRC=$(curl -c /tmp/cookies.txt -s -L https://releases.1c.ru)
ACTION=$(echo "$SRC" | grep -oP '(?<=form method="post" id="loginForm" action=")[^"]+(?=")')
EXECUTION=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')

curl -s -L \
    -o /dev/null \
    -b /tmp/cookies.txt \
    -c /tmp/cookies.txt \
    --data-urlencode "inviteCode=" \
    --data-urlencode "execution=$EXECUTION" \
    --data-urlencode "_eventId=submit" \
    --data-urlencode "username=$USERNAME" \
    --data-urlencode "password=$PASSWORD" \
    https://login.1c.ru"$ACTION"

if ! grep -q "TGC" /tmp/cookies.txt
then
    echo "Auth failed"
    exit 1
fi

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VERSION" \
    --data-urlencode "path=Platform\\${VERSION//./_}\\client_${VERSION//./_}.deb64.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')

SERVERINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VERSION" \
    --data-urlencode "path=Platform\\${VERSION//./_}\\deb64_${VERSION//./_}.tar.gz" \
    https://releases.1c.ru/version_file | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив)')    

mkdir -p dist

curl --fail -b /tmp/cookies.txt -o dist/client.tar.gz -L $CLIENTLINK
curl --fail -b /tmp/cookies.txt -o dist/server.tar.gz -L $SERVERINK

rm /tmp/cookies.txt
