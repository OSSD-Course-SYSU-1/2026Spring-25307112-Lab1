import { ThemeManager, ThemeColors } from '../utils/ThemeManager';

/**
 * 通用标题栏组件
 */
@Component
export struct CommonTitleBar {
  @Prop title: string = '';
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  onBackPress?: () => void;
  onRightPress?: () => void;
  rightIcon: Resource = $r('sys.symbol.gear');

  build() {
    Row() {
      if (this.onBackPress) {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24)
          .fontColor([this.themeColors.text])
          .onClick(() => {
            if (this.onBackPress) {
              this.onBackPress();
            }
          })
      }

      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .layoutWeight(1)
        .margin({ left: this.onBackPress ? 12 : 0 })

      if (this.onRightPress) {
        SymbolGlyph(this.rightIcon)
          .fontSize(24)
          .fontColor([this.themeColors.text])
          .onClick(() => {
            if (this.onRightPress) {
              this.onRightPress();
            }
          })
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }
}
