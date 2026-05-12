# 图像滤镜应用 - 项目结构说明

> 本文档详细梳理项目中每个文件的作用和功能。

---

## 📁 项目目录结构总览

```
image-filter-master/
├── 📄 根目录配置文件
├── 📁 AppScope/              # 应用全局配置
├── 📁 entry/                 # 主模块（入口模块）
├── 📁 .hvigor/               # 构建工具缓存
├── 📁 .idea/                 # IDE 配置
├── 📁 hvigor/                # 构建工具配置
└── 📁 screenshots/           # 应用截图
```

---

## 📄 根目录配置文件

### 1. `build-profile.json5`
**作用：** 项目构建配置文件

| 配置项 | 说明 |
|-------|------|
| `signingConfigs` | 应用签名配置 |
| `products` | 构建产品配置（SDK版本、运行系统等） |
| `modules` | 项目包含的模块列表 |
| `buildModeSet` | 构建模式（debug/release） |

```json5
{
  "app": {
    "products": [{
      "targetSdkVersion": "6.0.0(20)",    // 目标 SDK 版本
      "runtimeOS": "HarmonyOS"            // 运行系统
    }]
  },
  "modules": [{ "name": "entry" }]        // 包含 entry 模块
}
```

---

### 2. `oh-package.json5`
**作用：** 项目依赖管理文件（类似 package.json）

| 配置项 | 说明 |
|-------|------|
| `modelVersion` | 模型版本号 |
| `dependencies` | 运行时依赖 |
| `devDependencies` | 开发依赖 |

---

### 3. `hvigorfile.ts`
**作用：** Hvigor 构建脚本入口文件

- 定义项目级别的构建任务
- 配置构建流程和插件

---

### 4. `LICENSE`
**作用：** 开源许可证文件

- 本项目使用 Apache License 2.0

---

### 5. `README.md`
**作用：** 项目中文说明文档

- 项目介绍
- 使用说明
- 功能演示

---

### 6. `README_EN.md`
**作用：** 项目英文说明文档

- README 的英文版本

---

### 7. `FILTER_GUIDE.md`
**作用：** 滤镜功能详细指南（本次升级新增）

- 滤镜效果一览表
- 技术实现原理
- 滤镜矩阵详解

---

## 📁 AppScope/ - 应用全局配置

```
AppScope/
├── app.json5                          # 应用全局配置
└── resources/
    └── base/
        ├── element/
        │   └── string.json            # 全局字符串资源
        └── media/
            ├── background.png         # 应用背景图
            ├── foreground.png         # 应用前景图
            └── layered_image.json     # 分层图标配置
```

### `AppScope/app.json5`
**作用：** 应用全局配置文件

| 配置项 | 值 | 说明 |
|-------|-----|------|
| `bundleName` | `com.example.imagefilter` | 应用包名（唯一标识） |
| `vendor` | `example` | 开发者名称 |
| `versionCode` | `1000000` | 版本号（数字） |
| `versionName` | `1.0.0` | 版本名称（字符串） |
| `icon` | `$media:layered_image` | 应用图标 |
| `label` | `$string:app_name` | 应用名称 |

---

### `AppScope/resources/base/element/string.json`
**作用：** 全局字符串资源

- 定义应用名称等全局字符串

---

### `AppScope/resources/base/media/`
**作用：** 全局媒体资源

| 文件 | 说明 |
|-----|------|
| `background.png` | 应用启动背景图 |
| `foreground.png` | 应用图标前景层 |
| `layered_image.json` | 分层图标配置（自适应图标） |

---

## 📁 entry/ - 主模块（核心代码）

```
entry/
├── build-profile.json5                # 模块构建配置
├── hvigorfile.ts                      # 模块构建脚本
├── obfuscation-rules.txt              # 代码混淆规则
├── oh-package.json5                   # 模块依赖
└── src/main/
    ├── module.json5                   # 模块配置
    ├── ets/                           # ArkTS 源代码
    │   ├── constants/
    │   │   └── CommonConstants.ets    # 常量定义（滤镜矩阵）
    │   ├── entryability/
    │   │   └── EntryAbility.ets       # 应用入口 Ability
    │   ├── entrybackupability/
    │   │   └── EntryBackupAbility.ets # 备份恢复 Ability
    │   └── pages/
    │       └── Index.ets              # 主页面 UI
    └── resources/                     # 资源文件
        ├── base/
        │   ├── element/
        │   │   ├── color.json         # 颜色资源
        │   │   ├── float.json         # 尺寸资源
        │   │   └── string.json        # 字符串资源
        │   ├── media/
        │   │   ├── avatar1.jpg        # 示例图片1
        │   │   ├── avatar2.jpg        # 示例图片2
        │   │   ├── background.png     # 页面背景
        │   │   ├── filter_image.png   # 滤镜图标
        │   │   ├── foreground.png     # 前景图
        │   │   ├── startIcon.png      # 启动图标
        │   │   └── layered_image.json # 分层图标配置
        │   └── profile/
        │       ├── backup_config.json # 备份配置
        │       └── main_pages.json    # 页面路由配置
        └── dark/
            └── element/
                └── color.json         # 深色模式颜色
```

---

### 📄 entry 配置文件

#### `entry/build-profile.json5`
**作用：** 模块级别构建配置

- 配置模块的编译选项
- 设置 API 版本等

---

#### `entry/hvigorfile.ts`
**作用：** 模块构建脚本

- 定义模块级别的构建任务

---

#### `entry/obfuscation-rules.txt`
**作用：** 代码混淆规则

- 配置 Release 构建时的代码混淆规则
- 保护代码安全，减小包体积

---

#### `entry/oh-package.json5`
**作用：** 模块依赖配置

- 定义模块级别的依赖包

---

#### `entry/src/main/module.json5`
**作用：** 模块配置文件（最重要的配置之一）

| 配置项 | 说明 |
|-------|------|
| `name` | 模块名称：`entry` |
| `type` | 模块类型：`entry`（入口模块） |
| `mainElement` | 主入口：`EntryAbility` |
| `deviceTypes` | 支持设备：`phone` |
| `pages` | 页面路由配置文件 |
| `abilities` | Ability 配置列表 |
| `extensionAbilities` | 扩展 Ability（如备份恢复） |

---

### 📝 ArkTS 源代码 (entry/src/main/ets/)

#### `constants/CommonConstants.ets`
**作用：** 常量定义文件（核心业务逻辑）

**定义内容：**
- `FilterOption` 接口 - 滤镜选项数据结构
- `ORIGINAL_MATRIX` - 原图矩阵
- `REVERSE_COLOR_MATRIX` - 反色矩阵
- `WHITENING_COLOR_FILTER` - 美白滤镜
- `ENHANCE_COLOR_MATRIX` - 增强矩阵
- `RETRO_COLOR_MATRIX` - 复古矩阵
- `SEPIA_COLOR_MATRIX` - 怀旧矩阵
- `COOL_COLOR_MATRIX` - 冷色调矩阵
- `WARM_COLOR_MATRIX` - 暖色调矩阵
- `CONTRAST_COLOR_MATRIX` - 高对比度矩阵
- `CHANNEL_SWAP_MATRIX` - 通道交换矩阵
- `POSTERIZE_MATRIX` - 色调分离矩阵
- `NIGHT_VISION_MATRIX` - 夜视仪矩阵
- `VINTAGE_MATRIX` - 老照片矩阵
- `FILTER_OPTIONS` - 滤镜选项数组
- `CAROUSEL_DATA_SOURCE` - 轮播图片数据源

---

#### `entryability/EntryAbility.ets`
**作用：** 应用入口 Ability（程序入口点）

**生命周期方法：**
| 方法 | 说明 |
|-----|------|
| `onCreate()` | Ability 创建时调用，初始化颜色模式 |
| `onDestroy()` | Ability 销毁时调用 |
| `onWindowStageCreate()` | 窗口创建时调用，加载主页面 `pages/Index` |
| `onWindowStageDestroy()` | 窗口销毁时调用 |
| `onForeground()` | Ability 进入前台时调用 |
| `onBackground()` | Ability 进入后台时调用 |

---

#### `entrybackupability/EntryBackupAbility.ets`
**作用：** 备份恢复扩展 Ability

- 实现应用数据的备份和恢复功能
- 继承自 `BackupExtensionAbility`

---

#### `pages/Index.ets`
**作用：** 主页面 UI 组件（核心界面）

**组件结构：**
```
Index (主页面)
├── Swiper (图片轮播)
│   └── ForEach → Image (带滤镜的图片)
└── Column (控制面板)
    ├── Text ("Apply Filter" 标题)
    └── Grid (滤镜选项网格)
        └── ForEach → GridItem
            └── Row (Radio + Text)
```

**状态变量：**
| 变量 | 类型 | 说明 |
|-----|------|------|
| `currentSwiperIndex` | `number` | 当前轮播索引 |
| `imageFilterTags` | `string[]` | 每张图片的滤镜标签 |

**核心方法：**
| 方法 | 说明 |
|-----|------|
| `aboutToAppear()` | 页面初始化，设置默认滤镜 |
| `getFilterByTag()` | 根据标签获取滤镜矩阵 |

---

### 📦 资源文件 (entry/src/main/resources/)

#### `base/element/color.json`
**作用：** 颜色资源定义

```json
{
  "color": [
    { "name": "start_window_background", "value": "#FFFFFF" }
  ]
}
```

---

#### `base/element/float.json`
**作用：** 尺寸/浮点数资源定义

- 定义页面元素的尺寸值

---

#### `base/element/string.json`
**作用：** 模块字符串资源

```json
{
  "string": [
    { "name": "module_desc", "value": "module description" },
    { "name": "EntryAbility_label", "value": "imagefilter" }
  ]
}
```

---

#### `base/media/`
**作用：** 媒体资源（图片）

| 文件 | 说明 |
|-----|------|
| `avatar1.jpg` | 轮播示例图片 1 |
| `avatar2.jpg` | 轮播示例图片 2 |
| `background.png` | 页面背景图 |
| `filter_image.png` | 滤镜功能图标 |
| `foreground.png` | 前景图 |
| `startIcon.png` | 应用启动图标 |
| `layered_image.json` | 分层图标配置 |

---

#### `base/profile/main_pages.json`
**作用：** 页面路由配置

```json
{
  "src": ["pages/Index"]
}
```

- 定义应用包含的页面列表
- `pages/Index` 表示主页面路径

---

#### `base/profile/backup_config.json`
**作用：** 备份恢复配置

- 配置应用数据备份恢复的规则

---

#### `dark/element/color.json`
**作用：** 深色模式颜色资源

- 当系统切换到深色模式时使用此颜色配置

---

## 📁 .hvigor/ - 构建工具缓存

```
.hvigor/
├── cache/                             # 构建缓存
│   ├── file-cache.json
│   ├── meta.json
│   └── task-cache.json
├── dependencyMap/                     # 依赖映射
│   ├── dependencyMap.json5
│   ├── oh-package.json5
│   └── entry/oh-package.json5
├── outputs/                           # 构建输出
│   ├── build-logs/build.log
│   ├── logs/details/details.json
│   └── sync/
└── report/                            # 构建报告
    └── report-*.json
```

**作用：** Hvigor 构建系统的缓存和输出目录

- ⚠️ 自动生成，无需手动修改
- 可在 `.gitignore` 中忽略

---

## 📁 .idea/ - IDE 配置

```
.idea/
├── .gitignore                         # IDE 忽略配置
├── modules.xml                        # 模块配置
├── vcs.xml                            # 版本控制配置
├── workspace.xml                      # 工作区配置
├── .deveco/
│   ├── project.cache.json             # 项目缓存
│   ├── cxx/.clang-format              # C++ 格式化配置
│   └── module/entry.cache.json        # 模块缓存
└── modules/
    ├── entry.iml                      # entry 模块配置
    └── image-filter-master.iml        # 项目模块配置
```

**作用：** DevEco Studio IDE 配置目录

- ⚠️ 自动生成，无需手动修改
- 不同开发者可能有所不同

---

## 📁 hvigor/ - 构建工具配置

```
hvigor/
└── hvigor-config.json5                # Hvigor 构建配置
```

### `hvigor/hvigor-config.json5`
**作用：** Hvigor 构建工具配置

| 配置项 | 说明 |
|-------|------|
| `modelVersion` | 配置模型版本 |
| `execution` | 执行配置（并行编译、增量编译等） |
| `logging` | 日志级别配置 |
| `debugging` | 调试配置 |
| `nodeOptions` | Node.js 选项（内存限制等） |

---

## 📁 screenshots/ - 应用截图

```
screenshots/
├── pic1.png                           # 截图1
├── pic2.png                           # 截图2
├── pic3.png                           # 截图3
├── pic4.png                           # 截图4
└── pic5.png                           # 截图5
```

**作用：** 应用功能演示截图

- 用于 README 文档展示
- 展示不同滤镜效果的预览

---

## 📊 文件分类汇总

| 分类 | 文件数量 | 主要作用 |
|-----|---------|---------|
| **配置文件** | 10+ | 项目构建、模块配置、依赖管理 |
| **源代码** | 4 | 业务逻辑、UI 界面、入口 |
| **资源文件** | 15+ | 图片、字符串、颜色、布局 |
| **构建缓存** | 10+ | 自动生成，加速构建 |
| **IDE 配置** | 8+ | DevEco Studio 配置 |
| **文档** | 4 | README、LICENSE、指南 |

---

## 🔑 核心文件清单

开发时需要重点关注的核心文件：

| 优先级 | 文件路径 | 作用 |
|:-----:|---------|------|
| ⭐⭐⭐ | `entry/src/main/ets/pages/Index.ets` | 主页面 UI |
| ⭐⭐⭐ | `entry/src/main/ets/constants/CommonConstants.ets` | 滤镜定义 |
| ⭐⭐ | `entry/src/main/module.json5` | 模块配置 |
| ⭐⭐ | `AppScope/app.json5` | 应用配置 |
| ⭐ | `entry/src/main/ets/entryability/EntryAbility.ets` | 应用入口 |
| ⭐ | `entry/src/main/resources/base/profile/main_pages.json` | 页面路由 |

---

## 📝 开发建议

### 需要修改的文件
- 添加滤镜 → `CommonConstants.ets`
- 修改界面 → `Index.ets`
- 添加图片 → `resources/base/media/`
- 修改配置 → `module.json5`, `app.json5`

### 不需要修改的文件
- `.hvigor/` 目录（自动生成）
- `.idea/` 目录（IDE 自动管理）
- `build/` 目录（编译输出）

### 需要版本控制的文件
- 源代码和资源文件
- 配置文件（`.json5`, `.json`）
- 文档文件（`.md`）

### 可忽略的文件（.gitignore）
- `.hvigor/cache/`
- `.idea/`
- `entry/build/`

---

*文档生成时间：2026-04-21*
