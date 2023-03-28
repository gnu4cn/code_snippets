# Ffmpeg 使用技巧

1) 视频转 `.gif` 图片（动图）

```console
$ffmpeg -i 2022-01-10_13-15-38.mkv \
    -vf "crop=785:592:8:0,fps=10" \
    -c:v pam -f image2pipe - | convert \
    -delay 10 - \
    -loop 0 \
    -layers optimize \
    output.gif
```

2) 其中的截取整个视频中的一个区域 `crop` 参数说明

```console
crop=785:592:8:0
785:592 - 截取区域大小
8:0 - 截取区域起点（区域的左上角坐标）
```
