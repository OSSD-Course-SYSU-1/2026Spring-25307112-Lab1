/**
 * 设备类型枚举
 */
export enum DeviceType {
    PHONE = "phone",
    PHABLET = "phablet",
    TABLET = "tablet",
    FOLDABLE = "foldable",
    LARGE_SCREEN = "large" // 大屏设备 (> 1280vp)
}
/**
 * 断点配置
 */
export class Breakpoints {
    // 断点阈值（单位：vp）
    static readonly SM = 600; // 小屏断点
    static readonly MD = 840; // 中屏断点
    static readonly LG = 1024; // 大屏断点
    static readonly XL = 1280; // 超大屏断点
}
/**
 * 设备适配工具类
 * 提供屏幕检测、断点判断、布局参数计算等功能
 */
export class DeviceHelper {
    /**
     * 根据窗口宽度获取设备类型
     * @param width 窗口宽度（vp）
     * @returns 设备类型
     */
    static getDeviceType(width: number): DeviceType {
        if (width < Breakpoints.SM) {
            return DeviceType.PHONE;
        }
        else if (width < Breakpoints.MD) {
            return DeviceType.PHABLET;
        }
        else if (width < Breakpoints.LG) {
            return DeviceType.TABLET;
        }
        else if (width < Breakpoints.XL) {
            return DeviceType.FOLDABLE;
        }
        else {
            return DeviceType.LARGE_SCREEN;
        }
    }
    /**
     * 获取滤镜网格列数
     * @param deviceType 设备类型
     * @returns 网格列数
     */
    static getFilterGridColumns(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 3; // 手机：3列
            case DeviceType.PHABLET:
                return 4; // 大屏手机：4列
            case DeviceType.TABLET:
                return 5; // 平板：5列
            case DeviceType.FOLDABLE:
                return 6; // 折叠屏：6列
            case DeviceType.LARGE_SCREEN:
                return 7; // 大屏：7列
            default:
                return 3;
        }
    }
    /**
     * 获取图片轮播高度
     * @param deviceType 设备类型
     * @param screenHeight 屏幕高度
     * @returns 图片高度
     */
    static getImageCarouselHeight(deviceType: DeviceType, screenHeight: number): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return Math.min(320, screenHeight * 0.4);
            case DeviceType.PHABLET:
                return Math.min(380, screenHeight * 0.45);
            case DeviceType.TABLET:
                return Math.min(450, screenHeight * 0.5);
            case DeviceType.FOLDABLE:
                return Math.min(500, screenHeight * 0.5);
            case DeviceType.LARGE_SCREEN:
                return Math.min(550, screenHeight * 0.5);
            default:
                return 320;
        }
    }
    /**
     * 获取内容区域最大宽度
     * @param deviceType 设备类型
     * @returns 最大宽度（百分比或具体值）
     */
    static getContentMaxWidth(deviceType: DeviceType): number | string {
        switch (deviceType) {
            case DeviceType.PHONE:
                return '100%';
            case DeviceType.PHABLET:
                return '100%';
            case DeviceType.TABLET:
                return 800;
            case DeviceType.FOLDABLE:
                return 1000;
            case DeviceType.LARGE_SCREEN:
                return 1200;
            default:
                return '100%';
        }
    }
    /**
     * 获取参数面板布局方向
     * @param deviceType 设备类型
     * @returns 是否使用横向布局
     */
    static isHorizontalLayout(deviceType: DeviceType): boolean {
        return deviceType === DeviceType.TABLET ||
            deviceType === DeviceType.FOLDABLE ||
            deviceType === DeviceType.LARGE_SCREEN;
    }
    /**
     * 获取参数滑块网格列数
     * @param deviceType 设备类型
     * @returns 网格列数
     */
    static getParamGridColumns(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 1; // 手机：单列
            case DeviceType.PHABLET:
                return 1; // 大屏手机：单列
            case DeviceType.TABLET:
                return 2; // 平板：双列
            case DeviceType.FOLDABLE:
                return 2; // 折叠屏：双列
            case DeviceType.LARGE_SCREEN:
                return 3; // 大屏：三列
            default:
                return 1;
        }
    }
    /**
     * 获取字体大小缩放因子
     * @param deviceType 设备类型
     * @returns 缩放因子
     */
    static getFontScaleFactor(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 1.0;
            case DeviceType.PHABLET:
                return 1.05;
            case DeviceType.TABLET:
                return 1.15;
            case DeviceType.FOLDABLE:
                return 1.2;
            case DeviceType.LARGE_SCREEN:
                return 1.25;
            default:
                return 1.0;
        }
    }
    /**
     * 获取间距缩放因子
     * @param deviceType 设备类型
     * @returns 缩放因子
     */
    static getSpacingScaleFactor(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 1.0;
            case DeviceType.PHABLET:
                return 1.1;
            case DeviceType.TABLET:
                return 1.3;
            case DeviceType.FOLDABLE:
                return 1.4;
            case DeviceType.LARGE_SCREEN:
                return 1.5;
            default:
                return 1.0;
        }
    }
    /**
     * 是否显示侧边栏模式
     * @param deviceType 设备类型
     * @returns 是否显示侧边栏
     */
    static showSideBar(deviceType: DeviceType): boolean {
        return deviceType === DeviceType.FOLDABLE ||
            deviceType === DeviceType.LARGE_SCREEN;
    }
    /**
     * 获取启动页Logo大小
     * @param deviceType 设备类型
     * @returns Logo大小
     */
    static getSplashLogoSize(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 140;
            case DeviceType.PHABLET:
                return 160;
            case DeviceType.TABLET:
                return 200;
            case DeviceType.FOLDABLE:
                return 220;
            case DeviceType.LARGE_SCREEN:
                return 260;
            default:
                return 140;
        }
    }
    /**
     * 获取启动页标题字体大小
     * @param deviceType 设备类型
     * @returns 字体大小
     */
    static getSplashTitleSize(deviceType: DeviceType): number {
        switch (deviceType) {
            case DeviceType.PHONE:
                return 38;
            case DeviceType.PHABLET:
                return 42;
            case DeviceType.TABLET:
                return 48;
            case DeviceType.FOLDABLE:
                return 52;
            case DeviceType.LARGE_SCREEN:
                return 58;
            default:
                return 38;
        }
    }
}
