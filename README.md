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

### 5. cloudbuild.yamlを実行
```
$ gcloud builds submit
```

### 6. add Cloud-SQL to Cloud-Run
参考：`https://cloud.google.com/sql/docs/mysql/connect-run?hl=ja#public-ip-default`
- 1. Cloud SQL Admin APIを有効化
- 2. SQLインスタンス作成
- 3. ユーザー作成
- 4. データベース作成
- 5. Cloud-RunにCloud-SQLのインスタンスを登録
```
$ gcloud run services update [サービス名] --add-cloudsql-instances [インスタンス接続名]
```
- 6. 環境変数を登録
```
$ gcloud run services update [サービス名] \
    --set-env-vars \
    INSTANCE_CONNECTION_NAME=[インスタンス接続名],\
    MYSQL_DATABASE=[データベース名],\
    MYSQL_HOST=[Cloud-SQLのパブリックIPアドレス],\
    MYSQL_PORT=5306,\
    MYSQL_USER=[ユーザー名],\
    MYSQL_PASSWORD=[パスワード],\
    MODE=production
```

### 7. migrate on Cloud-SQL from local
参考：`https://cloud.google.com/python/django/appengine?hl=ja`
- 1. Cloud-SQL-proxyをインストール
```
$ curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
$ chmod +x cloud_sql_proxy
```
- 2. Cloud-SQLインスタンス作成
- 3. Cloud-SQLインスタンス起動
```
$ ./cloud_sql_proxy -instances="[インスタンス接続名]"=tcp:5306
```
- 4. 接続確認
```
$ mysql -u [ユーザー名] -p --host 127.0.0.1 -P 5306
```
- 5. migrate実行
```
$ cd code
$ pipenv run python manage.py migrate
```
