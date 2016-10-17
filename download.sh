#!/bin/bash
set -e

if [ -z "$USERNAME" ]
then
    echo "Username env var not set"
    exit 1
fi

if [ -z "$PASSWORD" ]
then
    echo "Username env var not set"
    exit 1
fi

if [ -z "$VERSION" ]
then
    echo "Username env var not set"
    exit 1
fi

SRC=$(curl -c /tmp/cookies.txt -s -L https://releases.1c.ru)
ACTION=$(echo "$SRC" | grep -oP '(?<=form id="loginForm" action=")[^"]+(?=")') 
LT=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="lt" value=")[^"]+(?=")')
EXECUTION=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')

curl -s -L \
    -o /dev/null \
    -b /tmp/cookies.txt \
    -c /tmp/cookies.txt \
    --data-urlencode "inviteCode=" \
    --data-urlencode "lt=$LT" \
    --data-urlencode "execution=$EXECUTION" \
    --data-urlencode "_eventId=submit" \
    --data-urlencode "username=$USERNAME" \
    --data-urlencode "password=$PASSWORD" \
    https://login.1c.ru"$ACTION"

if ! grep -q "onec_security" /tmp/cookies.txt
then
    echo "Auth failed"
    exit 1
fi

curl -s -G \
    -o /dev/null \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$VERSION" \
    --data-urlencode "path=Platform\\${VERSION//./_}\\client.deb32.tar.gz" \
    https://releases.1c.ru/version_file

mkdir -p dist
curl --fail -c /tmp/cookies.txt -o dist/client32.tar.gz http://downloads.v8.1c.ru/get/Info/Platform/"${VERSION//./_}"/client.deb32.tar.gz
curl --fail -c /tmp/cookies.txt -o dist/server32.tar.gz http://downloads.v8.1c.ru/get/Info/Platform/"${VERSION//./_}"/deb.tar.gz

rm /tmp/cookies.txt