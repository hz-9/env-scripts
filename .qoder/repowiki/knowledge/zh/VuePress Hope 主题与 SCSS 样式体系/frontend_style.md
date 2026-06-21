该仓库的前端样式主要集中在文档站点 (`docs/.vuepress`)，采用 **VuePress 2** 配合 **vuepress-theme-hope** 主题构建。

### 1. 技术栈与工具
- **框架**: VuePress 2 (基于 Vite)
- **主题**: `vuepress-theme-hope` (提供现代化的文档 UI、响应式布局及图标支持)
- **预处理器**: SCSS (`sass-embedded`)
- **图标库**: FontAwesome (通过主题插件集成)

### 2. 核心文件与配置
- **主题配置**: `docs/.vuepress/src/.vuepress/theme.ts` - 定义全局导航、侧边栏、多语言支持及主题插件。
- **样式变量**: 
  - `docs/.vuepress/src/.vuepress/styles/palette.scss`: 定义主题主色调 (`$theme-color: #096dd9`)。
  - `docs/.vuepress/src/.vuepress/styles/config.scss`: 定义辅助颜色调色板。
- **全局样式**: `docs/.vuepress/src/.vuepress/styles/index.scss` - 包含自定义 CSS 规则，如调整 PC 端内容宽度、隐藏首页首个段落等。
- **构建配置**: `docs/.vuepress/src/.vuepress/config.ts` - 配置 Vite 的 SCSS 预处理选项，抑制 `@import` 弃用警告。

### 3. 架构与约定
- **模块化样式**: 遵循 VuePress Hope 的约定，通过 `palette.scss` 覆盖主题变量，通过 `index.scss` 添加全局组件样式。
- **响应式设计**: 利用主题内置的断点变量 (`hope-config.$pc`) 进行媒体查询，确保在不同设备上的阅读体验。
- **多语言适配**: 样式系统自动适配 `/` (英文) 和 `/zh-CN/` (中文) 路径下的内容结构。

### 4. 开发规范
- **变量优先**: 修改颜色或间距时，应优先在 `palette.scss` 或 `config.scss` 中修改变量，而非硬编码 CSS。
- **SCSS 语法**: 使用现代 SCSS 模块系统 (`@use`) 而非旧的 `@import`，以符合 Vite 和 Sass 的最新标准。