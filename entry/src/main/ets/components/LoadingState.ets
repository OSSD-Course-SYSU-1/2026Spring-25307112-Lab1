import { ThemeManager, ThemeColors } from '../utils/ThemeManager';

/**
 * 加载状态组件
 */
@Component
export struct LoadingState {
  @Prop message: string = '加载中...';
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();

  build() {
    Column({ space: 16 }) {
      LoadingProgress()
        .width(48)
        .height(48)
        .color(this.themeColors.primary)

      Text(this.message)
        .fontSize(14)
        .fontColor(this.themeColors.textSecondary)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
