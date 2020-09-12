# Deploy Flow

## 0. settings Container-Registory & Cloud-Run & Cloud-Build
1. プロジェクト作成：プロジェクトID取得
2. APIを有効化

## 1. authenticate to connect Container-Registory
参考：`https://cloud.google.com/container-registry/docs/advanced-authentication`
```
$ gcloud auth configure-docker
```

## 2. build image for Container-Registory
```
$ docker build -t [GCRイメージ名] -f [Dockerfile名] [Dockerfileのパス]
```

## 3. push image to Container-Registory
参考：`https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=ja`
```
$ docker push [GCRイメージ名]
```

## 4. deploy image to Cloud-Run
参考：`https://cloud.google.com/run/docs/configuring/containers?hl=ja#command-line`
```
$ gcloud run deploy --image [GCRイメージ名] --port 8000 --platform managed
```


## 1〜4. automatic with cloudbuild.yaml
### loudbuild.yaml
```yaml
steps:
  # [build or rebuild image]
  - name: 'gcr.io/cloud-builders/docker' # standard container name
    # exec command
    entrypoint: docker
    args: ['build', '-t', '[GCRイメージ名]', '-f', '[Dockerfile名]', '[Dockerfileのパス]']
  # [push image]
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: docker
    args: ['push', '[GCRイメージ名]']

  # [deploy image]
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: gcloud
    args: ['run', 'deploy', '[プロジェクトID]', '--region', 'asia-northeast1', '--image', '[GCRイメージ名]', '--port', '8000', '--platform', 'managed']

  # GCR image name
  images:
    - [GCRイメージ名]
```
以下のコマンドでcloudbuild.yamlを実行
```
$ gcloud builds submit
```


## 5. add Cloud-SQL to Cloud-Run
参考：`https://cloud.google.com/sql/docs/mysql/connect-run?hl=ja#public-ip-default`
1. Cloud-SQL Admin APIを有効化
2. Cloud-SQLインスタンス作成
3. ユーザー作成
4. データベース作成
5. Cloud-RunにCloud-SQLのインスタンスを登録
```
$ gcloud run services update [サービス名] --add-cloudsql-instances [インスタンス接続名]
```
6. 環境変数を登録
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

## 6. migrate on Cloud-SQL from local
参考：`https://cloud.google.com/python/django/appengine?hl=ja`
1. Cloud-SQL-proxyをインストール
```
$ curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
$ chmod +x cloud_sql_proxy
```
2. Cloud-SQLインスタンス起動 & 接続確認
```
$ ./cloud_sql_proxy -instances="[インスタンス接続名]"=tcp:5306
$ mysql -u [ユーザー名] -p --host 127.0.0.1 -P 5306
```
3. migrate実行
```
$ cd code
$ pipenv run python manage.py migrate
```
