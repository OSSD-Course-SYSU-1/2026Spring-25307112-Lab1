/**
 * 字体大小枚举
 * 说明：提供小、标准、大、超大四档字号选项
 */
export enum FontSize {
  SMALL = 0,    // 小号字体
  STANDARD = 1, // 标准字体
  LARGE = 2,    // 大号字体
  EXTRA_LARGE = 3 // 超大号字体
}

/**
 * 字体样式枚举
 * 说明：提供系统字体和软件默认字体两种选项
 */
export enum FontStyle {
  SYSTEM = 0,   // 同步系统字体
  DEFAULT = 1   // 软件默认字体
}

/**
 * 字体配置数据类
 */
export class FontConfig {
  fontSize: FontSize = FontSize.STANDARD;
  fontStyle: FontStyle = FontStyle.SYSTEM;

  constructor(fontSize?: FontSize, fontStyle?: FontStyle) {
    this.fontSize = fontSize ?? FontSize.STANDARD;
    this.fontStyle = fontStyle ?? FontStyle.SYSTEM;
  }

  /**
   * 获取字体大小缩放比例
   * 说明：根据字体大小枚举返回对应的缩放比例
   */
  getFontScale(): number {
    switch (this.fontSize) {
      case FontSize.SMALL:
        return 0.85;
      case FontSize.STANDARD:
        return 1.0;
      case FontSize.LARGE:
        return 1.15;
      case FontSize.EXTRA_LARGE:
        return 1.3;
      default:
        return 1.0;
    }
  }

  /**
   * 获取字体样式名称
   * 说明：用于设置字体族
   */
  getFontFamily(): string {
    // 统一使用HarmonyOS Sans系统默认字体
    return 'HarmonyOS Sans';
  }

  /**
   * 获取字体大小显示名称
   */
  getFontSizeName(): string {
    switch (this.fontSize) {
      case FontSize.SMALL:
        return '小';
      case FontSize.STANDARD:
        return '标准';
      case FontSize.LARGE:
        return '大';
      case FontSize.EXTRA_LARGE:
        return '超大';
      default:
        return '标准';
    }
  }

  /**
   * 获取字体样式显示名称
   */
  getFontStyleName(): string {
    switch (this.fontStyle) {
      case FontStyle.SYSTEM:
        return '同步系统字体';
      case FontStyle.DEFAULT:
        return '软件默认字体';
      default:
        return '软件默认字体';
    }
  }
}

/**
 * 字体配置管理器
 * 功能：管理全局字体大小和字体样式，支持监听器模式通知变更
 */
export class FontConfigUtil {
  private static instance: FontConfigUtil;
  private fontConfig: FontConfig = new FontConfig();
  private listeners: ((config: FontConfig) => void)[] = [];

  private constructor() {}

  static getInstance(): FontConfigUtil {
    if (!FontConfigUtil.instance) {
      FontConfigUtil.instance = new FontConfigUtil();
    }
    return FontConfigUtil.instance;
  }

  /**
   * 初始化字体配置
   * 说明：从Preferences加载字体配置
   */
  async init(): Promise<void> {
    // 初始化逻辑在PreferencesUtil中实现
  }

  /**
   * 获取当前字体配置
   */
  getFontConfig(): FontConfig {
    return this.fontConfig;
  }

  /**
   * 更新字体配置
   * 说明：更新配置并通知所有监听者
   */
  updateFontConfig(config: FontConfig): void {
    this.fontConfig = config;
    this.notifyListeners();
  }

  /**
   * 设置字体大小
   */
  setFontSize(fontSize: FontSize): void {
    if (this.fontConfig.fontSize !== fontSize) {
      this.fontConfig.fontSize = fontSize;
      this.notifyListeners();
    }
  }

  /**
   * 设置字体样式
   */
  setFontStyle(fontStyle: FontStyle): void {
    if (this.fontConfig.fontStyle !== fontStyle) {
      this.fontConfig.fontStyle = fontStyle;
      this.notifyListeners();
    }
  }

  /**
   * 添加监听器
   * 说明：当字体配置变更时回调
   */
  addListener(callback: (config: FontConfig) => void): void {
    this.listeners.push(callback);
  }

  /**
   * 移除监听器
   */
  removeListener(callback: (config: FontConfig) => void): void {
    const index = this.listeners.indexOf(callback);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  /**
   * 通知所有监听者
   */
  private notifyListeners(): void {
    for (const listener of this.listeners) {
      listener(this.fontConfig);
    }
  }
}
