import { ScheduleConfig } from '../model/ScheduleConfigModel';
import { PreferencesUtil } from './PreferencesUtil';

/**
 * 课时配置工具类
 * 功能：管理课时配置的缓存、监听和持久化
 * 特性：单例模式、配置变更监听
 */
export class ScheduleConfigUtil {
  private static instance: ScheduleConfigUtil;
  private config: ScheduleConfig = ScheduleConfig.getDefaultConfig();
  private listeners: ((config: ScheduleConfig) => void)[] = [];

  private constructor() {}

  /**
   * 获取单例实例
   */
  static getInstance(): ScheduleConfigUtil {
    if (!ScheduleConfigUtil.instance) {
      ScheduleConfigUtil.instance = new ScheduleConfigUtil();
    }
    return ScheduleConfigUtil.instance;
  }

  /**
   * 初始化配置（从Preferences加载）
   */
  async init(): Promise<void> {
    this.config = await PreferencesUtil.getInstance().getScheduleConfig();
  }

  /**
   * 获取当前配置
   */
  getConfig(): ScheduleConfig {
    return this.config;
  }

  /**
   * 获取总节数
   */
  getTotalSections(): number {
    return this.config.totalSections;
  }

  /**
   * 获取指定节次的时间配置
   * @param section 节次（1-based）
   */
  getSectionTime(section: number): string {
    const time = this.config.sectionTimes.find(st => st.section === section);
    if (time) {
      return `${time.startTime}-${time.endTime}`;
    }
    return '';
  }

  /**
   * 获取所有节次的显示文本
   */
  getSectionLabels(): string[] {
    const labels: string[] = [];
    for (let i = 1; i <= this.config.totalSections; i++) {
      const time = this.getSectionTime(i);
      if (time) {
        labels.push(`第${i}节 (${time})`);
      } else {
        labels.push(`第${i}节`);
      }
    }
    return labels;
  }

  /**
   * 更新配置并持久化
   * @param config 新配置
   */
  async updateConfig(config: ScheduleConfig): Promise<void> {
    this.config = config;
    await PreferencesUtil.getInstance().saveScheduleConfig(config);
    // 通知所有监听者
    this.listeners.forEach(listener => listener(config));
  }

  /**
   * 添加配置变更监听器
   * @param listener 监听回调函数
   */
  addListener(listener: (config: ScheduleConfig) => void): void {
    this.listeners.push(listener);
  }

  /**
   * 移除配置变更监听器
   * @param listener 监听回调函数
   */
  removeListener(listener: (config: ScheduleConfig) => void): void {
    const index = this.listeners.indexOf(listener);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }
}
