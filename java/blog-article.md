# 🍉Windows下JDK版本切换

- [JEnv-for-Windows工具官网源码](https://github.com/felixSelter/JEnv-for-Windows)

## 1. 安装JDK

正常到[Oracle官网](https://www.oracle.com/cn/java/technologies/downloads/#jdk26-windows)下载安装即可

## 2. 版本管理工具——jenv

Windows版本使用jenv for windows：[https://github.com/felixSelter/JEnv-for-Windows](https://github.com/felixSelter/JEnv-for-Windows)

（其他系统安装使用jenv即可，Linux可以使用 `archlinux-java` 命令）

### 安装步骤：

1. 到releases界面，下载JEnv.zip
2. 将解压路径添加到环境变量中（用户的 `path` 这个环境变量）
3. 在命令行输入jenv，运行

## 3. 配置jenv

jenv会接管java环境变量的配置，在命令行首次运行jenv后，jenv会清空所有已经存在的java环境变量，重新设置。我们需要手动将各个jdk的路径添加到jenv中，通过jenv设置环境变量。

#### 操作步骤：

1. 使用 `jenv add <name> <path>` 添加jdk
   
   ```bash
   jenv add jdk11 "C:\Program Files\Java\jdk-11.0.15.1"
   jenv add jdk17 "C:\Program Files\Java\jdk17"
   ```
2. 使用 `jenv list` 列出jdk
   
   ```bash
   jenv list
   ```
3. 使用 `jenv remove <name>` 从list中移除jdk

```bash
jenv list
```

4. 使用 `jenv change <name>` 全局切换jdk
   
   ```bash
   jenv change jdk11
   ```
   
   仅设置当前cmd窗口的jdk，设置特定路径下的jdk，参考jenv使用手册
5. 使用 `jenv link <executable>` 解决java版本与javac版本不一致
   jenv切换到jdk后，java和javac版本不一致
   使用jenv link在JAVA_HOME下创建特定版本的java链接
   
   ```bash
   cd C:\Program Files\Java\jdk-11.0.15.1\bin
   jenv link java.exe
   ```
