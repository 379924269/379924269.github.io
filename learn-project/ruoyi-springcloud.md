# 🐮ruoyi-cloud学习

## 📖参考资料

- [源码官网](https://gitee.com/y_project/RuoYi-Cloud)
- [文档官网](https://doc.ruoyi.vip/ruoyi-cloud/)

## 🌳docker-compose 部署

- [docker部署目录](https://gitee.com/y_project/RuoYi-Cloud/tree/master/docker)

## 🎯构建参数详解

❤️注意:**--build** 会强制重新构建镜像，只有在镜像有改动的时候带上。如果没有改动就**不带--build**，docker-compose会先用已有镜像，如果没有就构建

````docker
docker-compose up -d --build ruoyi-mysql
````

## 👱我怎么部署到服务器上的

- 把docker文件复制到服务器上
- 把sql文件复制到mysql的db目录；
- 把前端dist目录下的文件复制到服务器nginx的dist下面去
- 修改redis密码配置；
- 修改nacos数据库密码配置；
- 修改docker-compose.yaml nginx 暴露的端口80:80为8877:80
- 修改docker-compose.yml 数据库密码
- 修改docker-compose.yml, 由于服务资源有限，端口占用，我手动调整了映射端口，比如8080：8080 改为了 8087：8080，如果还有端口被占用自行修改
- 修改具体**服务的bootstrap.yml**的nacos连接地址配置，连接nacos的IP地址，原来是127.0.0.1 现在用服务名称**ruoyi-nacos**代替；
- 打包服务
- 把jar放到对应的docker文件夹jar下面
- 启动基础环境

  ```yml
  docker-compose up -d ruoyi-mysql ruoyi-redis ruoyi-nacos
  ```
- 运行环境启动后，**nacos**中修改对应的yaml配置，数据库密码、redis密码和host，host用容器名称，如：ruoyi-mysql,ruoyi-redis
- nacos的初始账号和密码都为nacos，生产环境注意修改nacos密码
- 启动应用模块

```docker
docker-compose up -d ruoyi-nginx ruoyi-gateway ruoyi-auth ruoyi-modules-system
```

- 访问UI界面

```url
http://192.168.0.202:8877
```

- 访问openApi文档连接

```url
http://192.168.0.202:8878/swagger-ui/index.html
```

## 🍌在docker-compose中可以使用服务名称进行通信

- 在springboot项目的yml配置中可以使用服务名称作为IP使用

  ```yml
  # Spring
  spring: 
    application:
      # 应用名称
      name: ruoyi-gateway
    profiles:
      # 环境配置
      active: dev
    cloud:
      nacos:
        discovery:
          # 服务注册地址
          server-addr: ruoyi-nacos:8848
  ```
- 当使用 `docker-compose up` 启动服务时，Docker Compose 会自动创建一个默认网络（默认名称为 `项目名_default`），并将所有服务加入这个网络。
- 在这个网络中，Docker Compose 会为每个服务创建 **DNS 记录**，服务名称就是 DNS 域名。例如：

  - 服务名称 `ruoyi-nacos` 会被解析为对应的容器 IP 地址
  - 其他服务可以通过 `ruoyi-nacos` 这个域名访问 Nacos 服务

## 🍑因为服务器资源限制，要部署在两台服务器上

- [docker swarm参考](learn-project/swarm.md)
- [k8s参考](learn-project/swarm.md)

## 🍑seata 客户端（后台服务）
参考springcloud-alibaba 官方例子
> **官方 demo**: [Spring Cloud Alibaba 集成示例](https://github.com/alibaba/spring-cloud-alibaba)  
直接把seata的demo复制过来，修改一下，就可以用在ruoyi的项目中

## 🍒issue

### 容器服务名对应容器内部端口

注意: 💓 在用容器连接的时候，比如**ruoyi-mysql**这个服务名称,它是容器内的ip地址，不是自己映射出来的端口，映射出来的端口是方便外部访问，而用容器名称连接，是同一个网络通信，用的容器内部的端口，不要改错了，比如：下面docker-compose，我们访问nacos，就用ruoyi-nacos:8848，不用7848

```yml
services:
  ruoyi-nacos:
    container_name: ruoyi-nacos
    image: nacos-server:v3.0.2
    ports:
      - "7848:8848"
```

### nacos第二次启动报错

```java
Caused by: com.mysql.cj.exceptions.CJException: Public Key Retrieval is not allowed
```

#### **原因**：

- MySQL 8.0 默认使用 `caching_sha2_password` 认证插件
- 当客户端连接时，需要检索服务器的公钥，但默认配置不允许
- 第一次启动可能使用了不同的认证方式或缓存了连接信息，第二次启动时才触发此问题

#### 解决方案

修改 `docker/nacos/conf/application.properties` 文件，在 MySQL 连接 URL 中添加 `allowPublicKeyRetrieval=true` 参数：

```properties
# 修改前
db.url.0=jdbc:mysql://ruoyi-mysql:3306/ry-config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC

# 修改后
db.url.0=jdbc:mysql://ruoyi-mysql:3306/ry-config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
```

### Nacos 配置加载顺序

- 本地配置优先级高于 Nacos 配置
- Nacos 配置中，下标越小优先级越高
- `refresh: true` 表示配置变更时可动态刷新
- 建议将公共配置放共享配置，数据库等不常变更的配置放扩展配置

### Seata docker-compose 部署的坑

按照[seata官网](https://seata.apache.org/zh-cn/docs/ops/deploy-by-docker-compose/#%E6%97%A0%E6%B3%A8%E5%86%8C%E4%B8%AD%E5%BF%83db%E5%AD%98%E5%82%A8)配置报错：
```
Web application could not be started as there was no org.springframework.boot.web.servlet.server.ServletWebServerFactory bean defined in the context.
```

#### 🔍 问题根因

这个错误表示 **应用被识别为 Web 应用，但缺少嵌入式 Servlet 容器**。根本原因通常是：

#### 1️⃣ 关键配置缺失（最常见）
在 Seata **2.x 版本** 的官方 `application.yml` 中，明确配置了：
```yaml
spring:
  application:
    name: seata-server
  main:
    web-application-type: none  # ⚠️ 这行必须存在！
```
[[11]] 如果这行配置缺失或被覆盖，Spring Boot 会默认按 Web 应用启动，但 Seata Server 本身不包含 `spring-boot-starter-web` 依赖，导致启动失败。

#### :one: 多看看官网配置
官网文档里面的连接点进去，点到**githu**上看看，选好对应的版本，看配置、看sql脚本、demo



