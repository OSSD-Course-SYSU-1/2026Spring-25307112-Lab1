import { ThemeManager, ThemeColors } from '../utils/ThemeManager';

/**
 * 空状态组件
 */
@Component
export struct EmptyState {
  @Prop message: string = '暂无数据';
  @Prop icon: Resource = $r('sys.symbol.tray');
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();

  build() {
    Column({ space: 16 }) {
      SymbolGlyph(this.icon)
        .fontSize(48)
        .fontColor([this.themeColors.textSecondary])

      Text(this.message)
        .fontSize(14)
        .fontColor(this.themeColors.textSecondary)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
