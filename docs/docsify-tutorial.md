# Docsify 完整教程

> 从入门到精通的完整指南

## 目录

- [环境准备](#环境准备)
- [Docsify简介](#docsify简介)
- [项目初始化](#项目初始化)
- [目录结构](#目录结构)
- [配置详解](#配置详解)
- [导航与侧边栏](#导航与侧边栏)
- [Markdown编写](#markdown编写)
- [代码高亮与数学公式](#代码高亮与数学公式)
- [插件系统](#插件系统)
- [本地预览](#本地预览)
- [部署上线](#部署上线)
- [常见问题](#常见问题)
- [最佳实践](#最佳实践)

## 环境准备

### Node.js 安装

Docsify 本身不需要 Node.js，但为了更好的开发体验，建议安装 Node.js 环境。

#### 安装步骤

1. **下载 Node.js**
   - 访问 [Node.js 官网](https://nodejs.org/)
   - 推荐下载 LTS 版本（长期支持版本）
   - 当前推荐版本：v18.x 或 v20.x

2. **验证安装**
   ```bash
   node --version
   npm --version
   ```
   
   预期输出：
   ```
   v20.10.0
   10.2.3
   ```

3. **配置 npm 镜像（可选）**
   ```bash
   npm config set registry https://registry.npmmirror.com
   ```

### 环境要求

- **浏览器**：支持 ES5 的现代浏览器（Chrome、Firefox、Safari、Edge）
- **Node.js**：v14.x 或更高版本（可选）
- **npm**：v6.x 或更高版本（可选）

## Docsify 简介

### 什么是 Docsify？

Docsify 是一个神奇的文档网站生成器，它不会将 Markdown 转换为 HTML，而是在运行时动态解析和渲染 Markdown。

### 核心特性

- 📝 **零配置**：无需编译，直接运行
- 🚀 **快速启动**：一个 HTML 文件即可开始
- 🎨 **主题丰富**：内置多种主题，支持自定义
- 🔌 **插件生态**：丰富的插件扩展功能
- 📱 **响应式**：完美适配移动端
- 🔍 **搜索功能**：内置全文搜索

### 适用场景

- 技术文档
- API 文档
- 个人博客
- 项目说明
- 知识库

## 项目初始化

### 方法一：快速开始（推荐）

1. **创建项目目录**
   ```bash
   mkdir my-docs
   cd my-docs
   ```

2. **初始化 HTML 文件**
   创建 `index.html` 文件：

   ```html
   <!DOCTYPE html>
   <html lang="zh-CN">
   <head>
     <meta charset="UTF-8">
     <title>我的文档</title>
     <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify@4/lib/themes/vue.css">
   </head>
   <body>
     <div id="app"></div>
     <script>
       window.$docsify = {
         name: '我的文档'
       }
     </script>
     <script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
   </body>
   </html>
   ```

3. **创建首页文档**
   创建 `README.md` 文件：

   ```markdown
   # 欢迎使用 Docsify
   
   这是我的第一个 Docsify 文档网站！
   ```

4. **本地预览**
   ```bash
   # 使用 Python 启动简单服务器
   python -m http.server 8000
   
   # 或使用 Node.js 的 http-server
   npx http-server -p 8000
   ```

### 方法二：使用 CLI 工具

1. **全局安装 Docsify CLI**
   ```bash
   npm i docsify-cli -g
   ```

2. **初始化项目**
   ```bash
   docsify init ./my-docs
   ```

3. **启动本地服务器**
   ```bash
   cd my-docs
   docsify serve .
   ```

## 目录结构

### 推荐的项目结构

```
my-docs/
├── index.html              # 入口文件
├── README.md              # 首页文档
├── _coverpage.md          # 封面页面
├── _sidebar.md            # 自定义侧边栏
├── _navbar.md            # 自定义导航栏
├── docs/                 # 文档目录
│   ├── guide/            # 指南文档
│   ├── api/              # API 文档
│   └── examples/         # 示例代码
├── static/               # 静态资源
│   ├── css/              # 自定义样式
│   ├── js/               # 自定义脚本
│   └── images/          # 图片资源
└── .nojekyll             # 禁用 Jekyll（GitHub Pages）
```

### 文件命名规范

- `README.md`：首页文档
- `_sidebar.md`：侧边栏配置
- `_navbar.md`：导航栏配置
- `_coverpage.md`：封面页面
- 其他 `.md` 文件：普通文档页面

## 配置详解

### 基本配置

```javascript
window.$docsify = {
  // 文档名称
  name: '我的文档',
  
  // 仓库地址（显示 GitHub 图标）
  repo: 'https://github.com/username/repo',
  
  // 最大层级
  maxLevel: 6,
  
  // 子目录最大层级
  subMaxLevel: 3,
  
  // 首页
  homepage: 'README.md',
  
  // 封面页
  coverpage: true,
  
  // 只显示封面
  onlyCover: false,
  
  // 加载提示
  loadSidebar: true,
  
  // 加载导航栏
  loadNavbar: true,
  
  // 自动生成侧边栏
  autoHeader: true,
  
  // 执行脚本
  executeScript: true,
  
  // 搜索配置
  search: {
    maxAge: 86400000,           // 缓存时间（毫秒）
    paths: 'auto',               // 搜索路径
    placeholder: '搜索',          // 占位符
    noData: '没有找到结果',       // 无结果提示
    depth: 6                     // 搜索深度
  },
  
  // 分页配置
  pagination: {
    previousText: '上一章',
    nextText: '下一章',
    crossChapter: true,
    crossChapterText: true
  },
  
  // 复制代码
  copyCode: {
    buttonText: '复制',
    errorText: '错误',
    successText: '复制成功'
  },
  
  // 字数统计
  count: {
    countable: true,
    fontsize: '0.9em',
    color: 'rgb(90, 90, 90)',
    language: 'chinese'
  }
}
```

### 主题配置

```javascript
window.$docsify = {
  // 内置主题
  // vue.css（默认）、buble.css、dark.css、pure.css
  themeColor: '#3eaf7c',
  
  // 自定义主题色
  themeColor: '#42b983'
}
```

### 路由配置

```javascript
window.$docsify = {
  // 基础路径
  basepath: '/docs/',
  
  // 相对路径
  relativePath: false,
  
  // 外部链接
  externalLinkTarget: '_blank',
  
  // 路由模式
  routerMode: 'history'
}
```

## 导航与侧边栏

### 自定义导航栏

创建 `_navbar.md` 文件：

```markdown
* [首页](/)
* [指南](guide/)
* [API](api/)
* [关于](about/)
* [GitHub](https://github.com/username/repo)
```

### 自定义侧边栏

创建 `_sidebar.md` 文件：

```markdown
* [快速开始](quick-start)
  * [安装](quick-start/installation)
  * [配置](quick-start/configuration)
* [基础功能](basic)
  * [导航](basic/navigation)
  * [侧边栏](basic/sidebar)
* [高级特性](advanced)
  * [插件](advanced/plugins)
  * [主题](advanced/themes)
```

### 嵌套侧边栏

```markdown
* 指南
  * [快速开始](guide/quick-start)
  * [基础配置](guide/basic-config)
* API 文档
  * [用户接口](api/user)
  * [数据接口](api/data)
* 示例
  * [Vue 示例](examples/vue)
  * [React 示例](examples/react)
```

## Markdown 编写

### 基础语法

```markdown
# 一级标题
## 二级标题
### 三级标题

**粗体文本**
*斜体文本*
~~删除线~~

> 引用文本

- 无序列表项
- 无序列表项

1. 有序列表项
2. 有序列表项

[链接文本](https://example.com)

![图片描述](image.jpg)
```

### 代码块

```markdown
\```javascript
function hello() {
  console.log('Hello, Docsify!');
}
\```

\```python
def hello():
    print("Hello, Docsify!")
\```
```

### 表格

```markdown
| 列1 | 列2 | 列3 |
|------|------|------|
| 内容1 | 内容2 | 内容3 |
| 内容4 | 内容5 | 内容6 |
```

### 任务列表

```markdown
- [x] 已完成任务
- [ ] 未完成任务
- [ ] 进行中任务
```

### 脚注

```markdown
这是正文内容[^1]

[^1]: 这是脚注内容
```

### Emoji 支持

```markdown
😊 😎 🚀 🎉
```

## 代码高亮与数学公式

### 代码高亮配置

Docsify 默认使用 Prism.js 进行代码高亮，支持多种语言。

```javascript
window.$docsify = {
  // 代码高亮配置
  notFoundPage: {
    '/': '404.html'
  },
  
  // 代码高亮
  plugins: [
    function(hook, vm) {
      hook.beforeEach(function(content) {
        return content;
      });
    }
  ]
}
```

### 支持的编程语言

- JavaScript / TypeScript
- Python / Java / C++
- HTML / CSS / SCSS
- SQL / Shell / Bash
- Go / Rust / Swift
- 等等...

### 数学公式支持

引入 KaTeX 插件：

```html
<!-- KaTeX CSS -->
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.css" />

<!-- KaTeX JS -->
<script src="//cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/katex@latest/dist/contrib/auto-render.min.js"></script>

<!-- Docsify KaTeX 插件 -->
<script src="//cdn.jsdelivr.net/npm/docsify-katex@latest/dist/docsify-katex.js"></script>
```

使用数学公式：

```markdown
行内公式：$E = mc^2$

块级公式：
$$
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

## 插件系统

### 搜索插件

```html
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify/lib/themes/vue.css">
<script src="//cdn.jsdelivr.net/npm/docsify@4"></script>
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/search.min.js"></script>
```

配置：

```javascript
window.$docsify = {
  search: {
    maxAge: 86400000,
    paths: 'auto',
    placeholder: '搜索',
    noData: '没有找到结果',
    depth: 6,
    hideOtherSidebarContent: false,
    namespace: 'docsify-example'
  }
}
```

### 字数统计插件

```html
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/emoji.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/front-matter.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/docsify-count@latest/dist/countable.min.js"></script>
```

配置：

```javascript
window.$docsify = {
  count: {
    countable: true,
    position: 'top',
    margin: '10px',
    float: 'right',
    fontsize: '0.9em',
    color: 'rgb(90, 90, 90)',
    language: 'chinese',
    localization: {
      words: "",
      minute: ""
    }
  }
}
```

### 复制代码插件

```html
<script src="//cdn.jsdelivr.net/npm/docsify-copy-code@2"></script>
```

配置：

```javascript
window.$docsify = {
  copyCode: {
    buttonText: '复制',
    errorText: '错误',
    successText: '复制成功'
  }
}
```

### 分页插件

```html
<script src="//cdn.jsdelivr.net/npm/docsify-pagination/dist/docsify-pagination.min.js"></script>
```

配置：

```javascript
window.$docsify = {
  pagination: {
    previousText: '上一章',
    nextText: '下一章',
    crossChapter: true,
    crossChapterText: true,
    containerClass: 'pagination'
  }
}
```

### Emoji 插件

```html
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/emoji.min.js"></script>
```

使用：

```markdown
:smile: :heart: :rocket: :star:
```

### 缩放图片插件

```html
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>
```

### Gitalk 评论插件

```html
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/gitalk/dist/gitalk.css">
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/gitalk.min.js"></script>
```

配置：

```javascript
window.$docsify = {
  gitalk: {
    clientID: 'GitHub Application Client ID',
    clientSecret: 'GitHub Application Client Secret',
    repo: 'GitHub repo',
    owner: 'GitHub repo owner',
    admin: ['GitHub repo owner and collaborators, only these guys can initialize github issues'],
    distractionFreeMode: true
  }
}
```

## 本地预览

### 使用 Python

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```

### 使用 Node.js

```bash
# 安装 http-server
npm install -g http-server

# 启动服务器
http-server -p 8000 -o
```

### 使用 Docsify CLI

```bash
# 全局安装
npm i docsify-cli -g

# 启动服务器
docsify serve .
```

### 使用 VS Code Live Server

1. 安装 Live Server 扩展
2. 右键点击 `index.html`
3. 选择 "Open with Live Server"

### 预览地址

打开浏览器访问：
- `http://localhost:8000`
- `http://127.0.0.1:8000`

## 部署上线

### GitHub Pages 部署

#### 方法一：直接推送

1. **创建 GitHub 仓库**
   - 访问 https://github.com/new
   - 创建新仓库

2. **推送代码**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/username/repo.git
   git push -u origin main
   ```

3. **启用 GitHub Pages**
   - 进入仓库 Settings
   - 找到 Pages 部分
   - Source 选择 `Deploy from a branch`
   - Branch 选择 `main` 或 `master`
   - 点击 Save

4. **访问网站**
   - 等待 1-2 分钟
   - 访问 `https://username.github.io/repo/`

#### 方法二：使用 gh-pages 分支

```bash
# 创建 gh-pages 分支
git checkout -b gh-pages
git push origin gh-pages
```

### Netlify 部署

#### 方法一：拖拽部署

1. 访问 [Netlify](https://www.netlify.com/)
2. 注册/登录账号
3. 将项目文件夹拖拽到 Netlify
4. 等待部署完成

#### 方法二：Git 集成

1. **连接 GitHub**
   - 在 Netlify 中选择 "New site from Git"
   - 授权 GitHub 访问
   - 选择仓库

2. **配置构建设置**
   ```yaml
   Build command: (留空)
   Publish directory: (留空)
   ```

3. **部署完成**
   - Netlify 会自动部署
   - 获得自定义域名

### Vercel 部署

1. **安装 Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **部署项目**
   ```bash
   vercel
   ```

3. **配置域名**
   - 在 Vercel 控制台配置自定义域名

### Gitee Pages 部署

1. **创建 Gitee 仓库**
   - 访问 https://gitee.com/
   - 创建新仓库

2. **推送代码**
   ```bash
   git remote add gitee https://gitee.com/username/repo.git
   git push gitee master
   ```

3. **启用 Gitee Pages**
   - 进入仓库设置
   - 找到 Gitee Pages
   - 启动服务
   - 选择分支和目录

## 常见问题

### Q1: 封面页不显示？

**原因**：缺少 `_coverpage.md` 文件或配置错误。

**解决方案**：
```javascript
window.$docsify = {
  coverpage: true  // 确保设置为 true
}
```

### Q2: 搜索功能不工作？

**原因**：未引入搜索插件或配置错误。

**解决方案**：
```html
<script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/search.min.js"></script>
```

### Q3: 图片无法显示？

**原因**：路径错误或图片未上传。

**解决方案**：
- 使用相对路径：`./images/logo.png`
- 或使用绝对路径：`/images/logo.png`
- 确保图片文件已上传到仓库

### Q4: 数学公式不渲染？

**原因**：未引入 KaTeX 插件。

**解决方案**：
```html
<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/katex@latest/dist/katex.min.css" />
<script src="//cdn.jsdelivr.net/npm/docsify-katex@latest/dist/docsify-katex.js"></script>
```

### Q5: 侧边栏不显示？

**原因**：未创建 `_sidebar.md` 文件。

**解决方案**：
```markdown
* [首页](/)
* [指南](guide/)
* [API](api/)
```

### Q6: 部署后 404 错误？

**原因**：GitHub Pages 配置错误或文件路径问题。

**解决方案**：
- 检查 GitHub Pages 设置
- 确保文件在正确的分支
- 添加 `.nojekyll` 文件

### Q7: 中文显示乱码？

**原因**：文件编码问题。

**解决方案**：
```html
<meta charset="UTF-8">
```

### Q8: 移动端显示异常？

**原因**：响应式配置问题。

**解决方案**：
```css
@media (max-width: 768px) {
  .sidebar {
    width: 100%;
  }
}
```

## 最佳实践

### 1. 文档组织

- **按功能分类**：将相关文档放在同一目录
- **层级清晰**：使用合理的目录结构
- **命名规范**：使用有意义的文件名

### 2. 内容编写

- **简洁明了**：避免冗长描述
- **图文并茂**：适当使用图片和图表
- **代码示例**：提供可运行的代码
- **持续更新**：保持文档最新状态

### 3. 性能优化

- **按需加载**：只加载必要的插件
- **图片优化**：压缩图片文件大小
- **CDN 加速**：使用 CDN 加载资源

### 4. SEO 优化

```html
<meta name="description" content="文档描述">
<meta name="keywords" content="关键词1,关键词2">
<meta property="og:title" content="页面标题">
<meta property="og:description" content="页面描述">
```

### 5. 版本控制

- **Git 管理**：使用 Git 进行版本控制
- **分支策略**：开发分支 + 主分支
- **提交规范**：使用清晰的提交信息

### 6. 协作流程

- **Issue 跟踪**：使用 GitHub Issue 管理任务
- **Pull Request**：通过 PR 进行代码审查
- **文档审查**：定期检查文档质量

### 7. 监控与维护

- **访问统计**：使用 Google Analytics
- **用户反馈**：收集用户意见和建议
- **定期备份**：备份重要文档

## 总结

Docsify 是一个强大而灵活的文档生成器，通过本教程，您应该已经掌握了：

- ✅ 环境搭建与项目初始化
- ✅ 配置文件详解
- ✅ 导航与侧边栏定制
- ✅ Markdown 编写规范
- ✅ 插件系统使用
- ✅ 本地预览与部署

**下一步**：
1. 创建您的第一个 Docsify 项目
2. 编写高质量的文档内容
3. 部署到生产环境
4. 持续优化和改进

**资源链接**：
- [Docsify 官方文档](https://docsify.js.org/)
- [Docsify 插件列表](https://docsify.js.org/#/awesome)
- [GitHub 仓库](https://github.com/docsifyjs/docsify)

---

**祝您使用愉快！** 🎉