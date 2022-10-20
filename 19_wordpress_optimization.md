# WordPress 优化记录

1. 重新 WordPress 中的一些函数。

`外观` -> `主题文件编辑器` -> `functions.php`:

```php
/* Custom translations */
add_filter('gettext', function ($translated) {
    $translated = str_ireplace('Read More', 'Learn more', $translated);
    $translated = str_ireplace('READ MORE', 'LEARN MORE', $translated);
    return $translated; 
});   
```

2. 将类别页中的 "CATEGORY ARCHIVES: " 移除。


`外观` -> `主题文件编辑器` -> `footer.php`:

加入 JavaScript 代码：

```javascript
<script>
var title = document.querySelector(".page-title").innerText;
var newT = title.replace("CATEGORY ARCHIVES: ","");
console.log(newT);
document.querySelector(".page-title").innerHTML = newT;
</script>
```

3. 博客列表显示（图片居左）的 CSS。

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
