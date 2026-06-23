import router from '@ohos.router';
import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { ScheduleConfigUtil } from '../utils/ScheduleConfigUtil';
import { ScheduleConfig, SectionTime } from '../model/ScheduleConfigModel';
import { ResponsiveUtil } from '../utils/ResponsiveUtil';

/**
 * 课时配置页面
 * 功能：自定义单日总课程节数、每节课起止时间
 * 特性：Preferences持久化、深浅色主题、多端适配
 */
@Entry
@Component
struct ScheduleConfigPage {
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State scheduleConfig: ScheduleConfig = ScheduleConfig.getDefaultConfig();
  @State deviceWidth: number = 360;
  @State showSaveSuccess: boolean = false;
  
  private themeListener: ((isDark: boolean) => void) | null = null;
  private configListener: ((config: ScheduleConfig) => void) | null = null;

  aboutToAppear(): void {
    this.loadConfig();
    
    // 主题监听
    this.themeListener = (_isDark: boolean) => {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    
    // 课时配置监听
    this.configListener = (config: ScheduleConfig) => {
      this.scheduleConfig = config;
    };
    ScheduleConfigUtil.getInstance().addListener(this.configListener);
  }

  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
    if (this.configListener) {
      ScheduleConfigUtil.getInstance().removeListener(this.configListener);
    }
  }

  /**
   * 加载课时配置
   */
  async loadConfig(): Promise<void> {
    await ScheduleConfigUtil.getInstance().init();
    this.scheduleConfig = ScheduleConfigUtil.getInstance().getConfig();
  }

  /**
   * 保存课时配置
   */
  async saveConfig(): Promise<void> {
    await ScheduleConfigUtil.getInstance().updateConfig(this.scheduleConfig);
    this.showSaveSuccess = true;
    // 2秒后隐藏成功提示
    setTimeout(() => {
      this.showSaveSuccess = false;
    }, 2000);
  }

  /**
   * 更新总节数
   */
  updateTotalSections(total: number): void {
    if (total < 1 || total > 12) return;
    
    const newConfig = new ScheduleConfig();
    newConfig.totalSections = total;
    newConfig.sectionTimes = [];
    
    // 保留现有时间配置，不足的部分使用默认值
    for (let i = 1; i <= total; i++) {
      const existing = this.scheduleConfig.sectionTimes.find(st => st.section === i);
      if (existing) {
        newConfig.sectionTimes.push(existing);
      } else {
        // 使用默认时间
        const defaultConfig = ScheduleConfig.generateDefaultConfig(total);
        const defaultTime = defaultConfig.sectionTimes.find(st => st.section === i);
        if (defaultTime) {
          newConfig.sectionTimes.push(defaultTime);
        }
      }
    }
    
    this.scheduleConfig = newConfig;
  }

  /**
   * 更新指定节次的时间
   */
  updateSectionTime(section: number, startTime: string, endTime: string): void {
    const index = this.scheduleConfig.sectionTimes.findIndex(st => st.section === section);
    if (index >= 0) {
      this.scheduleConfig.sectionTimes[index].startTime = startTime;
      this.scheduleConfig.sectionTimes[index].endTime = endTime;
    }
  }

  /**
   * 判断是否为平板设备
   */
  isTablet(): boolean {
    return ResponsiveUtil.isTablet(this.deviceWidth);
  }

  build() {
    Column() {
      this.buildTitleBar()
      
      if (this.showSaveSuccess) {
        Row() {
          SymbolGlyph($r('sys.symbol.checkmark_circle'))
            .fontSize(20)
            .fontColor([this.themeColors.success])
          
          Text('保存成功')
            .fontSize(14)
            .fontColor(this.themeColors.success)
            .margin({ left: 8 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor(this.themeColors.surface)
      }
      
      Scroll() {
        Column({ space: 16 }) {
          // 总节数配置
          this.buildTotalSectionsConfig()
          
          Divider().color(this.themeColors.divider)
          
          // 每节课时间配置
          this.buildSectionTimesConfig()
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
      
      // 保存按钮
      Row() {
        Button('保存配置')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(24)
          .width('80%')
          .height(48)
          .onClick(() => {
            this.saveConfig();
          })
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.themeColors.surface)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      this.deviceWidth = newValue.width as number;
    })
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      Text('课时配置')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)

      Blank()

      Text('自定义课程节数和时间')
        .fontSize(14)
        .fontColor(this.themeColors.textSecondary)

      // 新增：关闭按钮（圆形叉号图标，点击返回课程表页面）
      Button() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize(16)
          .fontColor([this.themeColors.text])
      }
      .width(32)
      .height(32)
      .borderRadius(16)
      .backgroundColor(this.themeColors.background)
      .margin({ left: 12 })
      .onClick(() => {
        // 点击关闭按钮返回课程表页面
        router.back();
      })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  /**
   * 总节数配置
   */
  @Builder
  buildTotalSectionsConfig(): void {
    Column() {
      Row() {
        Text('每日总节数')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text)
        
        Blank()
        
        Text(`${this.scheduleConfig.totalSections} 节`)
          .fontSize(16)
          .fontColor(this.themeColors.primary)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row({ space: 16 }) {
        Button('-')
          .fontSize(20)
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .width(48)
          .height(48)
          .enabled(this.scheduleConfig.totalSections > 1)
          .onClick(() => {
            this.updateTotalSections(this.scheduleConfig.totalSections - 1);
          })

        Slider({
          value: this.scheduleConfig.totalSections,
          min: 1,
          max: 12,
          step: 1
        })
          .blockColor(this.themeColors.primary)
          .trackColor(this.themeColors.divider)
          .selectedColor(this.themeColors.primary)
          .layoutWeight(1)
          .onChange((value: number) => {
            this.updateTotalSections(Math.round(value));
          })

        Button('+')
          .fontSize(20)
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .width(48)
          .height(48)
          .enabled(this.scheduleConfig.totalSections < 12)
          .onClick(() => {
            this.updateTotalSections(this.scheduleConfig.totalSections + 1);
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Text('建议设置范围为6-10节')
        .fontSize(12)
        .fontColor(this.themeColors.textSecondary)
        .margin({ top: 8 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.themeColors.surface)
    .borderRadius(12)
  }

  /**
   * 每节课时间配置
   */
  @Builder
  buildSectionTimesConfig(): void {
    Column() {
      Text('每节课时间')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.themeColors.text)
        .width('100%')
        .margin({ bottom: 12 })

      ForEach(this.scheduleConfig.sectionTimes, (sectionTime: SectionTime, index: number) => {
        this.buildSectionTimeItem(sectionTime, index)
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.themeColors.surface)
    .borderRadius(12)
  }

  /**
   * 单节课时间配置项
   */
  @Builder
  buildSectionTimeItem(sectionTime: SectionTime, index: number): void {
    Row() {
      Text(`第${sectionTime.section}节`)
        .fontSize(14)
        .fontColor(this.themeColors.text)
        .width(60)

      TextInput({ text: sectionTime.startTime })
        .width(this.isTablet() ? 100 : 80)
        .height(36)
        .fontSize(14)
        .fontColor(this.themeColors.text)
        .backgroundColor(this.themeColors.background)
        .borderRadius(8)
        .placeholderColor(this.themeColors.textSecondary)
        .onChange((value: string) => {
          this.updateSectionTime(sectionTime.section, value, sectionTime.endTime);
        })

      Text('-')
        .fontSize(14)
        .fontColor(this.themeColors.textSecondary)
        .margin({ left: 8, right: 8 })

      TextInput({ text: sectionTime.endTime })
        .width(this.isTablet() ? 100 : 80)
        .height(36)
        .fontSize(14)
        .fontColor(this.themeColors.text)
        .backgroundColor(this.themeColors.background)
        .borderRadius(8)
        .placeholderColor(this.themeColors.textSecondary)
        .onChange((value: string) => {
          this.updateSectionTime(sectionTime.section, sectionTime.startTime, value);
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .margin({ top: index === 0 ? 0 : 12 })
  }
}
