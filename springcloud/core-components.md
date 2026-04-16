# 核心组件

## 版本信息

- **Spring Cloud 版本**: 2025.1.0
- **Spring Cloud Alibaba 版本**: 2025.1.0.0
- **Spring Boot Admin 版本**: 4.0.2

Spring Cloud Alibaba 提供了一系列核心组件，用于构建和管理微服务架构。以下是主要的核心组件：

> **官方文档**: [Spring Cloud Alibaba](https://spring.io/projects/spring-cloud-alibaba) | [Spring Cloud](https://spring.io/projects/spring-cloud)
> **版本适配**: [Spring Cloud Alibaba 版本说明](https://sca.aliyun.com/docs/2025.x/overview/version-explain/) - 查看 Spring Cloud 与 Spring Cloud Alibaba 版本适配，以及各组件版本对应关系


## Spring Cloud Alibaba 组件

### Nacos

**Nacos** ([官方网站](https://nacos.io/)) 是一个服务注册与发现和配置中心组件,提供了以下功能:

- **服务注册与发现**：支持服务的注册、发现和健康检查
- **配置中心**：集中管理配置信息，支持动态刷新
- **服务管理**：提供服务的元数据管理和服务治理功能
- **高可用**：支持集群部署，提高服务的可用性

### Sentinel

**Sentinel** ([官方网站](https://sentinelguard.io/)) 是一个流量控制和熔断降级组件,提供了以下功能:

- **流量控制**：支持基于QPS、并发数等指标的流量控制
- **熔断降级**：当服务调用失败率达到阈值时，自动熔断，避免级联失败
- **系统保护**：保护系统不被过载，确保系统的稳定性
- **实时监控**：提供实时的监控和统计信息

### RocketMQ

**RocketMQ** ([官方网站](https://rocketmq.apache.org/)) 是一个高性能的消息中间件,提供了以下功能:

- **可靠的消息传递**：支持消息的持久化和可靠传递
- **高吞吐量**：支持高并发的消息处理
- **消息顺序**：支持消息的顺序消费
- **事务消息**：支持分布式事务消息

### Dubbo

**Dubbo** ([官方网站](https://dubbo.apache.org/)) 是一个高性能的RPC框架,提供了以下功能:

- **服务治理**：支持服务的注册、发现和负载均衡
- **高性能**：基于Netty的高性能RPC调用
- **丰富的扩展**：支持多种协议和序列化方式
- **服务监控**：提供服务的监控和统计信息

### Seata

**Seata** ([官方网站](https://seata.io/)) 是一个分布式事务解决方案,提供了以下功能:

- **AT模式**：基于两阶段提交的分布式事务解决方案
- **TCC模式**：基于补偿机制的分布式事务解决方案
- **SAGA模式**：基于状态机的长事务解决方案
- **XA模式**：基于数据库XA协议的分布式事务解决方案

## Spring Boot Admin

**Spring Boot Admin** ([官方网站](https://codecentric.github.io/spring-boot-admin/current/)) 是一个用于管理和监控 Spring Boot 应用的工具:

- **应用监控**：监控应用的健康状态、性能指标等
- **日志查看**：查看应用的日志信息
- **环境信息**：查看应用的环境变量和配置信息
- **JVM 信息**：查看应用的 JVM 状态和内存使用情况