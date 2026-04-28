# 🍃mall学习

## 📚参考资料

- [官方文档](https://www.macrozheng.com/)
- [Gitee 源码](https://gitee.com/macrozheng/mall.git)

## 📑 目录

- [数据库分块结构总览](#数据库分块结构总览)
- [各模块详细分析](#各模块详细分析)
  - [CMS模块（内容管理系统）](#1-cms模块内容管理系统-cms_)
  - [OMS模块（订单管理系统）](#2-oms模块订单管理系统-oms_)
  - [PMS模块（商品管理系统）](#3-pms模块商品管理系统-pms_)
  - [SMS模块（营销推广系统）](#4-sms模块营销推广系统-sms_)
  - [UMS模块（用户管理系统）](#5-ums模块用户管理系统-ums_)
- [表数量统计](#表数量统计)
- [核心业务流程对应的表](#核心业务流程对应的表)
- [技术选型分析](#技术选型分析)

---

## 🗄️ 数据库理解

### 数据库分块结构总览

| 模块前缀 | 模块名称     | 表数量 | 核心职责                     |
| -------- | ------------ | ------ | ---------------------------- |
| `cms_`   | 内容管理系统 | 11张   | 帮助中心、专题、话题管理     |
| `oms_`   | 订单管理系统 | 8张    | 订单、购物车、退货、设置     |
| `pms_`   | 商品管理系统 | 20张   | 商品、库存、分类、属性、品牌 |
| `sms_`   | 营销推广系统 | 14张   | 优惠券、秒杀、首页推荐       |
| `ums_`   | 用户管理系统 | 23张   | 用户、权限、角色、积分、地址 |

---

### 各模块详细分析

### 1. CMS模块（内容管理系统）`cms_*`

**核心职责**：管理网站内容、帮助文档、专题活动、话题讨论

| 表名                                  | 说明                 |
| ------------------------------------- | -------------------- |
| `cms_help`                            | 帮助文档表           |
| `cms_help_category`                   | 帮助分类表           |
| `cms_member_report`                   | 用户举报表           |
| `cms_prefrence_area`                  | 优选专区表           |
| `cms_prefrence_area_product_relation` | 优选专区与商品关系表 |
| `cms_subject`                         | 专题表               |
| `cms_subject_category`                | 专题分类表           |
| `cms_subject_comment`                 | 专题评论表           |
| `cms_subject_product_relation`        | 专题商品关系表       |
| `cms_topic`                           | 话题表               |
| `cms_topic_category`                  | 话题分类表           |
| `cms_topic_comment`                   | 话题评论表           |

---

### 2. OMS模块（订单管理系统）`oms_*`

**核心职责**：订单生命周期管理、购物车、退货处理、订单设置

| 表名                        | 说明           |
| --------------------------- | -------------- |
| `oms_cart_item`             | 购物车表       |
| `oms_company_address`       | 公司收货地址表 |
| `oms_order`                 | 订单主表       |
| `oms_order_item`            | 订单商品表     |
| `oms_order_operate_history` | 订单操作历史表 |
| `oms_order_return_apply`    | 订单退货申请表 |
| `oms_order_return_reason`   | 退货原因表     |
| `oms_order_setting`         | 订单设置表     |

---

### 3. PMS模块（商品管理系统）`pms_*`

**核心职责**：商品信息管理、库存管理、分类管理、属性管理、品牌管理

| 表名                                      | 说明                 |
| ----------------------------------------- | -------------------- |
| `pms_album`                               | 相册表               |
| `pms_album_pic`                           | 相册图片表           |
| `pms_brand`                               | 品牌表               |
| `pms_comment`                             | 商品评论表           |
| `pms_comment_replay`                      | 评论回复表           |
| `pms_feight_template`                     | 运费模板表           |
| `pms_member_price`                        | 会员价格表           |
| `pms_product`                             | 商品表               |
| `pms_product_attribute`                   | 商品属性表           |
| `pms_product_attribute_category`          | 商品属性分类表       |
| `pms_product_attribute_value`             | 商品属性值表         |
| `pms_product_category`                    | 商品分类表           |
| `pms_product_category_attribute_relation` | 商品分类与属性关系表 |
| `pms_product_full_reduction`              | 商品满减表           |
| `pms_product_ladder`                      | 商品阶梯价格表       |
| `pms_product_operate_log`                 | 商品操作记录表       |
| `pms_product_vertify_record`              | 商品审核记录表       |
| `pms_sku_stock`                           | SKU库存表            |

---

### 4. SMS模块（营销推广系统）`sms_*`

**核心职责**：优惠券管理、秒杀活动、首页推荐、广告管理

| 表名                                   | 说明                 |
| -------------------------------------- | -------------------- |
| `sms_coupon`                           | 优惠券表             |
| `sms_coupon_history`                   | 优惠券使用历史表     |
| `sms_coupon_product_category_relation` | 优惠券商品分类关系表 |
| `sms_coupon_product_relation`          | 优惠券商品关系表     |
| `sms_flash_promotion`                  | 秒杀活动表           |
| `sms_flash_promotion_log`              | 秒杀活动记录表       |
| `sms_flash_promotion_product_relation` | 秒杀活动商品关系表   |
| `sms_flash_promotion_session`          | 秒杀场次表           |
| `sms_home_advertise`                   | 首页广告表           |
| `sms_home_brand`                       | 首页品牌推荐表       |
| `sms_home_new_product`                 | 首页新品推荐表       |
| `sms_home_recommend_product`           | 首页商品推荐表       |
| `sms_home_recommend_subject`           | 首页专题推荐表       |

---

### 5. UMS模块（用户管理系统）`ums_*`

**核心职责**：用户管理、权限管理、角色管理、积分管理、收货地址

| 表名                                   | 说明               |
| -------------------------------------- | ------------------ |
| `ums_admin`                            | 后台管理员表       |
| `ums_admin_login_log`                  | 管理员登录日志表   |
| `ums_admin_permission_relation`        | 管理员权限关系表   |
| `ums_admin_role_relation`              | 管理员角色关系表   |
| `ums_growth_change_history`            | 成长值变化历史表   |
| `ums_integration_change_history`       | 积分变化历史表     |
| `ums_integration_consume_setting`      | 积分消费设置表     |
| `ums_member`                           | 会员表             |
| `ums_member_level`                     | 会员等级表         |
| `ums_member_login_log`                 | 会员登录日志表     |
| `ums_member_member_tag_relation`       | 会员标签关系表     |
| `ums_member_product_category_relation` | 会员商品分类关系表 |
| `ums_member_receive_address`           | 会员收货地址表     |
| `ums_member_rule_setting`              | 会员规则设置表     |
| `ums_member_statistics_info`           | 会员统计信息表     |
| `ums_member_tag`                       | 会员标签表         |
| `ums_member_task`                      | 会员任务表         |
| `ums_menu`                             | 后台菜单表         |
| `ums_permission`                       | 权限表             |
| `ums_resource`                         | 资源表             |
| `ums_resource_category`                | 资源分类表         |
| `ums_role`                             | 角色表             |
| `ums_role_menu_relation`               | 角色菜单关系表     |
| `ums_role_permission_relation`         | 角色权限关系表     |
| `ums_role_resource_relation`           | 角色资源关系表     |

---

## 表数量统计

```
总表数：76张

├── CMS（内容管理）: 12张
├── OMS（订单管理）: 8张
├── PMS（商品管理）: 18张
├── SMS（营销推广）: 13张
└── UMS（用户管理）: 25张
```

---

## 核心业务流程对应的表

| 业务流程     | 核心表                                                                                       |
| ------------ | -------------------------------------------------------------------------------------------- |
| 用户注册登录 | `ums_member`, `ums_member_login_log`                                                         |
| 商品浏览     | `pms_product`, `pms_product_category`, `pms_sku_stock`                                       |
| 添加购物车   | `oms_cart_item`                                                                              |
| 下单支付     | `oms_order`, `oms_order_item`                                                                |
| 使用优惠券   | `sms_coupon`, `sms_coupon_history`                                                           |
| 积分抵扣     | `ums_member`, `ums_integration_change_history`                                               |
| 退货退款     | `oms_order_return_apply`, `oms_order_return_reason`                                          |
| 秒杀活动     | `sms_flash_promotion`, `sms_flash_promotion_session`, `sms_flash_promotion_product_relation` |

## 技术选型分析

### 一、整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                     微服务架构                              │
├─────────────────────────────────────────────────────────────┤
│  mall-admin (后台管理)  │  mall-portal (前端门户)           │
│  mall-search (搜索服务) │  mall-security (安全模块)         │
│  mall-mbg (代码生成)    │  mall-common (通用模块)           │
└─────────────────────────────────────────────────────────────┘
```

---

### 二、核心技术栈

| 分类 | 技术 | 版本 | 说明 |
|------|------|------|------|
| **语言** | Java | 1.8 | 稳定成熟，生态完善 |
| **框架** | Spring Boot | 2.7.5 | 社区成熟，生态完善 |
| **数据库** | MySQL | 8.0.29 | 主流关系型数据库 |
| **ORM** | MyBatis | 3.5.10 | SQL可控，性能优秀 |
| **缓存** | Redis | - | 分布式缓存 |
| **搜索** | Elasticsearch | - | 全文检索 |
| **消息队列** | RabbitMQ | - | 异步解耦 |
| **文档存储** | MongoDB | - | NoSQL文档数据库 |
| **文件存储** | MinIO/阿里云OSS | - | 对象存储 |
| **支付** | 支付宝 SDK | 4.38.61.ALL | 第三方支付 |

---

### 三、各模块技术选型

#### 1. mall-common（通用模块）

| 技术 | 用途 |
|------|------|
| Spring Boot Web | Web基础支持 |
| Spring Data Redis | Redis操作 |
| Spring Validation | 参数校验 |
| Logstash Logback | 日志收集 |
| Swagger | API文档 |
| PageHelper | 分页插件 |

#### 2. mall-admin（后台管理）

| 技术 | 用途 |
|------|------|
| mall-mbg | MyBatis代码生成 |
| mall-security | 安全认证 |
| 阿里云OSS | 文件上传存储 |
| MinIO | 本地文件存储 |

#### 3. mall-portal（前端门户）

| 技术 | 用途 |
|------|------|
| MongoDB | 订单日志/评论存储 |
| RabbitMQ | 延迟消息（订单超时取消） |
| 支付宝 SDK | 支付集成 |
| Spring Security + JWT | 用户认证 |

#### 4. mall-search（搜索服务）

| 技术 | 用途 |
|------|------|
| Spring Data Elasticsearch | ES操作封装 |
| mall-mbg | 数据同步 |

---

### 四、关键技术组件

#### 数据库层

```
MySQL (主库)
    ↓
MyBatis (ORM) + MyBatis Generator (代码生成)
    ↓
Druid (连接池)
```

#### 缓存层

```
Redis (热点数据缓存、分布式锁、订单号生成)
```

#### 消息队列

```
RabbitMQ (订单超时取消、异步通知)
```

#### 安全认证

```
Spring Security + JWT (无状态认证)
```

---

### 五、工具库

| 工具 | 版本 | 用途 |
|------|------|------|
| Hutool | 5.8.9 | Java工具库（日期、加密、Bean操作） |
| Lombok | - | 简化代码（@Data、@Slf4j） |
| PageHelper | 5.3.2 | MyBatis分页 |
| Swagger | 3.0.0 | API文档生成 |

---

### 六、部署与运维

| 技术 | 用途 |
|------|------|
| Docker | 容器化部署 |
| docker-maven-plugin | Maven构建镜像 |
| Spring Actuator | 健康检查、监控指标 |

---

### 七、技术选型特点总结

**优点：**

1. **技术成熟稳定**：采用Spring Boot生态，社区活跃，文档丰富
2. **架构清晰**：模块化拆分，职责分明
3. **扩展性强**：支持多种存储方案（OSS/MinIO）、多种数据库
4. **安全性高**：JWT无状态认证，权限控制完善

**技术栈组合：**

```
┌────────────────────────────────────────────────────┐
│              前端交互层                            │
├────────────────────────────────────────────────────┤
│  mall-portal (Spring Boot + JWT + RabbitMQ)       │
│  mall-search (Spring Boot + Elasticsearch)        │
├────────────────────────────────────────────────────┤
│              业务逻辑层                            │
├────────────────────────────────────────────────────┤
│  mall-admin (Spring Boot + Security)              │
│  mall-security (认证授权)                          │
├────────────────────────────────────────────────────┤
│              数据持久层                            │
├────────────────────────────────────────────────────┤
│  MySQL + Redis + MongoDB + Elasticsearch          │
└────────────────────────────────────────────────────┘
```

---

### 八、版本依赖关系

```
Spring Boot 2.7.5
    ├── Spring Security
    ├── Spring Data Redis
    ├── Spring Data MongoDB
    ├── Spring Data Elasticsearch
    └── Spring AMQP (RabbitMQ)

MyBatis 3.5.10
    ├── MyBatis Generator 1.4.1
    └── PageHelper 5.3.2

数据库驱动
    └── MySQL Connector 8.0.29

第三方服务
    ├── 支付宝 SDK 4.38.61.ALL
    ├── 阿里云 OSS 2.5.0
    └── MinIO 8.4.5

工具库
    ├── Hutool 5.8.9
    └── Lombok
```

---

### 九、技术选型评估

| 维度 | 评估 |
|------|------|
| **成熟度** | 高，所有技术均为业界主流 |
| **社区支持** | 强，Spring生态、MyBatis社区活跃 |
| **性能** | 优秀，MyBatis直接SQL，Redis缓存 |
| **可扩展性** | 良好，模块化设计，支持水平扩展 |
| **学习曲线** | 中等，需要掌握Spring Boot、MyBatis、ES等 |
| **运维成本** | 中等，容器化部署简化运维 |

