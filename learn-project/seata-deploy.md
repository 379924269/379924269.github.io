# Seata 2.6.0 部署指南

## 1. 概述

Seata 是阿里巴巴开源的分布式事务解决方案，支持 AT、TCC、SAGA 等事务模式。

## 2. 部署参考资料

我的部署都是参考官方文档
- [Spring Cloud Alibaba Seata 集成示例](https://github.com/alibaba/spring-cloud-alibaba/tree/master/samples/seata) 包括seata
- [Seata 官方文档](https://seata.io/zh-cn/docs/overview/what-is-seata.html)
- [Seata GitHub](https://github.com/seata/seata)
- [Spring Cloud Alibaba 版本说明](https://sca.aliyun.com/docs/2025.x/overview/version-explain/)
- [Spring Boot 集成示例](https://github.com/seata/seata-samples)

## 3. 为什么没有 "springcloud-seata" 这个 Starter

通常源于对 Spring Cloud Alibaba Seata 集成方式的误解。实际上，Spring Cloud 与 Seata 是可以且经常一起使用的，但它们不是"内置绑定"的关系，而是通过依赖和配置实现集成。

### 3.1 核心原因说明

- **Seata 并非 Spring Cloud 官方组件**，而是由阿里巴巴开源的分布式事务解决方案，后捐赠给 Apache
- **Spring Cloud Alibaba** 是 Spring Cloud 的一个扩展生态，用于整合阿里中间件（如 Nacos、Sentinel、Seata 等）

## 4. Client 服务集成

### 4.1 引入依赖

```xml
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-seata</artifactId>
</dependency>
```

### 4.2 配置 Seata 客户端

#### 4.2.1 通过文件发现配置
- [资源目录介绍](https://seata.apache.org/zh-cn/docs/ops/deploy-guide-beginner)
- [配置参考](https://github.com/apache/incubator-seata/tree/master/script)

```yml
seata:
  enabled: true  # 是否启用 Seata 客户端
  tx-service-group: default_tx_group  # 事务服务分组，对应服务端的 vgroup
  service:
    vgroup-mapping:
      default_tx_group: default  # 服务分组到集群名称的映射
    grouplist:
      default: 192.168.0.202:8091  # Seata Server 集群地址列表
    enable-degrade: false  # 是否启用降级（降级后不使用 Seata）
    disable-global-transaction: false  # 是否禁用全局事务
  registry:
    type: file  # 注册中心类型（file/nacos/eureka/consul/etcd3/zookeeper）
```

#### 4.2.2 通过 Nacos 发现配置

[参考配置](https://github.com/alibaba/spring-cloud-alibaba/blob/2.2.x/spring-cloud-alibaba-examples/seata-example/storage-service/src/main/resources/application.yml)

### 4.3 服务发现方式对比

| 对比维度 | 文件发现（file） | Nacos 发现（nacos） |
|---------|----------------|-------------------|
| **配置方式** | 本地配置文件硬编码 Server 地址 | 通过 Nacos 动态获取 Server 地址 |
| **动态性** | 静态配置，地址变更需手动修改 | 动态发现，支持服务上下线自动感知 |
| **维护成本** | 低（配置简单）但需手动维护 | 高（需搭建 Nacos）但自动维护 |
| **适用场景** | 开发测试环境、地址固定的环境 | 生产环境、集群环境、地址可能变化的场景 |
| **可靠性** | 单点故障风险（地址硬编码） | 高（支持负载均衡和故障转移） |
| **依赖** | 无额外依赖 | 依赖 Nacos 服务 |

### 4.4 适用场景

**文件发现**：
- 开发测试环境
- 单机部署场景
- 网络隔离环境（无法访问 Nacos）
- 地址固定不变的环境

**Nacos 发现**：
- 生产环境
- 集群部署场景
- 地址可能变化的环境
- 对可靠性要求高的场景

### 4.5 优缺点总结

**文件发现优点**：
- 配置简单，无额外依赖
- 适合快速搭建和测试

**文件发现缺点**：
- 缺乏动态性，维护成本高
- 不支持负载均衡和故障转移

**Nacos 发现优点**：
- 动态性强，支持自动发现和健康检查
- 可靠性高，支持负载均衡和故障转移
- 适合生产环境和集群部署

**Nacos 发现缺点**：
- 需要额外搭建和维护 Nacos 服务
- 配置相对复杂

### 4.6 选择建议
- **开发测试**：优先使用文件发现（简单快捷）
- **生产环境**：推荐使用 Nacos 发现（可靠稳定）
- **小规模部署**：可使用文件发现
- **大规模集群**：必须使用 Nacos 发现
