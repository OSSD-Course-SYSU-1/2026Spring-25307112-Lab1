import { BackgroundManager } from '../utils/BackgroundManager';
import { ThemeManager, ThemeColors } from '../utils/ThemeManager';

/**
 * 背景图组件
 * 功能：显示自定义背景图，支持深浅色模式透明度适配
 * 特性：自适应布局、不拉伸错位
 */
@Component
export struct BackgroundImage {
  @State backgroundUri: string = '';
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State bgOpacity: number = 0.5; // 修改：重命名避免与基类属性冲突
  
  private backgroundListener: ((uri: string) => void) | null = null;
  private themeListener: ((isDark: boolean) => void) | null = null;

  aboutToAppear(): void {
    // 新增：初始化背景图监听器
    this.backgroundListener = (uri: string) => {
      this.backgroundUri = uri;
    };
    BackgroundManager.getInstance().addListener(this.backgroundListener);
    this.backgroundUri = BackgroundManager.getInstance().getBackgroundUri();
    
    // 新增：初始化主题监听器
    this.themeListener = (_isDark: boolean) => {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
      this.bgOpacity = BackgroundManager.getInstance().getBackgroundOpacity();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    this.bgOpacity = BackgroundManager.getInstance().getBackgroundOpacity();
  }

  aboutToDisappear(): void {
    // 新增：移除背景图监听器
    if (this.backgroundListener) {
      BackgroundManager.getInstance().removeListener(this.backgroundListener);
    }
    // 新增：移除主题监听器
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
  }

  build() {
    Stack() {
      // 新增：背景图层
      if (this.backgroundUri !== '') {
        Image(this.backgroundUri)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover) // 自适应填充，不拉伸
          .opacity(this.bgOpacity) // 根据深浅色模式调整透明度
      }
      // 新增：半透明遮罩层，确保文字可读性
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.themeColors.background)
        .opacity(this.backgroundUri !== '' ? 0.6 : 1) // 有背景图时降低遮罩透明度
    }
    .width('100%')
    .height('100%')
  }
}
