# 🐳Docker

欢迎来到 Docker 模块！

在这里你可以记录 Docker 相关的学习笔记、实践经验和技巧。

## 常用docker-compose 模板

> - [docker-compose](https://gitee.com/zhengqingya/docker-compose)
> 
> 常用的mysql、redis、rabbitmq等。可以一键运行的模板

- **模板使用**，要什么就直接wget、curl拉取到服务器上，应用就可以了。

```
wget https://gitee.com/zhengqingya/docker-compose/tree/master/Linux/rabbitmq
```

```curl
curl -O https://gitee.com/zhengqingya/docker-compose/tree/master/Linux/rabbitmq
```

## 学习文档

[docker教程](https://cmsblogs.cn/1003.html)

## 项目部署参考

> [ruoyi-cloud](https://gitee.com/y_project/RuoYi-Cloud/tree/master/docker)
> 后台项目部署可以像它这样,都弄成docker然后在用docker部署

## 我的测试服务器想法

把所有的环境都安装好，用docker-compose运行起来，比如redis、mysql、rabbitmq，然后放到自己定义的网络中，连接范式桥接。那以后项目都可以不用部署运行环境了。 只要在一个网络里面就可以了。

> 如：我自己定义一个网络dnp-network, mysql 加入这个网络

```yml
version: '3.8'

services:
  mysql:
    image: registry.cn-hangzhou.aliyuncs.com/zhengqing/mysql:5.7  # 原镜像`mysql:5.7`
    container_name: mysql_3306                                    # 容器名为'mysql_3306'
    restart: unless-stopped                                       # 指定容器退出后的重启策略为始终重启，但是不考虑在Docker守护进程启动时就已经停止了的容器
    volumes:                                                      # 数据卷挂载路径设置,将本机目录映射到容器目录
      - "./mysql/my.cnf:/etc/mysql/my.cnf"
      - "./mysql/init-file.sql:/etc/mysql/init-file.sql"
      - "./mysql/data:/var/lib/mysql"
#      - "./mysql/conf.d:/etc/mysql/conf.d"
      - "./mysql/log/mysql/error.log:/var/log/mysql/error.log"
      - "./mysql/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d" # 可执行初始化sql脚本的目录 -- tips:`/var/lib/mysql`目录下无数据的时候才会执行(即第一次启动的时候才会执行)
    environment:                        # 设置环境变量,相当于docker run命令中的-e
      TZ: Asia/Shanghai
      LANG: en_US.UTF-8
      MYSQL_ROOT_PASSWORD: root         # 设置root用户密码
      MYSQL_DATABASE: demo              # 初始化的数据库名称
    ports:                              # 映射端口
      - "3306:3306"
    networks:
      - dnp-network

networks:
  dnp-network:
    driver: bridge
```

## 两个docker-compose.yml中的容器相互访问

容器要互相访问，就必须在同一个网络.

容器中用**link**和**external-links**这俩个参数是遗留功能，现代的docker实践中**不推荐**使用

> 创建一个公共网络，在docker-compose中叫external：true 外部网络

```shell
docker network create dnp
```

> docker-compose.yml声明一个网络,mysql加入dnp网络

```yml
networks:
  dnp:
    driver：bridge  # 如果要指定子网和网关或驱动选项，必须显示声明
    external: true  # 声明这是外部创建的网络
    name: dnp
services:
  mysql:
    images：mysql:8.0
    networks:
      - dnp  # 指定加入的那个网络
```

