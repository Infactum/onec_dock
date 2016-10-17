# onec_dock

Скрипт сборки docker контейнера с толстым клиентом 1С

## Использование

- Клонируем этот репозитарий
- Объявляем переменные окружения USERNAME, PASSWORD и VERSION, содержащие логин/пароль к [сайту с дистрибутивами](http://releases.1c.ru) 
и версию платформы соответственно.
- `build.sh`

```
git clone https://github.com/Infactum/onec_dock.git
cd onec_dock
export USERNAME=vasya
export PASSWORD=pupkin
export VERSION=8.3.8.2167
./build.sh 
```

Полученный образ можно использовать в CI, либо для [запуска GUI](http://infostart.ru/public/548179/) 1С в вашем любимом linux дистрибутиве.