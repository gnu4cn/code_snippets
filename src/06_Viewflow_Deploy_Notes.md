# 部署 ViewFlow 问题记录

1、在运行

`./manage.py makemigrations helloworld`

时报错的处理：

是因为在文件 `demo/helloworld/apps.py`中，`name`错误造成的，将原始的`name`修改为`demo.helloworld`就可以了
