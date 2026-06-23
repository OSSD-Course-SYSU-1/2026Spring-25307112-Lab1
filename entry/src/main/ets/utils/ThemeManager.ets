/**
 * 主题颜色配置
 */
export class ThemeColors {
  primary: string = '#4A90E2';
  secondary: string = '#7B68EE';
  background: string = '#F5F5F5';
  surface: string = '#FFFFFF';
  text: string = '#333333';
  textSecondary: string = '#666666';
  divider: string = '#E0E0E0';
  error: string = '#E24A4A';
  success: string = '#4AE24A';
  warning: string = '#E2A04A';
}

/**
 * 主题预览颜色（用于主题选择卡片展示）
 * 说明：这些颜色固定不变，用于在主题选择弹窗中展示浅色/深色主题的视觉效果
 */
export class ThemePreviewColors {
  // 浅色主题预览颜色
  static readonly LIGHT_BACKGROUND: string = '#F5F5F5';
  static readonly LIGHT_SURFACE: string = '#FFFFFF';
  static readonly LIGHT_DIVIDER: string = '#E0E0E0';
  
  // 深色主题预览颜色
  static readonly DARK_BACKGROUND: string = '#1E1E1E';
  static readonly DARK_SURFACE: string = '#2D2D2D';
}

/**
 * 主题管理器
 * 功能：跟随系统深浅色、手动切换主题
 */
export class ThemeManager {
  private static instance: ThemeManager;
  private isDarkMode: boolean = false;
  private followSystem: boolean = true;
  private listeners: ((isDark: boolean) => void)[] = [];
  private lightColors: ThemeColors = new ThemeColors();
  private darkColors: ThemeColors = new ThemeColors();

  private constructor() {
    this.darkColors.background = '#1E1E1E';
    this.darkColors.surface = '#2D2D2D';
    this.darkColors.text = '#FFFFFF';
    this.darkColors.textSecondary = '#AAAAAA';
    this.darkColors.divider = '#404040';
  }

  static getInstance(): ThemeManager {
    if (!ThemeManager.instance) {
      ThemeManager.instance = new ThemeManager();
    }
    return ThemeManager.instance;
  }

  init(): void {
    // 初始化时获取系统主题状态
  }

  getIsDarkMode(): boolean {
    return this.isDarkMode;
  }

  getThemeColor(): ThemeColors {
    return this.isDarkMode ? this.darkColors : this.lightColors;
  }

  setThemeMode(isDark: boolean): void {
    this.followSystem = false;
    if (this.isDarkMode !== isDark) {
      this.isDarkMode = isDark;
      this.notifyListeners();
    }
  }

  toggleTheme(): void {
    this.followSystem = true;
    this.isDarkMode = !this.isDarkMode;
    this.notifyListeners();
  }

  onSystemThemeChange(isDark: boolean): void {
    if (this.followSystem) {
      this.isDarkMode = isDark;
      this.notifyListeners();
    }
  }

  addListener(callback: (isDark: boolean) => void): void {
    this.listeners.push(callback);
  }

  removeListener(callback: (isDark: boolean) => void): void {
    const index = this.listeners.indexOf(callback);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  private notifyListeners(): void {
    for (const listener of this.listeners) {
      listener(this.isDarkMode);
    }
  }
}
