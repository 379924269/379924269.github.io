# 若依-cloud学习

## 参考资料

- [源码官网](https://gitee.com/y_project/RuoYi-Cloud)
- [文档官网](https://doc.ruoyi.vip/ruoyi-cloud/)

## docker-compose 部署

- [docker部署目录](https://gitee.com/y_project/RuoYi-Cloud/tree/master/docker)

❤️注意:加 **--build** 这样docker-compose 才会调用docker构建镜像，初始化数据库

````docker
docker-compose up -d --build ruoyi-mysql
````

## 因为服务器资源限制，要部署在两台服务器上

- [docker swarm参考](learn-project/swarm.md)

- [k8s参考](learn-project/swarm.md)

## issue

* **部署数据库没有初始化文件**

docker-compose 启动的时候注意加上 --build参数   项目就会自动构建景象了
