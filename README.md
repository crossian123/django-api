## For Production
### 0. settings Cloud-Registory & Cloud Run & Cloud Build
- 3つを有効化：`https://cloud.google.com/run/docs/setup?hl=ja`
- [GCRイメージ] = `[host_name]/[project_id]/[image_name]`

### 1. auth docker
- 参考：`https://cloud.google.com/container-registry/docs/advanced-authentication`
```
$ gcloud auth configure-docker
```

### 2. build image for Cloud-Registory
```
$ docker build -t [GCRイメージ名] [Dockerfileのパス]
```

### 3. push image to Cloud-Registory
参考：`https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=ja`
```
$ docker push [GCRイメージ名]
```

### 4. deploy image to Cloud-Run
参考：`https://cloud.google.com/run/docs/configuring/containers?hl=ja#command-line`
```
$ gcloud run deploy --image [GCRイメージ名] --port 8000 --platform managed
```
