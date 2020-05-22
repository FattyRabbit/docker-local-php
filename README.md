# マルチバージョンのPHP統合ローカルWebサーバー環境

開発環境（ローカル）で今までの経験で必要と思う要件を纏めてみました。

* 誰でも、何処でも同じテストができるべき
* プロジェクトの追加が良い
* ドメインは纏めて管理したい

## 1. Dockerを使用
誰でも何処でも同じ環境が作成されることでDockerを利用することになりました。利用可能なイメージも多いのでサーバー等簡単に使えます。

基本的な考え方としてdocker-compose.ymlファイルを作成して管理を行う予定です。予想コンテイナーは以下の物を使用しようかと思います。

* ウェブサーバー：centos https://hub.docker.com/_/centos
* DBA：mariadb https://hub.docker.com/_/mariadb
* ドメイン管理：NSD https://hub.docker.com/r/hardware/nsd-dnssec

## 2. サーバーの構成図

![構成](https://k.kakaocdn.net/dn/M4TlA/btqBEAc5OhU/tcTKt3YwWXVvlmsWvcdgk0/img.png "構成")

### Hostの設定
/etc/hostsを修正するのではなくて、DNS設定でDNSサーバーのコンテイナーを作成して、DNSサーバーはvolumeでマウントされたconfigファイルに追記する方法かdocker-compose.ymlファイルのENVの設定で制御する方法を考えています。

### ウェブサーバーの設定
ApacheのVirtualHostの設定ファイルをvolumeでマウントして構成します。また、プロジェクトことにphpのバージョンが違う場合を想定してphpenvで対応しfpmで連携します。

### DBサーバーの設定
直接に参照ができるようにEXPOSEで3306を開放したいと思います。Hostを含めてVPCグループの接続ができるように設定します。

## 3. 設定＆インストール

### dockerとdocker-composeのインストール

iOSを前提です。Windows系はiOSを参考で構築してください。

1. https://store.docker.com/editions/community/docker-ce-desktop-mac にアクセスしてEdge版をダウンロード
2. Docker for Mac (Stable) を実行中であれば停止
3. Docker.dmgを実行してアプリケーションフォルダにコピー
4. Docker for Mac (Edge) を起動

上記の製品に「docker-compose」が含まれています。

### テスト環境の構築
```
<< Work Space >> ┬ docker-local-server
                 └ web_root ┬ projectA
                            ├ ......
                            └ projectZ
```

#### Dockerフォルダ
上記の「docker-local-server」のところです。

```bash
$ cd << Work Space >>
$ git clone git@bitbucket.org:w012/docker-local-server.git
```
Sourcetreeでも別に構いません。

#### コンテイナーのBuild＆実行

```bash
$ cd << Work Space >>/docker-local-server
$ cp dns/hosts-dnsmasq.sample dns/hosts-dnsmasq
$ docker-compose --compatibility up -d --build
```

再ビルドの場合
```bash
$ cd << Work Space >>/docker-local-server
$ docker-compose --compatibility up -d --build --force-recreate
```
* --compatibility：mem_limitを使っていましたが、現在は使っておりませんので省略してもOK
* --build：起動前にイメージも構築
* --force-recreate：設定やイメージに変更がなくても、コンテナを再作成

__少々時間が掛かります。イメージのリポジトリサーバーが用意されれば改善されると思います。__

docker-compose --compatibility up -d --build --force-recreate