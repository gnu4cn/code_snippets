# WordPress 优化记录

## 重新 WordPress 中的一些函数

- `外观` -> `主题文件编辑器` -> `functions.php`:

```php
/* Custom translations */
add_filter('gettext', function ($translated) {
    $translated = str_ireplace('Read More', 'Learn more', $translated);
    $translated = str_ireplace('READ MORE', 'LEARN MORE', $translated);
    return $translated;
});
```

## 将类别页中的 "CATEGORY ARCHIVES: " 移除


- `外观` -> `主题文件编辑器` -> `footer.php`, 加入 JavaScript 代码：

```javascript
<script>
    var title = document.querySelector(".page-title").innerText;
    var newT = title.replace("CATEGORY ARCHIVES: ","");
    console.log(newT);
    document.querySelector(".page-title").innerHTML = newT;
</script>
```

## 博客列表显示（图片居左）的 CSS

```css
.posts-bricks-1 .posts-grid-container {
    margin-top:20px;
  margin-right: 0!important;
        display:flex;
    flex-flow:column nowrap;
    justify-content:flex-start;
    align-items:center;
}
.archive-item{
    left:auto!important;
    width:100%!important;
    max-width: 1130px!important;
    margin:auto;
    display:flex;
    flex-flow:row nowrap;
    justify-content:flex-start;
    align-items:center;
    background:#ffffff;
}
.item-image{
    width:35%;
    max-width:400px;
    padding-left: 30px;
}
.item-image img{
    max-width:100%;
}
.formatter{
    width:65%;
    max-width:730px;
}
.posts-nav .image{
    display:none;
}
@media screen and (max-width: 750px) {
    .archive-item{
        flex-flow:column nowrap;
        justify-content:flex-start;
        align-items:center;
    }
    .item-image{
        width:100%;
        max-width:100%;
        padding-left: 0;
    }
}
```

## 修正 `WPCACHEHOME` 设置项

`vim ~/wordpress/wp-config.php` 打开文件，然后将其中两行修改为：

```php
// WP_CACHE
define('WP_CACHE', true);
define( 'WPCACHEHOME', ABSPATH.'/wp-content/plugins/wp-super-cache/' );
```

## 安装和使用 `wp-cli` 工具

[WP-CLI 命令行工具](https://wp-cli.org/) 可以简化 WP 的管理，如下安装这个工具。

```console
$ curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
$ mkdir -p ~/.local/bin
$ mv wp-cli.phar ~/.local/bin/wp
$ chmod +x ~/.local/bin/wp
$ echo PATH=~/.local/bin:$PATH >> .bashrc
```

运行命令 `which wp && wp --info` 检查是否安装成功。

运行以下命令，将数据库中原来的 `www.xfoss.com`，全部替换为 `wp.xfoss.com`:

```console
$ wp --path="/home/unisko/wordpress" search-replace www.xfoss.com wp.xfoss.com --all-tables
```

运行 `wp --path="/home/unisko/wordpress" cache flush` 清除服务器上的缓存。

## 解决 `Fatal error: Uncaught Error: Call to undefined function Sphere\SGF\arrays() in ... .de/wp-content/plugins/selfhost-google-fonts/inc/file-system.php:41` 导致的页面底部错误渲染空白问题

特定情形下 （腾讯云 lighthouse）会报出这个错误，从而导致页面底部有不正常的渲染输出和报错信息。追踪到文件 `/usr/local/lighthouse/softwares/wordpress/wp-content/plugins/selfhost-google-fonts/inc/file-system.php` 的第 41 行。发现一个简单的 `arrays()` 函数调用。到这里设法卸载这个 `selfhost-google-fonts` 插件。

```console
$ wp --path="/usr/local/lighthouse/softwares/wordpress" plugin uninstall selfhost-google-fonts
Error: Cannot do 'launch': The PHP functions `proc_open()` and/or `proc_close()` are disabled. Please check your PHP ini directive `disable_functions` or suhosin settings.
```

于是修改 `php.ini`，找到并删除 `proc_open()`，并重启 `php-fpm-74.service`：

```console
$ vim /www/server/php/74/etc/php.ini
$ sudo systemctl restart php-fpm-74.service
```

再运行 `$ wp --path="/usr/local/lighthouse/softwares/wordpress" plugin uninstall selfhost-google-fonts` 即可卸载该插件。后恢复 `php.ini`，加入之前删除的 `proc_open`，并重启 `php-fmp-74.service` 服务。问题解决！


## 插入 HTML 内容时，所插入 HTML 中的全部内联样式都将被移出

因此，需要在主题样式文件中，补充所需的样式。


## `net::ERR_HTTP2_PROTOCOL_ERROR 200` 问题


在 Wordpress 文章或页面编辑中，出现 Elementor 编辑器无法编辑的情况，这是由于 `fastcgi_temp` 权限设置，限制了当前运行 Nginx/PHP-FPM 用户的打开与写入。该目录通常位于以下位置：

- `/var/cache/nginx/fastcgi_temp`
- `/www/server/nginx/fastcgi_temp` - 腾讯云 Lighthouse

修改该目录权限 `chmod`，或修改其所有者 `chown`，均可解决此问题。*注*：通过查看 Nginx 日志，即可发现此故障原因。


## Gravity Forms 表单插入

在主题文件编辑器中，编辑文章页面 `single.php`，在 `posterity_under_post_content(); ?> </div></div>` 与 `<?php posterity_posts_navigation(); ?>` 之间插入如下代码：

```html
							<br>
							<div href="javascript:void(0)" id="tclink" onclick="ljsq()" style="padding:10px 20px;background:rgb(41, 122, 216);color:#ffffff;text-decoration:none;font-size:16px;display:inline-block;margin-bottom:20px;">立即申请</div>
							<br>
							<!--<iframe id="tcif" allowtransparency="true" style="width:100%;border:none;overflow:auto;display:none;" src="http://handsometc.mikecrm.com/yjybDi3" height="850" frameborder="0"></iframe>-->

							<script>
								if(window.location.href.indexOf("press")!=-1||window.location.href.indexOf("news")!=-1){
									document.getElementById('tclink').style.display='none';
								}
								if(window.location.href.indexOf("en/jobs")!=-1){
									console.log(11111)
									document.getElementById('tclink').innerHTML='Apply now';
								}
								function ljsq(){
									if(window.location.href.indexOf("zhaopin")!=-1){
									   document.getElementById('gform_wrapper_1').style.display='block';
										document.getElementById('gform_wrapper_2').style.display='none';
									}else if(window.location.href.indexOf("en/jobs")!=-1){
										document.getElementById('gform_wrapper_1').style.display='none';
										document.getElementById('gform_wrapper_2').style.display='block';
									}
								}
							</script>
							<style>
								#gform_wrapper_1{
									display:none;
								}
								#gform_wrapper_2{
									display:none;
								}
							</style>
							<?php echo do_shortcode( '[gravityform id=1 title=false description=false ajax=true]' ); ?>
							<?php echo do_shortcode( '[gravityform id=2 title=false description=false ajax=true]' ); ?>
```

此举将 Gravity Forms 插件中的表单，插入到 文章页面。


## NginX 和 PHP 配置

参考：[Ubuntu linux 上的 Nginx 和 Php 安装](https://techexpert.tips/zh-hans/nginx-zh-hans/ubuntu-linux-%E4%B8%8A%E7%9A%84-nginx-%E5%92%8C-php-%E5%AE%89%E8%A3%85/)

[nginx error connect to php5-fpm.sock failed (13: Permission denied)](https://stackoverflow.com/questions/23443398/nginx-error-connect-to-php5-fpm-sock-failed-13-permission-denied)


### `root` 与 `alias` 的区别

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

### NginX 配置

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


### PHP 配置

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

### 解决：connect() to unix:/run/php/php8.1-fpm.sock failed (13: Permission denied)

参考：

- [解决：connect() to unix:/run/php/php8.1-fpm.sock failed (13: Permission denied)](https://www.cnblogs.com/workhelper/p/16212995.html)

原因是 `php8.1-fpm` 的 `apt` 安装使用了缺省用户 `www-data`，`nginx` 的 `apt` 安装使用了缺省用户 `nginx`，`/run/php/php8.1-fpm.sock` 的所有者是 `www-data`, `nginx` 用户无权访问，导致以上报错。

解决方法：把运行 `nginx` 的用户，添加到 `www-data` 组：

```console
$ sudo usermod -a -G www-data unisko
```

### 解决 `FastCGI sent in stderr: “Primary script unknown”`

修改 `/etc/php/8.1/fpm/pool.d/www.conf` 中的 `user` 与 `group` 设置：

```
; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = unisko
group = nginx
```

### 解决 Mozilla Firefox 报出的 `MOZILLA_PKIX_ERROR_REQUIRED_TLS_FEATURE_MISSING` 问题

参考：

- [`MOZILLA_PKIX_ERROR_REQUIRED_TLS_FEATURE_MISSING`](https://really-simple-ssl.com/mozilla_pkix_error_required_tls_feature_missing/)
- [NGINX - Enable OCSP Stapling ](https://support.globalsign.com/ssl/ssl-certificates-installation/nginx-enable-ocsp-stapling)


在 Nginx 配置文件 `/etc/nginx/nginx.conf` 的 `http` 小节，加入以下配置：

```conf
        ssl_stapling on;
        ssl_stapling_verify on;
```

### 查看 `nginx` 运行于何用户与组之下

```console
 ps aux | grep nginx | grep -v grep
```

### 出现 `File not found. ` 错误

修改 `php-fpm.ini` 配置文件中的 `user` 与 `group` 项目为正确项目。


### MySQL/MariaDB 创建数据库

```sql
create schema neo_wp default character set utf8 collate utf8_general_ci;
```


### 启用 Nginx 的 `fastcgi_cache` 特性，降低页面加载时间


参考：[Use the Nginx FastCGI Page Cache With WordPress](https://www.linode.com/docs/guides/how-to-use-nginx-fastcgi-page-cache-with-wordpress/)


此举可有效降低 URL 加载时间，以腾讯云为例，可将加载时间从 `16xxms` 降低到 `xxms`。原理是缓存 `fastcgi` 生成的内容，php 渲染 HTML 的次数，从而减少 Nginx 与 PHP 通信次数，减轻 PHP 与数据库的压力。


> **注意**：在启用了这个 `fastcgi_cache` 的 Nginx 模组后，在 Wordpress 后台点击顶部的 `Purge Cache` 并不能有效的消除缓存（至少在开启了 CDN 加速时如此），此时可手动执行 `rm -rf /var/run/cache/*`，删除那些缓存。


### 在不重新安装 Linux 下添加 `ngx_cache_purge` 模组

参考：

[ngx_cache_purge 清除 Nginx 快取](https://blog.owo9.com/p/ngx_cache_purge-clear-nginx-cache/)

此举之所以可行，是源于 Nginx 应用的模块化设计，造成的模块可插拔效果。下文提到的 `ModSecurity` 模块，亦可这样编译出来，并通过 Nginx 配置文件加载生效。


### Nginx 通过 Cerbot 获取证书注意的问题

~~在运行 `nginx -t` 检查配置文件时，若没有 `ssl_certificate` 和 `ssl_certificate_key` 字段，而 `listen` 字段中又有 `ssl` 时，就会通不过检查。此时应去掉 `listen` 中的 `ssl`。~~

经测试，需将 `listen` 整个配置行删除，才能运行  `sudo certbot --nginx -d xfoss.com` 类似命令。

参考：[Nginx: [emerg] no “ssl_certificate” is defined for the “listen … ssl” directive in /etc/nginx/sites-enabled/cockpit:1](https://community.letsencrypt.org/t/nginx-emerg-no-ssl-certificate-is-defined-for-the-listen-ssl-directive-in-etc-nginx-sites-enabled-cockpit-1/154331)


### 使用 `ModSecurity` 加固 Nginx

`ModSecurity` 是一个自由免费开源的 web 应用，最初是一个 Apache 模块，后来发展成为一个成熟的 Web 应用程序防火墙, web application firewall, WAF。它的工作原理是根据预定义的规则集，实时检查发送到 Web 服务器的请求，防止一些典型的 Web 应用程序攻击，如 XSS 和 SQL 注入。

虽然最初是一个 Apache 模块，但 `ModSecurity` 也可以安装在 Nginx 上，如本指南中所述。

参考：

- [Securing Nginx With `ModSecurity`](https://www.linode.com/docs/guides/securing-nginx-with-modsecurity/)

- [SpiderLabs/ModSecurity](https://github.com/SpiderLabs/ModSecurity)

- [SpiderLabs/ModSecurity-niginx](https://github.com/SpiderLabs/ModSecurity-nginx)


### `php-fpm` 进程 CPU 占用 `100%` 的问题

在腾讯云虚拟主机上，间歇性出现 `php-fpm`（Wordpress 网站，最新版本）CPU 使用率达到 `100%` 的现象。无法定位出是因为恶意代码还是其他原因造成。后通过编译 `php` 最新版 `8.2.6`，并修改 `/etc/rc.d/init.d/php-fpm` 启动脚本，将 `php` 指向到新编译安装的版本，后 CPU 使用率转为正常。

- `configure`、`make` 与 `make install`

```bash
$ cd php-8.2.6/
$ ./configure --prefix=/usr/local/php \
--enable-fpm --with-openssl --with-zlib \
--with-curl --enable-gd --with-webp \
--with-jpeg --with-freetype --enable-mbstring \
--with-zip --with-mysqli --with-pdo-mysql
$ make
$ sudo make install
```

- 修改 `/etc/rc.d/init.d/php-fpm`


### 使用 `phpize` 编译 PECL 扩展

```console
$ php --ini
PHP Warning:  PHP Startup: Unable to load dynamic library 'redis.so' (tried: /usr/local/lib/php/extensions/no-debug-non-zts-20220829/redis.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/redis.so: cannot open shared object file: No such file or directory), /usr/local/lib/php/extensions/no-debug-non-zts-20220829/redis.so.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/redis.so.so: cannot open shared object file: No such file or directory)) in Unknown on line 0
PHP Warning:  PHP Startup: Unable to load dynamic library 'imagick.so' (tried: /usr/local/lib/php/extensions/no-debug-non-zts-20220829/imagick.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/imagick.so: cannot open shared object file: No such file or directory), /usr/local/lib/php/extensions/no-debug-non-zts-20220829/imagick.so.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/imagick.so.so: cannot open shared object file: No such file or directory)) in Unknown on line 0
PHP Warning:  PHP Startup: Unable to load dynamic library 'igbinary.so' (tried: /usr/local/lib/php/extensions/no-debug-non-zts-20220829/igbinary.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/igbinary.so: cannot open shared object file: No such file or directory), /usr/local/lib/php/extensions/no-debug-non-zts-20220829/igbinary.so.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/igbinary.so.so: cannot open shared object file: No such file or directory)) in Unknown on line 0
PHP Warning:  PHP Startup: Unable to load dynamic library 'zip.so' (tried: /usr/local/lib/php/extensions/no-debug-non-zts-20220829/zip.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/zip.so: cannot open shared object file: No such file or directory), /usr/local/lib/php/extensions/no-debug-non-zts-20220829/zip.so.so (/usr/local/lib/php/extensions/no-debug-non-zts-20220829/zip.so.so: cannot open shared object file: No such file or directory)) in Unknown on line 0
...
```

这里显式出，`redis.so`、`imagick.so`、`igbinary.so` 及 `zip.so` 三个静态对象，static object 文件缺失。故需要经由 `phpize`、`./configure` 与 `make`，构造出这三个静态对象。

若系统中有多个 PHP 版本的安装，则需要通过像下面这样：

```bash
$ which phpize
/usr/local/bin/phpize
$ phpize
$ which php-config
/usr/local/bin/php-config
$ ./configure --with-php-config=/usr/local/bin/php-config
$ make
```

然后在 `./moduels` 目录下，就能发现相应的 `.so` 文件，将其拷贝到 PHP 安装下：

```bash
$ ls modules/
zip.la  zip.so
$ sudo cp modules/zip.so /usr/local/lib/php/extensions/
```

再次运行 `$ php --ini`，就会发现，已经不报出找不到 `zip.so` 动态库的错误。

咱们可以从 [PECL](https://pecl.php.net/)，下载到咱们需要的共享库源代码。

> **参考**：[Compiling shared PECL extensions with `phpize`](https://www.php.net/manual/en/install.pecl.phpize.php)。


### `Call to undefined function gzinflate()` 问题


在升级了 PHP 版本版本后，运行 `wp-cli` 更新 WP 的插件、核心时，报出了这个问题。需要在 PHP 源码下，编译 `zlib.so`，并将这个静态对象，拷贝到 `/usr/local/lib/php/extensions/no-debug-non-zts-yyyymmdd` 目录。步骤如下：


```bash
$ cd php-8.2.x/ext/zlib
$ cp config0.m4 config.m4
$ phpize
$ ./configure --with-php-config=/usr/local/php/bin/php-config --with-zlib
$ make
$ sudo cp modules/zlib.so /usr/local/lib/php/extensions/no-debug-non-zts-20220829/zlib.so
```

注意要从与正使用的 PHP 版本源码，编译拷贝这个 `zlib.so`。否则会报出


```console
PHP Warning:  PHP Startup: Invalid library (maybe not a PHP library) 'zlib.so' in Unknown on line 0
```

无效库错误。


> **参考**：[`Fatal error: Uncaught Error: Call to undefined function gzinflate() in`](https://www.xxzhuti.com/791.html)


### `wp core update` 时 `No working transport found` 问题

这是由于在 `/usr/local/lib/php.ini` 配置文件中，未开启 `extension=openssl`；且缺少了相应的 `openssl.so` 静态对象文件。

需参考上面的 `zlib.so` 编译，对 `ext/openssl` 进行编译，并在 `php.ini` 中开启 `extension = openssl`，随后问题解决。


**参考**：[Installation failed: Download failed. No working transports found](https://wordpress.stackexchange.com/a/301227)。
