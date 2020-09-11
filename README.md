## For Development
### 1. build docker-image for local
```
$ docker build -t [イメージ名:タグ名] [Dockerfileのパス]
$ docker build -t django_app:latest .
```

### 2. create docker-container
```
$ docker run --name [コンテナ名] -p [ホスト側ポート:コンテナ側ポート] -it [イメージ名:タグ名]
$ docker run --name django_app -p 8000:8000 -it django_app:latest
```



## For Production
### 0. settings Cloud-Registory & Cloud Run
- Cloud Runを有効化：`https://cloud.google.com/run/docs/setup?hl=ja`
- [GCRイメージ] = `[host_name]/[project_id]/[image_name]`

### 1. auth docker
- 参考：`https://cloud.google.com/container-registry/docs/advanced-authentication`
```
$ gcloud auth configure-docker
```

### 2. build docker-image for Cloud-Registory
```
$ docker build -t [GCRイメージ名] [Dockerfileのパス]
or
$ docker tag [開発したイメージ名] [GCRイメージ名]
$ docker tag [django_api:latest] asia.gcr.io/[プロジェクトID]/[イメージ名]
```

### 3. push image to Cloud-Registory
参考：`https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=ja`
```
$ docker push [GCRイメージ名]
```

### 4. deploy to Cloud-Run
参考：`https://cloud.google.com/run/docs/configuring/containers?hl=ja#command-line`
```
$ gcloud run deploy --image [GCRイメージ名] --port 8000 --platform managed
```
