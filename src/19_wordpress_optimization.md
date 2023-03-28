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
$ wp --path="/home/unisko/wordpress" search-replace www.senscomm.com wp.senscomm.com --all-tables
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
