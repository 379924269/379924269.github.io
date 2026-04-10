# 华为云和阿里云服务器通过 Docker Swarm 互相连接指南

## 1. 概述

本文档详细介绍如何在华为云和阿里云服务器之间搭建 Docker Swarm 集群，实现跨云容器通信和管理。

## 2. 准备工作

### 2.1 服务器要求

- 华为云服务器：至少 1 台，推荐 2 核 4G 及以上配置
- 阿里云服务器：至少 1 台，推荐 2 核 4G 及以上配置
- 操作系统：Ubuntu 20.04 LTS 或 CentOS 7/8
- Docker 版本：20.10.0 及以上

### 2.2 网络要求

- 两台服务器能够通过公网互相访问
- 开放必要的 Docker Swarm 端口

## 3. 网络配置

### 3.1 开放端口

在华为云和阿里云的安全组中分别开放以下端口：

- **TCP 2377**：集群管理通信
- **TCP/UDP 7946**：节点间通信
- **UDP 4789**：overlay 网络通信
- **TCP 22**：SSH 连接（用于管理）

### 3.2 网络连接方式

推荐使用公网连接，配置简单且无需额外成本。

## 4. Docker Swarm 集群初始化

### 4.1 安装 Docker

在两台服务器上分别安装 Docker：

```bash
# Ubuntu
apt update && apt install -y docker.io

# CentOS
yum install -y docker
systemctl start docker
systemctl enable docker
```

### 4.2 初始化 Swarm 集群

在华为云服务器上初始化 Swarm 集群：

```bash
# 在华为云服务器上执行
docker swarm init --advertise-addr <华为云服务器公网IP>
```

执行后会生成加入命令，类似：

```bash
docker swarm join --token SWMTKN-1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx <华为云服务器公网IP>:2377
```

### 4.3 加入阿里云服务器

在阿里云服务器上执行上述生成的加入命令：

```bash
# 在阿里云服务器上执行
docker swarm join --token SWMTKN-1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx <华为云服务器公网IP>:2377
```

### 4.4 验证集群状态

在华为云服务器上执行：

```bash
docker node ls
```

如果看到两个节点都显示为 `Ready` 状态，说明集群初始化成功。

## 5. 配置 Overlay 网络

创建一个 overlay 网络，用于跨节点的容器通信：

```bash
# 在主节点（华为云）上执行
docker network create -d overlay --attachable my-overlay-network
```

## 6. 部署服务测试连接

### 6.1 部署测试服务

创建 `docker-compose.yml` 文件：

```yaml
version: '3.8'
services:
  web:
    image: nginx
    deploy:
      replicas: 2
      placement:
        constraints: [node.role == worker]
    networks:
      - my-overlay-network
    ports:
      - "80:80"
networks:
  my-overlay-network:
    external: true
```

部署服务：

```bash
docker stack deploy -c docker-compose.yml test-stack
```

### 6.2 验证跨节点通信

1. **查看服务状态**：
   
   ```bash
   docker stack services test-stack
   ```
2. **检查容器分布**：
   
   ```bash
   docker stack ps test-stack
   ```
   
   确认容器分别运行在华为云和阿里云服务器上。
3. **测试容器间通信**：
   
   ```bash
   # 获取容器 ID
   CONTAINER_ID=$(docker ps | grep test-stack_web | awk '{print $1}')
   # 进入容器
   docker exec -it $CONTAINER_ID bash
   # 测试与其他容器的通信
   ping test-stack_web
   ```

## 7. 安全加固

由于使用公网连接，建议采取以下安全措施：

1. **使用防火墙**：仅开放必要端口，限制来源 IP
2. **启用 TLS**：为 Docker Swarm 配置 TLS 加密
3. **定期更新**：及时更新 Docker 版本，修复安全漏洞
4. **使用密钥认证**：禁用密码登录，使用 SSH 密钥认证

## 8. 常见问题排查

### 8.1 节点无法加入集群

- **检查网络连通性**：使用 `ping` 和 `telnet` 测试端口是否开放
- **检查防火墙**：确保安全组规则正确配置
- **检查 Docker 版本**：确保所有节点 Docker 版本兼容

### 8.2 容器间通信失败

- **检查网络配置**：确保容器使用了正确的 overlay 网络
- **检查服务发现**：使用 `docker service inspect` 查看服务配置
- **检查网络延迟**：跨云网络可能存在较高延迟，需要调整应用超时设置

## 9. 总结

通过以上步骤，您已经成功在华为云和阿里云服务器之间搭建了 Docker Swarm 集群，实现了跨云容器通信。这种架构具有以下优势：

- **高可用性**：服务可以分布在不同云厂商的服务器上，提高容灾能力
- **弹性伸缩**：根据负载自动调整服务副本数
- **统一管理**：通过 Docker Swarm 统一管理跨云容器
- **灵活性**：可以根据需要在不同云厂商间迁移服务

## 10. 附录

### 10.1 常用 Docker Swarm 命令

- `docker swarm init`：初始化 Swarm 集群
- `docker swarm join`：加入 Swarm 集群
- `docker node ls`：查看集群节点
- `docker service create`：创建服务
- `docker service scale`：缩放服务副本数
- `docker stack deploy`：部署服务栈
- `docker stack rm`：移除服务栈

### 10.2 网络故障排查命令

- `ping <IP>`：测试网络连通性
- `telnet <IP> <端口>`：测试端口是否开放
- `docker network inspect my-overlay-network`：查看网络配置
- `docker service logs <服务名>`：查看服务日志

### 10.3 性能优化建议

- **使用本地存储**：减少网络存储延迟
- **优化容器镜像**：使用轻量级基础镜像
- **合理配置资源限制**：避免单个容器占用过多资源
- **使用健康检查**：及时发现并替换不健康的容器

通过本文档的指导，您可以构建一个跨云的 Docker Swarm 集群，为您的应用提供更高的可用性和灵活性。


