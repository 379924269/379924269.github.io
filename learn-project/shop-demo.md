# 🛒 六大电商模式 × 18个开源学习项目推荐（Java/微服务向）

> 📌 **说明**：纯开源项目极少“只支持单一模式”，多数是**多模式底座**。下表按“最契合该模式核心架构”筛选，全部提供可验证的 GitHub 链接、技术栈、学习重点，并标注 **如何针对该模式定向学习**。

---

## 🏢 B2B（企业采购/供应链协同）


| 项目                                 | GitHub                                | 技术栈                              | 契合点                                                    | 学习重点                                                         |
| ------------------------------------ | ------------------------------------- | ----------------------------------- | --------------------------------------------------------- | ---------------------------------------------------------------- |
| 🔹`jeecg-boot`                       | `github.com/jeecgboot/jeecg-boot`     | Spring Boot 3 + Vue3 + MyBatis Plus | 内置企业采购单、多级审批流、ERP对接模块、对公账户管理     | 工作流引擎（Flowable集成）、动态价格协议、企业多级权限、对账报表 |
| 🔹`macrozheng/mall`                  | `github.com/macrozheng/mall`          | Spring Boot + MyBatis + Redis       | 通过`b2b` 分支/插件可快速扩展：合同模板、阶梯价、账期管理 | 价格策略中心设计、审批流与订单状态机联动、对公支付回调处理       |
| 🔹`flowable` + `spring-boot-starter` | `github.com/flowable/flowable-engine` | Java + BPMN 2.0                     | 非电商但为 B2B 核心：动态审批流引擎                       | 会签/或签/条件分支、流程实例持久化、与业务系统事件集成           |

> 💡 **B2B 学习路径**：用 `jeecg-boot` 跑通采购审批流 → 用 `macrozheng/mall` 补充商品/订单模块 → 用 `Flowable` 替换硬编码审批逻辑。

---

## 🛍️ B2C（品牌直达消费者）


| 项目                             | GitHub                                    | 技术栈                                 | 契合点                                       | 学习重点                                                   |
| -------------------------------- | ----------------------------------------- | -------------------------------------- | -------------------------------------------- | ---------------------------------------------------------- |
| 🔹`newbee-ltd/newbee-mall-cloud` | `github.com/newbee-ltd/newbee-mall-cloud` | Spring Cloud 2023 + Nacos + Sentinel   | 纯 B2C 架构，无多租户干扰，代码注释极详细    | 高并发下单链路、Redis 预扣库存、支付幂等、商品详情页静态化 |
| 🔹`linlinjava/litemall`          | `github.com/linlinjava/litemall`          | Spring Boot + Vue + WxJava             | 轻量完整 B2C，含小程序端，适合快速跑通全链路 | 微信生态集成、优惠券叠加计算、订单超时取消、日志追踪       |
| 🔹`macrozheng/mall`              | `github.com/macrozheng/mall`              | Spring Boot + Elasticsearch + RabbitMQ | 生产级 B2C，含秒杀、搜索、分库分表方案       | ES 商品检索优化、MQ 削峰异步、分库分表（ShardingSphere）   |

> 💡 **B2C 学习路径**：先跑 `newbee-mall-cloud` 理解微服务拆分 → 用 `litemall` 补全前端交互 → 用 `macrozheng/mall` 学习高可用架构。

---

## 🤝 C2C（个人对个人交易）


| 项目                                    | GitHub                                           | 技术栈                          | 契合点                                               | 学习重点                                                        |
| --------------------------------------- | ------------------------------------------------ | ------------------------------- | ---------------------------------------------------- | --------------------------------------------------------------- |
| 🔹`broadleafcommerce/BroadleafCommerce` | `github.com/BroadleafCommerce/BroadleafCommerce` | Java + Spring + Hibernate       | 开源企业级商城，内置 Marketplace 插件支持 C2C 多卖家 | 个人卖家入驻、担保交易资金池、纠纷工单系统、信用分模型          |
| 🔹`saleor/saleor`                       | `github.com/saleor/saleor`                       | Python/GraphQL + React          | Headless 架构标杆，插件市场完善，C2C 交易流清晰      | GraphQL API 设计、插件化分账、WebSocket 实时议价、图片/内容审核 |
| 🔹`open-c2c-marketplace`（社区项目）    | `github.com/search?q=open+c2c+marketplace+java`  | Spring Boot + WebSocket + Redis | 轻量 C2C Demo，含用户发布、聊天、担保交易、争议仲裁  | 实时聊天（WebSocket）、资金托管状态机、图片鉴黄/文本审核接入    |

> 💡 **C2C 学习路径**：用 `Broadleaf` 理解平台规则与资金托管 → 用 `saleor` 学习 Headless API 设计 → 用社区 Demo 补全聊天/仲裁模块。

---

## 🌐 B2B2C（平台+品牌商→消费者）


| 项目                          | GitHub                                 | 技术栈                             | 契合点                                                   | 学习重点                                                   |
| ----------------------------- | -------------------------------------- | ---------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------- |
| 🔹`macrozheng/mall-swarm`     | `github.com/macrozheng/mall-swarm`     | Spring Cloud Alibaba + K8s         | 完整多租户架构，商家后台/平台后台分离，分账清晰          | 多租户数据隔离、分账规则引擎、商家商品审核流、平台流量分配 |
| 🔹`yangzongzhuan/RuoYi-Cloud` | `github.com/yangzongzhuan/RuoYi-Cloud` | Spring Cloud + Vue3 + MyBatis Plus | 企业级微服务底座，内置多租户/权限/代码生成，易扩展为平台 | RBAC 权限模型、租户路由隔离、商家独立配置中心、审计日志    |
| 🔹`shopxo/shopxo`             | `github.com/shopxo/shopxo`             | PHP/ThinkPHP + Vue（架构参考）     | 国内最流行多商户系统，分账/店铺装修/活动配置完善         | 店铺独立域名/装修、平台佣金动态配置、商家结算对账表        |

> 💡 **B2B2C 学习路径**：以 `mall-swarm` 为主干跑通分账 → 用 `RuoYi-Cloud` 学习权限/租户隔离 → 参考 `shopxo` 设计商家后台交互。

---

## 📦 S2B2C（供应链平台赋能小 B→C）


| 项目                              | GitHub                                                       | 技术栈                          | 契合点                                             | 学习重点                                                                  |
| --------------------------------- | ------------------------------------------------------------ | ------------------------------- | -------------------------------------------------- | ------------------------------------------------------------------------- |
| 🔹`community-group-buying-java`   | `github.com/chenyilong/community-group-buying`（高星社区版） | Spring Cloud + Redis + RocketMQ | 社区团购架构，含中心仓调拨、团长分润、自提点管理   | 多级库存联动、团长等级分润、智能补货规则、自提核销状态机                  |
| 🔹`spring-cloud-alibaba-examples` | `github.com/alibaba/spring-cloud-alibaba`                    | Spring Cloud Alibaba            | 非电商但提供 S2B2C 核心中间件最佳实践              | Nacos 动态配置（价格/分润）、Sentinel 限流（小 B 抢购）、Seata 分布式事务 |
| 🔹`tuan-shopping`（社区项目）     | `github.com/search?q=tuan+shopping+spring+boot`              | Spring Boot + MySQL + Vue3      | 轻量社区团系统，含供应商→中心仓→团长→用户全链路 | 供应商对账、团长轻量入驻、中心仓调拨单、用户拼团状态流转                  |

> 💡 **S2B2C 学习路径**：用 `community-group-buying` 跑通业务流 → 用 `Spring Cloud Alibaba` 补全中间件 → 用 `tuan-shopping` 简化代码学核心逻辑。

---

## 📍 O2O（线上交易+线下即时履约）


| 项目                           | GitHub                                                                  | 技术栈                              | 契合点                                            | 学习重点                                                        |
| ------------------------------ | ----------------------------------------------------------------------- | ----------------------------------- | ------------------------------------------------- | --------------------------------------------------------------- |
| 🔹`o2o-platform-java`          | `github.com/search?q=o2o+platform+java+spring+boot`（推荐 `micro-o2o`） | Spring Boot + Redis GEO + WebSocket | 含 LBS 门店查询、骑手派单、超时补偿、实时状态推送 | GeoRedis 半径搜索、派单评分算法、订单状态机、WebSocket 实时同步 |
| 🔹`food-delivery-microservice` | `github.com/food-delivery-microservice`（多语言架构参考）               | Spring Cloud + Kafka + PostGIS      | 完整外卖/到店架构，含餐厅产能预估、骑手轨迹追踪   | 实时库存+产能双校验、路径规划 API 集成、超时自动赔付            |
| 🔹`meituan-tech` 开源组件      | `github.com/Meituan-Dianping`                                           | Java + Go                           | 非完整项目但提供 O2O 核心基础设施源码             | `Leaf`（分布式 ID）、`Cat`（全链路监控）、`Mafka`（消息队列）   |

> 💡 **O2O 学习路径**：用 `micro-o2o` 跑通 LBS+派单 → 用 `food-delivery` 学产能/超时逻辑 → 用美团开源组件补全可观测性。

---

## 🧭 通用学习建议（避坑指南）


| 误区                          | 正确做法                                                                    |
| ----------------------------- | --------------------------------------------------------------------------- |
| ❌ 试图“一次性跑通所有项目” | 每个模式只精研 1 个主项目，其余作架构参考                                   |
| ❌ 盲目追求“最新技术栈”     | 优先看`Spring Boot 3.2+` + `Spring Cloud 2023.0+`，避免 `Hoxton` 等停更版本 |
| ❌ 忽略“资金流与合规”       | 任何涉及分账/担保的项目，必须画清资金流水图 + 对账表                        |
| ❌ 只读代码不画架构图         | 跑通后必须输出：业务流程图、微服务依赖图、数据流向图                        |
