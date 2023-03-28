# Java 语言学习笔记

## 1. Eclipse IDE下，在终端运行程序报错：

```bash
$ java com.xfoss.learningJava.GameLauncher
Error: Could not find or load main class com.xfoss.learningJava.GameLauncher
Caused by: java.lang.ClassNotFoundException: com.xfoss.learningJava.GameLauncher
```

是要在 `bin` 下运行这个命令，就没有问题。

## 2. Java 程序可在终端显示彩色文字

配置下面这些常量：

```java
package com.xfoss.learningJava;

public class Constants {
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_BLACK = "\u001B[30m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_YELLOW = "\u001B[33m";
    public static final String ANSI_BLUE = "\u001B[34m";
    public static final String ANSI_PURPLE = "\u001B[35m";
    public static final String ANSI_CYAN = "\u001B[36m";
    public static final String ANSI_WHITE = "\u001B[37m";
    public static final String ANSI_BLACK_BACKGROUND = "\u001B[40m";
    public static final String ANSI_RED_BACKGROUND = "\u001B[41m";
    public static final String ANSI_GREEN_BACKGROUND = "\u001B[42m";
    public static final String ANSI_YELLOW_BACKGROUND = "\u001B[43m";
    public static final String ANSI_BLUE_BACKGROUND = "\u001B[44m";
    public static final String ANSI_PURPLE_BACKGROUND = "\u001B[45m";
    public static final String ANSI_CYAN_BACKGROUND = "\u001B[46m";
    public static final String ANSI_WHITE_BACKGROUND = "\u001B[47m";
}
```

然后这样使用：

```java
System.out.println(Constants.ANSI_GREEN + "Things to print" + Constants.ANSI_RESET);
```
