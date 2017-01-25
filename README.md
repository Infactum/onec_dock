# onec_dock

Скрипт сборки docker контейнера с толстым клиентом 1С

## Использование

- Клонируем этот репозитарий
- `onec_dock.sh`

Для неинтерактивного запуска необходимо объявить окружения USERNAME, PASSWORD и VERSION, содержащие логин/пароль к [сайту с дистрибутивами](http://releases.1c.ru) 
и версию платформы соответственно.

```
export USERNAME=vasya
export PASSWORD=pupkin
export VERSION=8.3.8.2167
./download.sh
./build.sh
```

Если необходимые дистрибутивы платформы скачаны вручную и лежат в каталоге `dist`, то для сборки достаточно выполнить `./build.sh --no-tag`.

Полученный образ можно использовать в CI, либо для [запуска GUI](http://infostart.ru/public/548179/) 1С в вашем любимом linux дистрибутиве.

Пример создания чистой БД в текущем каталоге:
```
docker run --rm -it -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -v $(pwd):/pwd --user $(id -u) infactum/onec_thick_client bash -c 'xstart; /opt/1C/v8.3/i386/1cv8 CREATEINFOBASE File="/pwd/DB"'
```