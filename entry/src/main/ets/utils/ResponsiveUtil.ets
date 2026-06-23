/**
 * 响应式布局工具类
 * 用于适配不同屏幕尺寸
 */
export class ResponsiveUtil {
  /**
   * 设备类型枚举
   */
  static readonly DEVICE_PHONE: number = 0;
  static readonly DEVICE_TABLET: number = 1;
  static readonly DEVICE_DESKTOP: number = 2;

  /**
   * 根据宽度判断设备类型
   */
  static getDeviceType(width: number): number {
    if (width < 600) {
      return ResponsiveUtil.DEVICE_PHONE;
    } else if (width < 840) {
      return ResponsiveUtil.DEVICE_TABLET;
    } else {
      return ResponsiveUtil.DEVICE_DESKTOP;
    }
  }

  /**
   * 获取列数
   */
  static getColumnCount(width: number): number {
    const deviceType = ResponsiveUtil.getDeviceType(width);
    if (deviceType === ResponsiveUtil.DEVICE_PHONE) {
      return 4;
    } else if (deviceType === ResponsiveUtil.DEVICE_TABLET) {
      return 8;
    } else {
      return 12;
    }
  }

  /**
   * 获取间距
   */
  static getGutter(width: number): number {
    const deviceType = ResponsiveUtil.getDeviceType(width);
    if (deviceType === ResponsiveUtil.DEVICE_PHONE) {
      return 12;
    } else if (deviceType === ResponsiveUtil.DEVICE_TABLET) {
      return 16;
    } else {
      return 24;
    }
  }

  /**
   * 获取内容最大宽度
   */
  static getMaxContentWidth(width: number): number {
    const deviceType = ResponsiveUtil.getDeviceType(width);
    if (deviceType === ResponsiveUtil.DEVICE_PHONE) {
      return width;
    } else if (deviceType === ResponsiveUtil.DEVICE_TABLET) {
      return 720;
    } else {
      return 960;
    }
  }

  /**
   * 获取字体缩放比例
   */
  static getFontScale(width: number): number {
    const deviceType = ResponsiveUtil.getDeviceType(width);
    if (deviceType === ResponsiveUtil.DEVICE_PHONE) {
      return 1.0;
    } else if (deviceType === ResponsiveUtil.DEVICE_TABLET) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /**
   * 判断是否为平板
   */
  static isTablet(width: number): boolean {
    return ResponsiveUtil.getDeviceType(width) === ResponsiveUtil.DEVICE_TABLET;
  }

  /**
   * 判断是否为手机
   */
  static isPhone(width: number): boolean {
    return ResponsiveUtil.getDeviceType(width) === ResponsiveUtil.DEVICE_PHONE;
  }
}
