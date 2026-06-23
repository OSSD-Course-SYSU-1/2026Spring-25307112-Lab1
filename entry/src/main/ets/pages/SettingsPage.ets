import router from '@ohos.router';
import picker from '@ohos.file.picker'; // 新增：导入图片选择器
import { ThemeManager, ThemeColors, ThemePreviewColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { ResponsiveUtil } from '../utils/ResponsiveUtil';
import { FontConfigUtil, FontConfig, FontSize, FontStyle } from '../utils/FontConfigUtil'; // 新增：导入字体配置管理
import { BackgroundManager } from '../utils/BackgroundManager'; // 新增：导入背景图管理
import { BackgroundImage } from '../components/BackgroundImage'; // 新增：背景图组件

/**
 * 设置页面
 * 功能：课时配置、主题切换、学期周数初始化、数据管理
 * 特性：深浅色主题、多端适配、Preferences持久化
 */
@Entry
@Component
struct SettingsPage {
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State deviceWidth: number = 360;
  @State totalWeeks: number = 20;
  @State showClearCourseDialog: boolean = false;
  @State showClearTodoDialog: boolean = false;
  @State showSuccessToast: boolean = false;
  @State successMessage: string = '';
  @State themeMode: number = 0;
  // 新增：字体配置相关状态
  @State fontConfig: FontConfig = new FontConfig();
  @State selectedFontSize: FontSize = FontSize.STANDARD;
  @State selectedFontStyle: FontStyle = FontStyle.SYSTEM;
  // 新增：背景图相关状态
  @State backgroundUri: string = '';
  @State hasCustomBackground: boolean = false;
  
  // 新增：用于防止弹窗动效期间的重复点击（独立状态，避免事件互锁）
  private isClearCourseDialogAnimating: boolean = false;
  private isClearTodoDialogAnimating: boolean = false;
  
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null; // 新增：字体配置监听器
  private backgroundListener: ((uri: string) => void) | null = null; // 新增：背景图监听器
  // 新增：定时器ID，用于在组件销毁时清理
  private successTimerId: number = -1;
  private errorTimerId: number = -1;

  aboutToAppear(): void {
    this.loadSettings();
    this.themeListener = (_isDark: boolean) => {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    this.initThemeMode();
    // 新增：初始化字体配置监听器
    this.fontConfigListener = (config: FontConfig) => {
      this.fontConfig = config;
      this.selectedFontSize = config.fontSize;
      this.selectedFontStyle = config.fontStyle;
    };
    FontConfigUtil.getInstance().addListener(this.fontConfigListener);
    this.loadFontConfig(); // 新增：加载字体配置
    // 新增：初始化背景图监听器
    this.backgroundListener = (uri: string) => {
      this.backgroundUri = uri;
      this.hasCustomBackground = uri !== '';
    };
    BackgroundManager.getInstance().addListener(this.backgroundListener);
    this.loadBackgroundConfig(); // 新增：加载背景图配置
  }

  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
    // 新增：移除字体配置监听器
    if (this.fontConfigListener) {
      FontConfigUtil.getInstance().removeListener(this.fontConfigListener);
    }
    // 新增：移除背景图监听器
    if (this.backgroundListener) {
      BackgroundManager.getInstance().removeListener(this.backgroundListener);
    }
    // 新增：清理定时器，防止内存泄漏
    if (this.successTimerId !== -1) {
      clearTimeout(this.successTimerId);
      this.successTimerId = -1;
    }
    if (this.errorTimerId !== -1) {
      clearTimeout(this.errorTimerId);
      this.errorTimerId = -1;
    }
  }

  async loadSettings(): Promise<void> {
    try {
      this.totalWeeks = await PreferencesUtil.getInstance().getTotalWeeks();
    } catch (error) {
      console.error('Failed to load settings:', error);
    }
  }

  initThemeMode(): void {
    try {
      const isDark = ThemeManager.getInstance().getIsDarkMode();
      this.themeMode = isDark ? 2 : 1;
    } catch (error) {
      console.error('Failed to init theme mode:', error);
      this.themeMode = 1;
    }
  }

  isTablet(): boolean {
    return ResponsiveUtil.isTablet(this.deviceWidth);
  }

  showSuccess(message: string): void {
    this.successMessage = message;
    this.showSuccessToast = true;
    // 修复：保存定时器ID，以便在aboutToDisappear中清理
    if (this.successTimerId !== -1) {
      clearTimeout(this.successTimerId);
    }
    this.successTimerId = setTimeout(() => {
      this.showSuccessToast = false;
      this.successTimerId = -1;
    }, 2000);
  }

  showError(message: string): void {
    this.successMessage = message;
    this.showSuccessToast = true;
    // 修复：保存定时器ID，以便在aboutToDisappear中清理
    if (this.errorTimerId !== -1) {
      clearTimeout(this.errorTimerId);
    }
    this.errorTimerId = setTimeout(() => {
      this.showSuccessToast = false;
      this.errorTimerId = -1;
    }, 2000);
  }

  async saveTotalWeeks(): Promise<void> {
    try {
      await PreferencesUtil.getInstance().saveTotalWeeks(this.totalWeeks);
      this.showSuccess('学期周数保存成功');
    } catch (error) {
      console.error('Failed to save total weeks:', error);
    }
  }

  async clearCourses(): Promise<void> {
    try {
      await PreferencesUtil.getInstance().clearAllCourses();
      this.showClearCourseDialog = false;
      this.showSuccess('课程数据已清空');
    } catch (error) {
      console.error('Failed to clear courses:', error);
    }
  }

  async clearTodos(): Promise<void> {
    try {
      await PreferencesUtil.getInstance().clearAllTodos();
      this.showClearTodoDialog = false;
      this.showSuccess('待办数据已清空');
    } catch (error) {
      console.error('Failed to clear todos:', error);
    }
  }

  // 新增：加载字体配置
  async loadFontConfig(): Promise<void> {
    try {
      const config = await PreferencesUtil.getInstance().getFontConfig();
      FontConfigUtil.getInstance().updateFontConfig(config);
      this.fontConfig = config;
      this.selectedFontSize = config.fontSize;
      this.selectedFontStyle = config.fontStyle;
    } catch (error) {
      console.error('Failed to load font config:', error);
    }
  }

  // 新增：保存字体配置
  async saveFontConfig(): Promise<void> {
    try {
      const config = new FontConfig(this.selectedFontSize, this.selectedFontStyle);
      await PreferencesUtil.getInstance().saveFontConfig(config);
      FontConfigUtil.getInstance().updateFontConfig(config);
      this.showSuccess('字体配置保存成功');
    } catch (error) {
      console.error('Failed to save font config:', error);
    }
  }

  // 新增：同步系统字体
  async syncSystemFont(): Promise<void> {
    try {
      this.selectedFontStyle = FontStyle.SYSTEM;
      const config = new FontConfig(this.selectedFontSize, this.selectedFontStyle);
      await PreferencesUtil.getInstance().saveFontConfig(config);
      FontConfigUtil.getInstance().updateFontConfig(config);
      this.showSuccess('已同步系统字体');
    } catch (error) {
      console.error('Failed to sync system font:', error);
      this.showError('同步系统字体失败');
    }
  }

  // 新增：恢复软件默认字体
  async restoreDefaultFont(): Promise<void> {
    try {
      this.selectedFontStyle = FontStyle.DEFAULT;
      const config = new FontConfig(this.selectedFontSize, this.selectedFontStyle);
      await PreferencesUtil.getInstance().saveFontConfig(config);
      FontConfigUtil.getInstance().updateFontConfig(config);
      this.showSuccess('已恢复软件默认字体');
    } catch (error) {
      console.error('Failed to restore default font:', error);
      this.showError('恢复默认字体失败');
    }
  }

  // 新增：获取缩放后的字体大小
  getScaledFontSize(baseSize: number): number {
    return baseSize * this.fontConfig.getFontScale();
  }

  // 新增：获取字体族
  getFontFamily(): string {
    return this.fontConfig.getFontFamily();
  }

  // 新增：加载背景图配置
  async loadBackgroundConfig(): Promise<void> {
    try {
      const uri = await PreferencesUtil.getInstance().getBackgroundUri();
      BackgroundManager.getInstance().setBackgroundUri(uri);
      this.backgroundUri = uri;
      this.hasCustomBackground = uri !== '';
    } catch (error) {
      console.error('Failed to load background config:', error);
    }
  }

  // 新增：选择背景图
  async selectBackgroundImage(): Promise<void> {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      
      const photoPicker = new picker.PhotoViewPicker();
      const photoSelectResult = await photoPicker.select(photoSelectOptions);
      
      if (photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        const uri = photoSelectResult.photoUris[0];
        await PreferencesUtil.getInstance().saveBackgroundUri(uri);
        BackgroundManager.getInstance().setBackgroundUri(uri);
        this.backgroundUri = uri;
        this.hasCustomBackground = true;
        this.showSuccess('背景图设置成功');
      }
    } catch (error) {
      console.error('Failed to select background image:', error);
    }
  }

  // 新增：清除背景图
  async clearBackground(): Promise<void> {
    try {
      await PreferencesUtil.getInstance().clearBackgroundUri();
      BackgroundManager.getInstance().clearBackground();
      this.backgroundUri = '';
      this.hasCustomBackground = false;
      this.showSuccess('已恢复默认背景');
    } catch (error) {
      console.error('Failed to clear background:', error);
    }
  }

  build() {
    // 新增：使用Stack包裹背景图和内容
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()
      
      if (this.showSuccessToast) {
        Row() {
          SymbolGlyph($r('sys.symbol.checkmark_circle'))
            .fontSize(20)
            .fontColor([this.themeColors.success])
          Text(this.successMessage)
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(this.themeColors.success)
            .margin({ left: 8 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(this.themeColors.surface)
      }
      
      Scroll() {
        Column({ space: 16 }) {
          GridRow({ columns: this.isTablet() ? 2 : 1, gutter: 16 }) {
            GridCol() { this.buildScheduleConfigCard() }
            GridCol() { this.buildThemeConfigCard() }
            GridCol() { this.buildBackgroundConfigCard() } // 新增：自定义背景配置卡片
            GridCol() { this.buildFontSizeCard() } // 新增：字体大小配置卡片
            GridCol() { this.buildFontStyleCard() } // 新增：字体样式配置卡片
            GridCol() { this.buildSemesterConfigCard() }
            GridCol() { this.buildDataManageCard() }
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      // 修复：将清空待办弹窗的bindSheet绑定在Scroll上，与清空课程弹窗分离，避免状态冲突
      .bindSheet($$this.showClearTodoDialog, this.buildClearTodoDialog(), {
        height: 200, backgroundColor: this.themeColors.surface, dragBar: true,
        // 新增：弹窗生命周期回调，用于管理动效状态（独立状态，避免事件互锁）
        onWillAppear: () => {
          this.isClearTodoDialogAnimating = true;
        },
        onDisappear: () => {
          this.isClearTodoDialogAnimating = false;
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    // 修复：将清空课程弹窗的bindSheet绑定在Column上，与清空待办弹窗分离
    .bindSheet($$this.showClearCourseDialog, this.buildClearCourseDialog(), {
      height: 200, backgroundColor: this.themeColors.surface, dragBar: true,
      // 新增：弹窗生命周期回调，用于管理动效状态（独立状态，避免事件互锁）
      onWillAppear: () => {
        this.isClearCourseDialogAnimating = true;
      },
      onDisappear: () => {
        this.isClearCourseDialogAnimating = false;
      }
    })
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      this.deviceWidth = newValue.width as number;
    })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      Button() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(20)
          .fontColor([this.themeColors.text])
      }
      .width(40).height(40).borderRadius(20)
      .backgroundColor(this.themeColors.background)
      .onClick(() => { router.back(); })

      Text('设置').fontSize(this.getScaledFontSize(20)).fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text).margin({ left: 12 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
      Blank()
    }
    .width('100%').height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  @Builder
  buildScheduleConfigCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.clock')).fontSize(24).fontColor([this.themeColors.primary])
        Text('课时配置').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
        Blank()
        SymbolGlyph($r('sys.symbol.chevron_right')).fontSize(20)
          .fontColor([this.themeColors.textSecondary])
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 8 })
      Text('自定义每日课程节数和每节课起止时间').fontSize(this.getScaledFontSize(14))
        .fontColor(this.themeColors.textSecondary).width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
    .onClick(() => {
      try {
        router.pushUrl({ url: 'pages/ScheduleConfigPage' });
      } catch (error) {
        console.error('Failed to navigate to ScheduleConfigPage:', error);
      }
    })
  }

  @Builder
  buildThemeConfigCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.moon')).fontSize(24).fontColor([this.themeColors.primary])
        Text('系统主题切换').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Column({ space: 12 }) {
        Row() {
          Radio({ value: 'follow', group: 'themeGroup' }).checked(this.themeMode === 0)
            .onChange((isChecked: boolean) => {
              if (isChecked) { this.themeMode = 0; ThemeManager.getInstance().toggleTheme(); }
            })
          Text('跟随系统').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Text('根据系统设置自动切换').fontSize(this.getScaledFontSize(12)).fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%').padding({ left: 16, right: 16 })
        Divider().color(this.themeColors.divider)

        Row() {
          Radio({ value: 'light', group: 'themeGroup' }).checked(this.themeMode === 1)
            .onChange((isChecked: boolean) => {
              if (isChecked) { this.themeMode = 1; ThemeManager.getInstance().setThemeMode(false); }
            })
          Text('浅色模式').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Column().width(24).height(24).backgroundColor('#FFFFFF')
            .border({ width: 1, color: this.themeColors.divider }).borderRadius(4)
        }
        .width('100%').padding({ left: 16, right: 16 })
        Divider().color(this.themeColors.divider)

        Row() {
          Radio({ value: 'dark', group: 'themeGroup' }).checked(this.themeMode === 2)
            .onChange((isChecked: boolean) => {
              if (isChecked) { this.themeMode = 2; ThemeManager.getInstance().setThemeMode(true); }
            })
          Text('深色模式').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Column().width(24).height(24).backgroundColor('#1E1E1E').borderRadius(4)
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .width('100%').padding({ bottom: 16 })
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  // 新增：自定义背景配置卡片
  @Builder
  buildBackgroundConfigCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.square_grid_2x2')).fontSize(24).fontColor([this.themeColors.primary])
        Text('自定义背景').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Column({ space: 12 }) {
        // 上传背景图按钮
        Row() {
          Column() {
            Text('上传背景图').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
            Text('从相册选择图片作为App背景').fontSize(this.getScaledFontSize(12))
              .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)
          Button('选择').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
            .backgroundColor(this.themeColors.primary).borderRadius(16)
            .height(32).padding({ left: 16, right: 16 })
            .onClick(() => { this.selectBackgroundImage(); })
        }
        .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })

        Divider().color(this.themeColors.divider).margin({ left: 16, right: 16 })

        // 恢复默认背景按钮
        Row() {
          Column() {
            Text('恢复默认背景').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
            Text('清除自定义背景，恢复系统默认').fontSize(this.getScaledFontSize(12))
              .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)
          Button('恢复').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
            .backgroundColor(this.hasCustomBackground ? this.themeColors.error : this.themeColors.textSecondary)
            .borderRadius(16).height(32).padding({ left: 16, right: 16 })
            .enabled(this.hasCustomBackground)
            .onClick(() => { this.clearBackground(); })
        }
        .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 16 })

        // 当前背景状态提示
        if (this.hasCustomBackground) {
          Row() {
            SymbolGlyph($r('sys.symbol.checkmark_circle')).fontSize(16)
              .fontColor([this.themeColors.success])
            Text('已设置自定义背景').fontSize(this.getScaledFontSize(12))
              .fontColor(this.themeColors.success).margin({ left: 8 })
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
          }
          .width('100%').padding({ left: 16, right: 16, bottom: 12 })
        }
      }
      .width('100%')
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  // 新增：字体大小配置卡片
  @Builder
  buildFontSizeCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.textformat')).fontSize(24).fontColor([this.themeColors.primary]) // 修改：使用有效的系统图标
        Text('字体大小').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Column({ space: 12 }) {
        // 小号字体
        Row() {
          Radio({ value: 'small', group: 'fontSizeGroup' }).checked(this.selectedFontSize === FontSize.SMALL)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedFontSize = FontSize.SMALL;
                this.saveFontConfig();
              }
            })
          Text('小').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Text('适合视力较好的用户').fontSize(this.getScaledFontSize(12)).fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%').padding({ left: 16, right: 16 })
        Divider().color(this.themeColors.divider)

        // 标准字体
        Row() {
          Radio({ value: 'standard', group: 'fontSizeGroup' }).checked(this.selectedFontSize === FontSize.STANDARD)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedFontSize = FontSize.STANDARD;
                this.saveFontConfig();
              }
            })
          Text('标准').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Text('推荐使用').fontSize(this.getScaledFontSize(12)).fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%').padding({ left: 16, right: 16 })
        Divider().color(this.themeColors.divider)

        // 大号字体
        Row() {
          Radio({ value: 'large', group: 'fontSizeGroup' }).checked(this.selectedFontSize === FontSize.LARGE)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedFontSize = FontSize.LARGE;
                this.saveFontConfig();
              }
            })
          Text('大').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Text('适合中老年用户').fontSize(this.getScaledFontSize(12)).fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%').padding({ left: 16, right: 16 })
        Divider().color(this.themeColors.divider)

        // 超大号字体
        Row() {
          Radio({ value: 'extraLarge', group: 'fontSizeGroup' }).checked(this.selectedFontSize === FontSize.EXTRA_LARGE)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selectedFontSize = FontSize.EXTRA_LARGE;
                this.saveFontConfig();
              }
            })
          Text('超大').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text).margin({ left: 12 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Blank()
          Text('适合视力较弱的用户').fontSize(this.getScaledFontSize(12)).fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%').padding({ left: 16, right: 16 })
      }
      .width('100%').padding({ bottom: 16 })
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  // 新增：字体样式配置卡片
  @Builder
  buildFontStyleCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.textformat')).fontSize(24).fontColor([this.themeColors.primary])
        Text('字体样式').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily())
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Column({ space: 12 }) {
        // 同步系统字体
        Row() {
          Column() {
            Text('同步系统字体').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
              .fontFamily(this.getFontFamily())
            Text('跟随系统字体大小设置').fontSize(this.getScaledFontSize(12))
              .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
              .fontFamily(this.getFontFamily())
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)
          Button('同步').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
            .backgroundColor(this.themeColors.primary).borderRadius(16)
            .height(32).padding({ left: 16, right: 16 })
            .onClick(() => { this.syncSystemFont(); })
        }
        .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })

        Divider().color(this.themeColors.divider).margin({ left: 16, right: 16 })

        // 恢复软件默认字体
        Row() {
          Column() {
            Text('恢复软件默认字体').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
              .fontFamily(this.getFontFamily())
            Text('使用软件内置默认字体设置').fontSize(this.getScaledFontSize(12))
              .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
              .fontFamily(this.getFontFamily())
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)
          Button('恢复').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
            .backgroundColor(this.selectedFontStyle === FontStyle.DEFAULT ? this.themeColors.primary : this.themeColors.textSecondary)
            .borderRadius(16).height(32).padding({ left: 16, right: 16 })
            .onClick(() => { this.restoreDefaultFont(); })
        }
        .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 16 })

        // 当前状态提示
        Row() {
          SymbolGlyph($r('sys.symbol.checkmark_circle')).fontSize(16)
            .fontColor([this.themeColors.success])
          Text(this.selectedFontStyle === FontStyle.SYSTEM ? '当前：同步系统字体' : '当前：软件默认字体')
            .fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.success).margin({ left: 8 })
            .fontFamily(this.getFontFamily())
        }
        .width('100%').padding({ left: 16, right: 16, bottom: 12 })
      }
      .width('100%')
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  @Builder
  buildSemesterConfigCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.calendar')).fontSize(24).fontColor([this.themeColors.primary])
        Text('学期周数初始化').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Row() {
        Text('本学期总周数：').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
        Row({ space: 8 }) {
          Button('-').fontSize(18).fontColor(this.themeColors.text)
            .backgroundColor(this.themeColors.background).borderRadius(8)
            .width(36).height(36).enabled(this.totalWeeks > 1)
            .onClick(() => { if (this.totalWeeks > 1) this.totalWeeks--; })
          Text(`${this.totalWeeks}`).fontSize(this.getScaledFontSize(20)).fontWeight(FontWeight.Bold)
            .fontColor(this.themeColors.primary).width(50).textAlign(TextAlign.Center)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Button('+').fontSize(18).fontColor(this.themeColors.text)
            .backgroundColor(this.themeColors.background).borderRadius(8)
            .width(36).height(36).enabled(this.totalWeeks < 30)
            .onClick(() => { if (this.totalWeeks < 30) this.totalWeeks++; })
        }
        Blank()
        Button('保存').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
          .backgroundColor(this.themeColors.primary).borderRadius(16)
          .height(32).padding({ left: 16, right: 16 })
          .onClick(() => { this.saveTotalWeeks(); })
      }
      .width('100%').padding({ left: 16, right: 16, bottom: 16 })
      Text('周数范围：1-30周，用于课程表周数切换上限').fontSize(this.getScaledFontSize(12))
        .fontColor(this.themeColors.textSecondary).width('100%')
        .padding({ left: 16, right: 16, bottom: 16 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  @Builder
  buildDataManageCard(): void {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.trash')).fontSize(24).fontColor([this.themeColors.error])
        Text('数据管理').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text).margin({ left: 12 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%').padding({ left: 16, right: 16, top: 16, bottom: 12 })

      Row() {
        Column() {
          Text('清空课程数据').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Text('删除所有已添加的课程信息').fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .alignItems(HorizontalAlign.Start).layoutWeight(1)
        Button('清空').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
          .backgroundColor(this.themeColors.error).borderRadius(16)
          .height(32).padding({ left: 16, right: 16 })
          .onClick(() => {
            // 修复：防止弹窗动效期间的重复点击（检查清空课程弹窗状态）
            if (this.isClearCourseDialogAnimating) {
              return;
            }
            // 修复：协调检查，确保其他弹窗完全关闭后再打开（解决事件抢占问题）
            if (this.isClearTodoDialogAnimating) {
              return;
            }
            // 修复：直接设置状态，确保弹窗立即显示
            this.showClearCourseDialog = true;
          })
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
      Divider().color(this.themeColors.divider).margin({ left: 16, right: 16 })

      Row() {
        Column() {
          Text('清空待办数据').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
          Text('删除所有待办事项').fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.textSecondary).margin({ top: 4 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .alignItems(HorizontalAlign.Start).layoutWeight(1)
        Button('清空').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
          .backgroundColor(this.themeColors.error).borderRadius(16)
          .height(32).padding({ left: 16, right: 16 })
          .onClick(() => {
            // 修复：防止弹窗动效期间的重复点击（检查清空待办弹窗状态）
            if (this.isClearTodoDialogAnimating) {
              return;
            }
            // 修复：协调检查，确保其他弹窗完全关闭后再打开（解决事件抢占问题）
            if (this.isClearCourseDialogAnimating) {
              return;
            }
            // 修复：直接设置状态，确保弹窗立即显示
            this.showClearTodoDialog = true;
          })
      }
      .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 16 })
    }
    .width('100%').backgroundColor(this.themeColors.surface).borderRadius(12)
  }

  @Builder
  buildClearCourseDialog(): void {
    Column() {
      Text('确认清空').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text).margin({ top: 16, bottom: 16 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
      Text('确定要清空所有课程数据吗？此操作不可撤销。').fontSize(this.getScaledFontSize(14))
        .fontColor(this.themeColors.textSecondary).margin({ bottom: 24 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
      Row({ space: 16 }) {
        Button('取消').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background).borderRadius(20)
          .layoutWeight(1).onClick(() => { this.showClearCourseDialog = false; })
        Button('确认清空').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
          .backgroundColor(this.themeColors.error).borderRadius(20)
          .layoutWeight(1).onClick(() => { this.clearCourses(); })
      }
      .width('100%').padding({ left: 24, right: 24 })
    }
    .width('100%').padding(16)
  }

  @Builder
  buildClearTodoDialog(): void {
    Column() {
      Text('确认清空').fontSize(this.getScaledFontSize(18)).fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text).margin({ top: 16, bottom: 16 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
      Text('确定要清空所有待办数据吗？此操作不可撤销。').fontSize(this.getScaledFontSize(14))
        .fontColor(this.themeColors.textSecondary).margin({ bottom: 24 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
      Row({ space: 16 }) {
        Button('取消').fontSize(this.getScaledFontSize(14)).fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background).borderRadius(20)
          .layoutWeight(1).onClick(() => { this.showClearTodoDialog = false; })
        Button('确认清空').fontSize(this.getScaledFontSize(14)).fontColor(Color.White)
          .backgroundColor(this.themeColors.error).borderRadius(20)
          .layoutWeight(1).onClick(() => { this.clearTodos(); })
      }
      .width('100%').padding({ left: 24, right: 24 })
    }
    .width('100%').padding(16)
  }
}