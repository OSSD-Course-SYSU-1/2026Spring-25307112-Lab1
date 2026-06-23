import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { ThemeManager } from '../utils/ThemeManager';
import { ScheduleConfigUtil } from '../utils/ScheduleConfigUtil';
import { FontConfigUtil } from '../utils/FontConfigUtil'; // 新增：字体配置管理

/**
 * EntryAbility
 * 应用入口能力，处理应用生命周期和接续
 */
export default class EntryAbility extends UIAbility {
  /**
   * 应用创建时调用
   */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    PreferencesUtil.getInstance().init(this.context);
    ThemeManager.getInstance().init();
    ScheduleConfigUtil.getInstance().init();
    // 新增：初始化字体配置并加载保存的配置
    this.initFontConfig();
  }

  // 新增：初始化字体配置
  async initFontConfig(): Promise<void> {
    try {
      const config = await PreferencesUtil.getInstance().getFontConfig();
      FontConfigUtil.getInstance().updateFontConfig(config);
    } catch (error) {
      hilog.error(0x0000, 'testTag', 'Failed to init font config: %{public}s', JSON.stringify(error));
    }
  }

  /**
   * 销毁时调用
   */
  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  /**
   * 创建窗口时调用
   */
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    const mainWindow = await windowStage.getMainWindow();
    await mainWindow.setWindowSystemBarEnable(['status', 'navigation']);

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load content. Cause: %{public}s',
          JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading content.');
    });
  }

  /**
   * 销毁窗口时调用
   */
  onWindowStageDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  /**
   * 进入前台时调用
   */
  onForeground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  /**
   * 进入后台时调用
   */
  onBackground(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  /**
   * 应用接续 - 处理跨设备流转
   */
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    hilog.info(0x0000, 'testTag', 'onContinue called');

    const version = 1;
    wantParam['version'] = version;
    wantParam['targetBundle'] = 'com.example.campushelper';

    return AbilityConstant.OnContinueResult.AGREE;
  }

  /**
   * 新设备上恢复数据
   */
  async onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    hilog.info(0x0000, 'testTag', 'onNewWant called');

    if (want.parameters) {
      const continueData = want.parameters['continueData'];
      if (continueData) {
        hilog.info(0x0000, 'testTag', 'Received continue data: %{public}s', JSON.stringify(continueData));
      }
    }
  }
}
