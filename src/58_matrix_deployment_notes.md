# 现代即时通讯方案 Matrix 部署笔记


本文记录在 Debian Bookworm 上，Matrix（`matrix-synapse`） 部署时的注意点。[Matrix](https://matrix.org/) 是个用于安全、去中心化通讯的开放网络。[element.io](https://element.io/) 编写维护的 [`matrix-synapse`](https://github.com/element-hq/synapse)，是一种开源的 Matrix homeserver 的实现。结合 [Jitsi Meet](https://jitsi.org/)，一种可作为单独 app 或嵌入咱们的 web 应用的安全、简单和可伸缩视频会议系统，就能建立起功能完整的及时通信方案。


## `matrix-synapse` 部署


需要 Nginx，对 `matrix-synapse` 进行反向代理，和 [`element-web`](https://github.com/element-hq/element-web) web app 的提供；`pyenv` 提供 `Python 3.8.19`（`matrix-synapse` 所需）；PostgreSQL 提供数据库。

部署完整文档在 [Synapse 文档仓库](https://element-hq.github.io/synapse/latest)。下面记录需要注意的地方。`matrix-synapse` 的配置文件为 `homeserver.yaml`，缩进为 4 个空格，纯 `tab` 缩进会报错。


### TURN 服务器、PostgreSQL 和 `matrix-synapse-ldap3`


Synapse 需要 TURN 服务器，可参考上面的文档配置，也可以使用 Jitsi 视频会议系统配置的 TURN 服务器。三者的配置如下。


```yaml
turn_uris: [ "turn:matrix.xfoss.com?transport=udp" ]
turn_shared_secret: "some_pre-shared_key"
turn_user_lifetime: 86400000
turn_allow_guests: true

database:
  name: psycopg2
  args:
    user: "synapse"
    password: "some_secret"
    dbname: "synapse_db"
    host: "localhost"
    cp_min: 5
    cp_max: 10

modules:
 - module: "ldap_auth_provider.LdapAuthProviderModule"
   config:
     enabled: true
     uri: "ldap://10.11.2.12:389"
     # start_tls: true
     base: "dc=xfoss,dc=com"
     attributes:
        uid: "sAMAccountName"
        mail: "mail"
        name: "cn"
     bind_dn: "cn=admin,cn=Users,dc=xfoss,dc=com"
     bind_password: "some_secret"
```

配置好后，`matrix-synapse` 在 `source .venv/bin/activate` 后的 Python virtual-environment 下，提供了 `synctl` 命令用于其启动、停止和重启。



***一直同步的问题***


若对 `homeserver.yaml` 中 `public_baseurl` 项目进行了不当配置，那么在用户登陆时将出现一直同步（“Syncing forever...”）问题。报出“If you've joined lots of rooms, this might take a while.” 提示。


**解决办法**：不配置 `public_baseurl`，或将其配置为正确的内容，比如 `https://matrix.xfoss.com:443`。


***`M_LIMIT_EXCEEDED` 而无法登录***


有用户反馈，在 `element-web` 网页客户端上登录时，出现 `There was a problem communicating with homeserver, please try again later.` 原因是服务器返回了 `M_LIMIT_EXCEEDED`。


**解决办法**：往 `homeserver.yaml` 中增加如下参数：


```yaml

...

log_config: "/home/synapse/config/logging.yaml"


rc_messages_per_second: 200000
rc_message_burst_count: 100000

...

```


### `element-web`


`element-web` 是个使用了 [Matrix React SDK](https://github.com/matrix-org/matrix-react-sdk) 的 Matrix web 客户端。本质上是使用现代 ES6 并用到 Node.js 构建系统的模块化 webapp。

通过 Nginx 向用户发布（配置文件见下一小节）。其配置文件为以下两个（相同）。


- `config.json`

- `config.matrix.xfoss.com.json`


```json
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.xfoss.com",
            "server_name": "xfoss.com"
        }
    },
    "disable_custom_urls": true,
    "disable_guests": true,
    "disable_login_language_selector": false,
    "disable_3pid_login": true,
    "brand": "Element",
    "integrations_ui_url": "https://scalar.vector.im/",
    "integrations_rest_url": "https://scalar.vector.im/api",
    "integrations_widgets_urls": [
        "https://scalar.vector.im/_matrix/integrations/v1",
        "https://scalar.vector.im/api",
        "https://scalar-staging.vector.im/_matrix/integrations/v1",
        "https://scalar-staging.vector.im/api",
        "https://scalar-staging.riot.im/scalar/api"
    ],
    "default_country_code": "CN",
    "show_labs_settings": false,
    "features": {},
    "default_federate": false,
    "default_theme": "light",
    "room_directory": {
        "servers": ["matrix.org"]
    },
    "enable_presence_by_hs_url": {
        "https://matrix.org": false,
        "https://matrix-client.matrix.org": false
    },
	"settingDefaults": {
		"language": "zh_Hans"
	},
    "setting_defaults": {
        "breadcrumbs": true
    },
    "jitsi": {
        "preferred_domain": "meet.xfoss.com"
    },
    "map_style_url": "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx"
}
```

### Nginx 配置文件


Nginx 配置文件主要包含对 `matrix-synapse` 的反向代理、`element-web` 程序文件提供，以及根域名（`xfoss.com`）WWW `.well-known` 提供配置，如下所示。


*`xfoss-com.conf`*

```conf
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name xfoss.com;

    location /.well-known/matrix/server {
	    return 200 '{"m.server": "matrix.xfoss.com:443"}';
	    default_type application/json;
	    add_header Access-Control-Allow-Origin *;
    }

    location /.well-known/matrix/client {
	    return 200 '{"m.homeserver": {"base_url": "https://matrix.xfoss.com"}}';
	    default_type application/json;
	    add_header Access-Control-Allow-Origin *;
    }

    ssl_certificate /etc/ssl/certs/xfoss.com/_.xfoss.com.pem;
    ssl_certificate_key /etc/ssl/certs/xfoss.com/_.xfoss.com.privatekey.pem;
}
```


*`matrix.conf`*


```conf
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    # For the federation port
    listen 8448 ssl default_server;
    listen [::]:8448 ssl default_server;

    server_name matrix.xfoss.com;

    location ~* ^(\/_matrix|\/_synapse\/client|\/_synapse\/admin) {
        # note: do not add a path (even a single /) after the port in `proxy_pass`,
        # otherwise nginx will canonicalise the URI and cause signature verification
        # errors.
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;

        # Nginx by default only allows file uploads up to 1M in size
        # Increase client_max_body_size to match max_upload_size defined in homeserver.yaml
        client_max_body_size 50M;

        # Synapse responses may be chunked, which is an HTTP/1.1 feature.
        proxy_http_version 1.1;
    }

    location /web {
	    alias /home/it/element-v1.11.76;
    }

    ssl_certificate /etc/ssl/certs/xfoss.com/_.xfoss.com.pem;
    ssl_certificate_key /etc/ssl/certs/xfoss.com/_.xfoss.com.privatekey.pem;
}
```

可以看出，`matrix-synapse` 与 `element-web` 均运行或存在于普通用户 `it` 下，因此需要将 `it` 账号加入 `www-data` 组。

### 参考

> - [Login fails after update from 1.25.0 to 1.26.0 - syncing forever ... many rooms](https://github.com/matrix-org/synapse/issues/9264#issuecomment-770475990)




## Jitsi 部署


Jitsi Meet 是给到用户使用和部署具有最先进视频质量和功能，的视频会议平台的一套开源项目。配置较为复杂，因此选择 Docker 方式，[`jitsi/docker-jitsi-meet`](https://github.com/jitsi/docker-jitsi-meet)， 部署是较简单的方式。


### `docker-compose` 与国内镜像

Debian Bookworm 上运行 `sudo apt install -y docker-compose`，即可安装上 Docker Compose。但由于 hub.docker.com 已被屏蔽，因此要使用国内的镜像仓库。修改 `/etc/docker/daemon.json`，加入国内镜像仓库地址：


```json
{
    "registry-mirrors": [
        "https://docker.jobcher.com"
    ]
}
```



### `docker-compose` 用到的 `.env` 配置


```yaml
# 在克隆 https://github.com/jitsi/docker-jitsi-meet 代码仓库后，通过 `cp env.example .env` 得到这个 `.env` 文件。
#
# 指定将 Jitsi Meet 配置文件，保存在当前用户主目录下的 `.jitsi-meet-cfg` 隐藏目录下。
CONFIG=~/.jitsi-meet-cfg
# 指定 HTTP/HTTPS 端口
HTTP_PORT=9080
HTTPS_PORT=443
TZ=Asia/Shanghai
# 若 PUBLIC_URL 与上面的 HTTPS 不匹配，Jitsi Meet 将无法正常工作，因为其用到的 WebRTC，使用了 `wss://` （WebSocket Secure）协议。导致在开会时会议室中只能有一个人，第二个人进入时会连接会断开。
PUBLIC_URL=https://meet.xfoss.com
# 经测试在内网下，若不指定 JVB_ADVERTISE_IPS，会导致出现超过 3 人会议中没有声音的问题。
JVB_ADVERTISE_IPS=10.11.2.32
ENABLE_GUESTS=1
AUTH_TYPE=internal
ENABLE_XMPP_WEBSOCKET=1
ENABLE_HTTP_REDIRECT=1
# 这些配置项在运行 `bash gen-password.sh` 将获得随机密码。
JICOFO_AUTH_PASSWORD=
JVB_AUTH_PASSWORD=
JIGASI_XMPP_PASSWORD=
JIGASI_TRANSCRIBER_PASSWORD=
JIBRI_RECORDER_PASSWORD=
JIBRI_XMPP_PASSWORD=
# 指定后运行 `docker-compose up -d` 将拉取 stable 镜像。
JITSI_IMAGE_VERSION=stable
```



### 使用自己的 SSL 证书


为消除浏览器证书告警，需要对 Jitsi Meet 使用自己的 SSL 证书。操作方式简单粗暴，如下所示。


```console
sudo cp ~/PEM/_.xfoss.com.crt ~/.jitsi-meet-cfg/web/keys/cert.crt
sudo cp ~/PEM/_.xfoss.com.key ~/.jitsi-meet-cfg/web/keys/cert.key
```


随后打开 Jitsi Meet 网站 `https://meet.xfoss.com`，不再显示证书告警。



`docker-jitsi-meet` 的 `docker-compose.yaml` 中自带了基于 Nginx 的 web 镜像/容器，因此不必再使用 Nginx 对其进行反向代理。


### 参考

> - [Docker 搭建](https://www.erballoon.vip/2024/03/04/dockerdjkysphypt/)
>
> - [【教程】最新可用！Docker国内镜像源列表](https://blog.csdn.net/sxf1061700625/article/details/140895299)
>
> - [stable-9073: You have been disconnected / The WebSocket connection could not be established or was disconnected.](https://github.com/jitsi/docker-jitsi-meet/issues/1646#issuecomment-1925765528)
>
> - [No video and audio when 3 or more participants joining](https://github.com/jitsi/jitsi-meet/issues/14212#issuecomment-1893436766)
>
> - [Too much M_LIMIT_EXCEEDED](https://gitlab.com/guifi-exo/matrix-killspam#too-much-m_limit_exceeded)
