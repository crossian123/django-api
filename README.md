# how to

## build docker image
```
$ docker build -t [イメージ名:タグ名] [Dockerfileのパス]
$ docker build -t django_app:latest .
```

## create docker container
```
$ docker run --name [コンテナ名] -p [ホスト側ポート:コンテナ側ポート] -it [イメージ名:タグ名]
$ docker run --name django_app -p 8000:8000 -it django_app:latest
```
