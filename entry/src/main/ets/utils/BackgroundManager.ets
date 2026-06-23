import { ThemeManager, ThemeColors } from './ThemeManager';

/**
 * 背景图管理类
 * 功能：管理自定义背景图的存储、读取和应用
 * 特性：单例模式、深浅色模式适配、持久化存储
 */
export class BackgroundManager {
  private static instance: BackgroundManager | null = null;
  private backgroundUri: string = ''; // 自定义背景图URI
  private listeners: ((uri: string) => void)[] = []; // 背景变化监听器
  
  private constructor() {}
  
  static getInstance(): BackgroundManager {
    if (!BackgroundManager.instance) {
      BackgroundManager.instance = new BackgroundManager();
    }
    return BackgroundManager.instance;
  }
  
  /**
   * 设置背景图URI
   */
  setBackgroundUri(uri: string): void {
    this.backgroundUri = uri;
    this.notifyListeners();
  }
  
  /**
   * 获取背景图URI
   */
  getBackgroundUri(): string {
    return this.backgroundUri;
  }
  
  /**
   * 清除背景图
   */
  clearBackground(): void {
    this.backgroundUri = '';
    this.notifyListeners();
  }
  
  /**
   * 是否有自定义背景
   */
  hasCustomBackground(): boolean {
    return this.backgroundUri !== '';
  }
  
  /**
   * 添加监听器
   */
  addListener(listener: (uri: string) => void): void {
    this.listeners.push(listener);
  }
  
  /**
   * 移除监听器
   */
  removeListener(listener: (uri: string) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }
  
  /**
   * 通知所有监听器
   */
  private notifyListeners(): void {
    for (const listener of this.listeners) {
      listener(this.backgroundUri);
    }
  }
  
  /**
   * 获取背景图透明度（根据深浅色模式）
   * 深色模式：降低透明度使图片更暗
   * 浅色模式：提高透明度使图片更亮
   */
  getBackgroundOpacity(): number {
    const isDark = ThemeManager.getInstance().getIsDarkMode();
    return isDark ? 0.3 : 0.5; // 深色模式30%透明度，浅色模式50%透明度
  }
}
