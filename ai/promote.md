# 怎么写promote
我一般都是把我的需求给AI，让AI给我写提示词，然后反复对话修改提示词。

---
## 项目迁移
### 我向AI提问
```` txt
我的项目是struts的 现在想升级到springboot 希望原功能不变 怎么写promotes 
````
### AI 给我写提示词 
我和AI反复对话，直到得到满意的提示词
```` txt
# 🧑‍💻 角色设定
请你担任资深 Java 架构师与 Spring Boot 迁移专家。我现在有一个基于 Struts 的遗留 Web 项目，计划平滑迁移至 Spring Boot。要求**业务功能零变更、数据一致性不破坏、核心接口行为完全一致**。请提供可落地的迁移方案。

# 📦 项目现状（请根据你的项目替换）
- Struts 版本：[例：Struts 2.5.30 / Struts 1.x]
- Java 版本：[例：JDK 8 / JDK 11]
- 构建工具：[例：Maven 3.6 / Ant]
- 视图技术：[例：JSP + Struts Tags / FreeMarker / 无前端框架]
- 数据库/ORM：[例：MySQL 5.7 + MyBatis 3.4 / Hibernate / 原生 JDBC]
- 核心规模：[例：约 45 个 Action、120 个 JSP、3 个自定义 Interceptor、无 Spring 集成]
- 部署环境：[例：外部 Tomcat 9 / WebLogic / Docker]

# 🎯 迁移目标与硬性约束
1. 原功能 100% 保留：路由映射、表单提交、文件上传、分页、权限校验、错误处理等行为必须一致
2. 不引入非标准第三方库：优先使用 Spring Boot 官方生态，避免增加维护成本
3. 支持渐进式迁移：若无法一次性全量替换，需提供 Struts 与 Spring Boot 共存方案（如双路由并行/网关分流）
4. 代码改造范围明确：指出哪些文件可直接复用、哪些必须重写、哪些可保留兼容
5. 输出必须可执行：包含配置对照表、代码映射示例、测试验证清单、回滚预案

# 📋 期望输出内容（请按此结构分块回答）
1. 🗺️ 架构映射对照表（Struts 概念 → Spring Boot 等价实现）
2. 🛠️ 核心改造清单（按优先级排序：路由/Controller、数据绑定、校验、拦截器、视图、静态资源、异常处理）
3. 💻 关键代码转换示例（至少包含：Action → @Controller、struts.xml → @RequestMapping/配置类、Interceptor → HandlerInterceptor/Filter）
4. ⚙️ 配置迁移指南（web.xml/struts.xml → application.yml + Java Config，含 Tomcat 内嵌适配）
5. 🧪 零功能变更验证方案（接口对比测试、表单提交复现、文件上传校验、数据库事务一致性检查）
6. ⚠️ 高风险陷阱清单（如 Struts 标签依赖、OGNL 表达式、Action 线程安全、Session 管理、字符编码）
7. 🔄 渐进迁移策略（推荐 Strangler Fig 模式：新旧共存路由配置、灰度切换步骤、回滚触发条件）

# 📌 输出要求
- 使用 Markdown 表格/代码块清晰排版
- 所有代码示例需标注适用 Spring Boot 版本（建议 2.7.x 或 3.x）
- 避免泛泛而谈，直接给出可粘贴运行的片段或配置
- 若某项需人工确认，请明确标出 `[需人工核对]`
- 最后附一份「迁移 CheckList」供团队逐项打勾

````
