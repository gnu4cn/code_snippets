# 备忘录：NginX 和 PHP 配置

参考：[Ubuntu linux 上的 Nginx 和 Php 安装](https://techexpert.tips/zh-hans/nginx-zh-hans/ubuntu-linux-%E4%B8%8A%E7%9A%84-nginx-%E5%92%8C-php-%E5%AE%89%E8%A3%85/)

[nginx error connect to php5-fpm.sock failed (13: Permission denied)](https://stackoverflow.com/questions/23443398/nginx-error-connect-to-php5-fpm-sock-failed-13-permission-denied)


## `root` 与 `alias` 的区别

[Nginx -- static file serving confusion with root & alias](https://stackoverflow.com/questions/10631933/nginx-static-file-serving-confusion-with-root-alias)

举例来说：

```conf
location /javadoc {
    # alias /home/lennyp/learningJava/build/docs/javadoc;
    root /home/lennyp/learningJava/build/docs;
    autoindex on;
}
```

其中 `alias` 与 `root` 的作用相同!

## NginX 配置

- `/etc/nginx/nginx.conf`：

```conf
user peng peng;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
	# multi_accept on;
}

http {
	client_max_body_size 32M;
	keepalive_timeout 65;

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;
	# server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# SSL Settings
	##

	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;

	# gzip_vary on;
	# gzip_proxied any;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

	##
	# Virtual Host Configs
	##

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
```

- `/etc/nginx/sites-available/default`:

```conf
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /home/peng/www;
	# modsecurity on;
	# modsecurity_rules_file /etc/nginx/modsec/main.conf;

	# Add index.php to the list if you are using PHP
	index index.php index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
	
		# With php-fpm (or other unix sockets):
		fastcgi_pass unix:/run/php/php7.4-fpm.sock;
		# With php-cgi (or other tcp sockets):
		# fastcgi_pass 127.0.0.1:9000;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}
```


## PHP 配置

- `/etc/php/7/fpm/pool.d/www.conf`:

```conf
; Start a new pool named 'www'.
; the variable $pool can be used in any directive and will be replaced by the
; pool name ('www' here)
[www]

; Per pool prefix
; It only applies on the following directives:
; - 'access.log'
; - 'slowlog'
; - 'listen' (unixsocket)
; - 'chroot'
; - 'chdir'
; - 'php_values'
; - 'php_admin_values'
; When not set, the global prefix (or /usr) applies instead.
; Note: This directive can also be relative to the global prefix.
; Default Value: none
;prefix = /path/to/pools/$pool

; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = peng
group = peng

listen = /run/php/php7.4-fpm.sock

listen.owner = peng
listen.group = peng
pm = dynamic

pm.max_children = 5

; The number of child processes created on startup.
; Note: Used only when pm is set to 'dynamic'
; Default Value: (min_spare_servers + max_spare_servers) / 2
pm.start_servers = 2

; The desired minimum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.min_spare_servers = 1

; The desired maximum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.max_spare_servers = 3

; The number of seconds after which an idle process will be killed.
; Note: Used only when pm is set to 'ondemand'
; Default Value: 10s
;pm.process_idle_timeout = 10s;

```

## 解决：connect() to unix:/run/php/php8.1-fpm.sock failed (13: Permission denied)

参考：

- [解决：connect() to unix:/run/php/php8.1-fpm.sock failed (13: Permission denied)](https://www.cnblogs.com/workhelper/p/16212995.html)

原因是　php8.1-fpm 的apt安装使用了缺省用户www-data，nginx的apt安装使用了缺省用户nginx，/run/php/php8.1-fpm.sock的所有者是www-data, nginx用户无权访问，导致以上报错。

解决方法：把运行 nginx 的用户，添加到 `www-data` 组：

```console
$ sudo usermod -a -G www-data unisko
```

## 解决 `FastCGI sent in stderr: “Primary script unknown”`

修改 `/etc/php/8.1/fpm/pool.d/www.conf` 中的 `user` 与 `group` 设置：

```
; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = unisko
group = nginx
```

## 解决 Mozilla Firefox 报出的 `MOZILLA_PKIX_ERROR_REQUIRED_TLS_FEATURE_MISSING` 问题

参考：

- [`MOZILLA_PKIX_ERROR_REQUIRED_TLS_FEATURE_MISSING`](https://really-simple-ssl.com/mozilla_pkix_error_required_tls_feature_missing/)
- [NGINX - Enable OCSP Stapling ](https://support.globalsign.com/ssl/ssl-certificates-installation/nginx-enable-ocsp-stapling)


在 Nginx 配置文件 `/etc/nginx/nginx.conf` 的 `http` 小节，加入以下配置：

```conf
        ssl_stapling on;
        ssl_stapling_verify on;
```

## 查看 `nginx` 运行于何用户与组之下

```console
 ps aux | grep nginx | grep -v grep
```

## 出现 `File not found. ` 错误

修改 `php-fpm.ini` 配置文件中的 `user` 与 `group` 项目为正确项目。

## MySQL/MariaDB 创建数据库

```sql
create schema neo_wp default character set utf8 collate utf8_general_ci;
````
