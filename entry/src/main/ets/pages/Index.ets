import common from '@ohos.app.ability.common';
import router from '@ohos.router';
import { ThemeManager, ThemeColors, ThemePreviewColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { DateTimeUtil } from '../utils/DateTimeUtil';
import { CourseSchedulePage } from './CourseSchedulePage';
import { TodoSchedulePage } from '../components/TodoSchedulePage';
import { CampusServicePage } from './CampusServicePage';
import { CampusNewsPage } from './CampusNewsPage';
import { AIChatPage } from './AIChatPage';
import { TodoDataManager } from '../utils/TodoDataManager'; // 新增：待办数据管理器

/**
 * 导航项接口
 */
interface TabItem {
  title: string;
  icon: Resource;
}

/**
 * 路由参数接口
 */
interface RouteParams {
  selectedDate?: number;
  tabIndex?: number;
}

/**
 * 主页面
 * 功能：底部导航、主题切换、响应式布局
 */
@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @State themeColors: ThemeColors = {
    primary: '#007DFF',
    secondary: '#7B68EE',
    background: '#FFFFFF',
    surface: '#F5F5F5',
    text: '#000000',
    textSecondary: '#666666',
    divider: '#E0E0E0',
    success: '#00C853',
    warning: '#FF9800',
    error: '#FF5252'
  };
  @State deviceWidth: number = 360;
  @State showThemeDialog: boolean = false;
  @State todayCourseCount: number = 0;
  @State todoCount: number = 0;
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;

  private tabItems: TabItem[] = [
    { title: '课程表', icon: $r('sys.symbol.book') },
    { title: '待办', icon: $r('sys.symbol.checkmark_circle') },
    { title: '服务', icon: $r('sys.symbol.square_grid_2x2') },
    { title: '资讯', icon: $r('sys.symbol.doc_text') },
    { title: 'AI', icon: $r('sys.symbol.lightbulb') }
  ];

  aboutToAppear(): void {
    // 新增：检查是否有从日志页面传递的路由参数
    this.checkRouteParams();
    
    // 初始化主题颜色（增加异常捕获处理）
    try {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    } catch (error) {
      console.error('Failed to get theme colors:', error);
    }
    
    // 初始化PreferencesUtil（增加异常捕获处理）
    try {
      PreferencesUtil.getInstance().init(getContext(this) as common.UIAbilityContext);
    } catch (error) {
      console.error('Failed to init PreferencesUtil:', error);
    }
    
    // 初始化ThemeManager（增加异常捕获处理）
    try {
      ThemeManager.getInstance().init();
      // 修复：保存监听器引用，以便在aboutToDisappear中移除
      this.themeListener = (_isDark: boolean) => {
        this.themeColors = ThemeManager.getInstance().getThemeColor();
      };
      ThemeManager.getInstance().addListener(this.themeListener);
    } catch (error) {
      console.error('Failed to init ThemeManager:', error);
    }
    
    // 新增：执行每日流转逻辑（归档已完成待办、继承未完成待办）
    try {
      TodoDataManager.getInstance().performDailyTransition();
    } catch (error) {
      console.error('Failed to perform daily transition:', error);
    }
    
    this.loadStatistics();
  }

  // 新增：组件销毁时移除监听器，防止内存泄漏
  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
  }

  // 新增：检查路由参数
  checkRouteParams(): void {
    try {
      const params = router.getParams() as RouteParams;
      if (params && params.tabIndex !== undefined) {
        this.currentIndex = params.tabIndex as number;
      }
    } catch (error) {
      console.error('Failed to get route params:', error);
    }
  }

  async loadStatistics(): Promise<void> {
    // 加载统计数据（增加异常捕获处理）
    try {
      const courses = await PreferencesUtil.getInstance().getCourses();
      const todos = await PreferencesUtil.getInstance().getTodos();
      const today = DateTimeUtil.getCurrentDayOfWeek();
      this.todayCourseCount = courses.filter(c => c.dayOfWeek === today).length;
      this.todoCount = todos.filter(t => !t.isCompleted).length;
    } catch (error) {
      console.error('Failed to load statistics:', error);
      // 异常时使用默认值
      this.todayCourseCount = 0;
      this.todoCount = 0;
    }
  }

  // 安全获取深色模式状态（增加异常捕获处理）
  private getIsDarkModeSafe(): boolean {
    try {
      return ThemeManager.getInstance().getIsDarkMode();
    } catch (error) {
      console.error('Failed to get isDarkMode:', error);
      return false;
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        if (this.currentIndex === 0) {
          CourseSchedulePage()
        } else if (this.currentIndex === 1) {
          TodoSchedulePage()
        } else if (this.currentIndex === 2) {
          CampusServicePage()
        } else if (this.currentIndex === 3) {
          CampusNewsPage()
        } else {
          AIChatPage()
        }
      }
      .layoutWeight(1)

      this.buildBottomNavigation()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    .bindSheet($$this.showThemeDialog, this.themeSheet(), {
      height: 300,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
  }

  @Builder
  buildBottomNavigation(): void {
    Column() {
      Divider().color(this.themeColors.divider)

      Row() {
        ForEach(this.tabItems, (item: TabItem, index: number) => {
          Column() {
            SymbolGlyph(item.icon)
              .fontSize(24)
              .fontColor([this.currentIndex === index ? this.themeColors.primary : this.themeColors.textSecondary])

            Text(item.title)
              .fontSize(12)
              .fontColor(this.currentIndex === index ? this.themeColors.primary : this.themeColors.textSecondary)
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .padding({ top: 8, bottom: 8 })
          .onClick(() => {
            this.currentIndex = index;
          })
        })

        // 修改：将「主题」Tab改为「设置」Tab，图标更换为系统设置图标（修正拼写：gearshape → gear_shape）
        Column() {
          // 使用ellipsis_circle（更多选项）图标作为设置入口
          SymbolGlyph($r('sys.symbol.ellipsis_circle'))
            .fontSize(24)
            .fontColor([this.themeColors.textSecondary])

          Text('设置')
            .fontSize(12)
            .fontColor(this.themeColors.textSecondary)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .padding({ top: 8, bottom: 8 })
        .onClick(() => {
          // 点击设置Tab跳转到设置页面
          try {
            router.pushUrl({
              url: 'pages/SettingsPage'
            });
          } catch (error) {
            console.error('Failed to navigate to SettingsPage:', error);
          }
        })
      }
      .width('100%')
      .height(56)
      .backgroundColor(this.themeColors.surface)
    }
  }

  @Builder
  themeSheet(): void {
    Column() {
      Text('设置')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .margin({ top: 16, bottom: 24 })

      // 主题设置
      Column() {
        Text('主题设置')
          .fontSize(14)
          .fontColor(this.themeColors.textSecondary)
          .width('100%')
          .margin({ bottom: 12 })

        Row({ space: 24 }) {
          Column({ space: 8 }) {
            Column() {
              Column()
                .width(60)
                .height(40)
                .backgroundColor(ThemePreviewColors.LIGHT_SURFACE)
                .border({ width: 1, color: ThemePreviewColors.LIGHT_DIVIDER })
                .borderRadius(8)
            }
            .width(80)
            .height(60)
            .backgroundColor(ThemePreviewColors.LIGHT_BACKGROUND)
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)

            Text('浅色')
              .fontSize(14)
              .fontColor(this.themeColors.text)

            if (!this.getIsDarkModeSafe()) {
              SymbolGlyph($r('sys.symbol.checkmark'))
                .fontSize(20)
                .fontColor([this.themeColors.primary])
            }
          }
          .onClick(() => {
            // 切换浅色主题（增加异常捕获处理）
            try {
              ThemeManager.getInstance().setThemeMode(false);
              this.showThemeDialog = false;
            } catch (error) {
              console.error('Failed to set light theme:', error);
            }
          })

          Column({ space: 8 }) {
            Column() {
              Column()
                .width(60)
                .height(40)
                .backgroundColor(ThemePreviewColors.DARK_SURFACE)
                .borderRadius(8)
            }
            .width(80)
            .height(60)
            .backgroundColor(ThemePreviewColors.DARK_BACKGROUND)
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)

            Text('深色')
              .fontSize(14)
              .fontColor(this.themeColors.text)

            if (this.getIsDarkModeSafe()) {
              SymbolGlyph($r('sys.symbol.checkmark'))
                .fontSize(20)
                .fontColor([this.themeColors.primary])
            }
          }
          .onClick(() => {
            // 切换深色主题（增加异常捕获处理）
            try {
              ThemeManager.getInstance().setThemeMode(true);
              this.showThemeDialog = false;
            } catch (error) {
              console.error('Failed to set dark theme:', error);
            }
          })

          Column({ space: 8 }) {
            Column() {
              Column()
                .width(60)
                .height(40)
                .linearGradient({
                  angle: 90,
                  colors: [[ThemePreviewColors.LIGHT_SURFACE, 0.5], [ThemePreviewColors.DARK_SURFACE, 0.5]]
                })
                .borderRadius(8)
            }
            .width(80)
            .height(60)
            .linearGradient({
              angle: 90,
              colors: [[ThemePreviewColors.LIGHT_BACKGROUND, 0.5], [ThemePreviewColors.DARK_BACKGROUND, 0.5]]
            })
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)

            Text('跟随系统')
              .fontSize(14)
              .fontColor(this.themeColors.text)
          }
          .onClick(() => {
            // 切换跟随系统主题（增加异常捕获处理）
            try {
              ThemeManager.getInstance().toggleTheme();
              this.showThemeDialog = false;
            } catch (error) {
              console.error('Failed to toggle theme:', error);
            }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      
      Divider().color(this.themeColors.divider).margin({ top: 8, bottom: 8 })
      
      // 课时配置按钮
      Row() {
        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.clock'))
              .fontSize(20)
              .fontColor([this.themeColors.primary])
            
            Text('课时配置')
              .fontSize(16)
              .fontColor(this.themeColors.text)
              .margin({ left: 12 })
            
            Blank()
            
            SymbolGlyph($r('sys.symbol.chevron_right'))
              .fontSize(16)
              .fontColor([this.themeColors.textSecondary])
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        }
        .width('100%')
        .backgroundColor(this.themeColors.surface)
        .borderRadius(12)
        .onClick(() => {
          this.showThemeDialog = false;
          // 跳转到课时配置页面（增加异常捕获处理）
          try {
            router.pushUrl({
              url: 'pages/ScheduleConfigPage'
            });
          } catch (error) {
            console.error('Failed to navigate to ScheduleConfigPage:', error);
          }
        })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })

      Text('自定义每日课程节数和每节课时间')
        .fontSize(12)
        .fontColor(this.themeColors.textSecondary)
        .margin({ top: 16 })
    }
    .width('100%')
    .padding(16)
  }
}
