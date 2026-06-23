import { FontConfig, FontSize, FontStyle } from './FontConfigUtil';

/**
 * 字体大小预设值类
 * 说明：提供常用的字体大小常量，便于统一管理
 */
export class FontSizePreset {
  static readonly TITLE_LARGE: number = 22;      // 大标题
  static readonly TITLE_MEDIUM: number = 20;     // 中标题
  static readonly TITLE_SMALL: number = 18;      // 小标题
  static readonly BODY_LARGE: number = 16;       // 大正文
  static readonly BODY_MEDIUM: number = 14;      // 中正文（默认）
  static readonly BODY_SMALL: number = 12;       // 小正文
  static readonly CAPTION: number = 10;          // 说明文字
  static readonly BUTTON: number = 14;           // 按钮文字
  static readonly TAB: number = 12;              // 标签文字
}

/**
 * 字体辅助工具类
 * 功能：提供字体大小缩放和字体样式应用的方法
 * 说明：用于在各页面中统一应用字体配置
 */
export class FontHelper {
  /**
   * 获取缩放后的字体大小
   * @param baseSize 基础字体大小
   * @param config 字体配置
   * @returns 缩放后的字体大小
   */
  static getScaledFontSize(baseSize: number, config: FontConfig): number {
    return baseSize * config.getFontScale();
  }

  /**
   * 获取字体族
   * @param config 字体配置
   * @returns 字体族名称
   */
  static getFontFamily(config: FontConfig): string {
    return config.getFontFamily();
  }
}
