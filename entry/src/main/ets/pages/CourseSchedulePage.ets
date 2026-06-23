import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CourseModel } from '../model/CourseModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';
import { ScheduleConfigUtil } from '../utils/ScheduleConfigUtil';
import { ScheduleConfig } from '../model/ScheduleConfigModel';
import { ResponsiveUtil } from '../utils/ResponsiveUtil';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil'; // 新增：字体配置
import { FontHelper } from '../utils/FontHelper'; // 新增：字体辅助工具
import { BackgroundImage } from '../components/BackgroundImage'; // 新增：背景图组件

/**
 * 课程颜色选项
 */
const COURSE_COLORS: string[] = [
  '#4A90E2', '#E24A4A', '#4AE24A', '#E2E24A',
  '#4AE2E2', '#E24AE2', '#E2A04A', '#4AE2A0'
];

/**
 * 下拉选项接口
 */
interface SelectOption {
  value: string;
}

/**
 * 课程表页面
 * 功能：周视图切换、课程CRUD、当日高亮、Preferences存储
 */
@Component
export struct CourseSchedulePage {
  @State courses: CourseModel[] = [];
  @State currentWeek: number = 1;
  @State showAddDialog: boolean = false;
  @State editingCourse: CourseModel | null = null;
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State selectedDay: number = DateTimeUtil.getCurrentDayOfWeek();
  
  // 新增状态：节次选择和周几选择
  @State selectedSection: number = 1;           // 选中的开始节次
  @State selectedEndSection: number = 1;        // 选中的结束节次
  @State selectedDayOfWeek: number = 1;         // 选中的周几
  @State deviceWidth: number = 360;             // 设备宽度
  @State scheduleConfig: ScheduleConfig = ScheduleConfig.getDefaultConfig(); // 课时配置
  
  // 周数调节相关状态
  @State showWeekDialog: boolean = false;       // 是否显示周数调节弹窗
  @State tempWeekInput: string = '1';           // 周数输入框临时值
  @State fontConfig: FontConfig = new FontConfig(); // 新增：字体配置状态
  
  private weekDays: string[] = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  private themeListener: ((isDark: boolean) => void) | null = null;
  private configListener: ((config: ScheduleConfig) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null; // 新增：字体配置监听器

  aboutToAppear(): void {
    this.loadCourses();
    this.initConfig();
    this.loadCurrentWeek(); // 加载保存的周数
    
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
    
    // 新增：字体配置监听
    this.fontConfigListener = (config: FontConfig) => {
      this.fontConfig = config;
    };
    FontConfigUtil.getInstance().addListener(this.fontConfigListener);
    this.fontConfig = FontConfigUtil.getInstance().getFontConfig();
  }

  aboutToDisappear(): void {
    // 移除监听器，避免内存泄漏
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
    if (this.configListener) {
      ScheduleConfigUtil.getInstance().removeListener(this.configListener);
    }
    // 新增：移除字体配置监听器
    if (this.fontConfigListener) {
      FontConfigUtil.getInstance().removeListener(this.fontConfigListener);
    }
  }

  /**
   * 初始化课时配置
   */
  async initConfig(): Promise<void> {
    await ScheduleConfigUtil.getInstance().init();
    this.scheduleConfig = ScheduleConfigUtil.getInstance().getConfig();
    // 设置默认选中当天和第1节
    this.selectedDayOfWeek = this.selectedDay;
    this.selectedSection = 1;
    this.selectedEndSection = 1;
  }

  async loadCourses(): Promise<void> {
    this.courses = await PreferencesUtil.getInstance().getCourses();
  }

  /**
   * 加载保存的周数
   */
  async loadCurrentWeek(): Promise<void> {
    this.currentWeek = await PreferencesUtil.getInstance().getCurrentWeek();
    this.tempWeekInput = this.currentWeek.toString();
  }

  /**
   * 保存当前周数
   */
  async saveCurrentWeek(): Promise<void> {
    await PreferencesUtil.getInstance().saveCurrentWeek(this.currentWeek);
  }

  // 新增：获取缩放后的字体大小，用于全局字体配置生效
  getScaledFontSize(baseSize: number): number {
    return Math.round(baseSize * this.fontConfig.getFontScale());
  }

  // 新增：获取当前字体族，用于全局字体配置生效
  getFontFamily(): string {
    return this.fontConfig.getFontFamily();
  }

  getCoursesByDayAndSection(day: number, section: number): CourseModel[] {
    return this.courses.filter(c =>
      c.dayOfWeek === day &&
      c.startSection <= section &&
      c.endSection >= section
    );
  }

  /**
   * 获取节次选项列表
   */
  getSectionOptions(): SelectOption[] {
    const options: SelectOption[] = [];
    for (let i = 1; i <= this.scheduleConfig.totalSections; i++) {
      const time = ScheduleConfigUtil.getInstance().getSectionTime(i);
      if (time) {
        options.push({ value: `第${i}节 (${time})` });
      } else {
        options.push({ value: `第${i}节` });
      }
    }
    return options;
  }

  /**
   * 获取周几选项列表
   */
  getDayOfWeekOptions(): SelectOption[] {
    return this.weekDays.map((day: string) => ({ value: day } as SelectOption));
  }

  /**
   * 判断是否为平板设备
   */
  isTablet(): boolean {
    return ResponsiveUtil.isTablet(this.deviceWidth);
  }

  build() {
    // 新增：使用Stack包裹背景图和内容
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      // 页面主容器（绑定添加课程弹窗）
      Column() {
        this.buildTitleBar()

      // 周数显示区域容器（绑定周数修改弹窗）
      Column() {
        Row() {
          // 周数文本区域（点击弹出周数修改弹窗）
          Row() {
            Text('第')
              .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
              .fontColor(this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
            Text(`${this.currentWeek}`)
              .fontSize(this.getScaledFontSize(18)) // 修改：应用字体缩放
              .fontWeight(FontWeight.Bold)
              .fontColor(this.themeColors.primary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
            Text('周')
              .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
              .fontColor(this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
          }
          .onClick(() => {
            // 点击周数文本区域弹出周数修改弹窗
            // 修复：确保添加课程弹窗关闭后再打开周数弹窗
            if (!this.showAddDialog) {
              this.tempWeekInput = this.currentWeek.toString();
              this.showWeekDialog = true;
            }
          })

          Blank()

          // 左右箭头区域（保留原有功能）
          Row({ space: 8 }) {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(20)
              .fontColor([this.themeColors.text])
              .onClick(() => {
                // 左箭头：周数减1
                try {
                  if (this.currentWeek > 1) {
                    this.currentWeek--;
                    this.tempWeekInput = this.currentWeek.toString();
                    this.saveCurrentWeek();
                  }
                } catch (error) {
                  console.error('Failed to decrease week:', error);
                }
              })

            SymbolGlyph($r('sys.symbol.chevron_right'))
              .fontSize(20)
              .fontColor([this.themeColors.text])
              .onClick(() => {
                // 右箭头：周数加1
                try {
                  if (this.currentWeek < 30) {
                    this.currentWeek++;
                    this.tempWeekInput = this.currentWeek.toString();
                    this.saveCurrentWeek();
                  }
                } catch (error) {
                  console.error('Failed to increase week:', error);
                }
              })
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .backgroundColor(this.themeColors.surface)
      }
      // 修复：将周数弹窗绑定到周数区域容器，与添加课程弹窗分离
      .bindSheet($$this.showWeekDialog, this.weekDialog(), {
        height: 280,
        backgroundColor: this.themeColors.surface,
        dragBar: true,
        onDisappear: () => {
          // 弹窗关闭时的回调，确保状态清理
          this.showWeekDialog = false;
        }
      })

      Column() {
        this.buildCourseGrid()
      }
      .layoutWeight(1)

      // 添加课程按钮区域
      Row() {
        Button('添加课程')
          .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(() => {
            // 修复：点击添加课程按钮，确保周数弹窗关闭后再打开添加课程弹窗
            if (!this.showWeekDialog) {
              this.editingCourse = null;
              // 设置默认值为当前选中的日期和节次
              this.selectedDayOfWeek = this.selectedDay;
              this.selectedSection = 1;
              this.selectedEndSection = 1;
              this.showAddDialog = true;
            }
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    // 修复：将添加课程弹窗绑定到页面主容器
    .bindSheet($$this.showAddDialog, this.courseDialog(), {
      height: this.isTablet() ? 560 : 620, // 平板高度稍小
      backgroundColor: this.themeColors.surface,
      dragBar: true,
      onDisappear: () => {
        // 弹窗关闭时的回调，确保状态清理
        this.showAddDialog = false;
      }
    })
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      // 监听窗口尺寸变化，更新设备宽度
      this.deviceWidth = newValue.width as number;
    })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      Text('课程表')
        .fontSize(this.getScaledFontSize(20)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Blank()

      Text(DateTimeUtil.getFormattedDate())
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  @Builder
  buildCourseGrid(): void {
    Column() {
      Row() {
        Text('')
          .width(40)
          .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
          .fontColor(this.themeColors.textSecondary)
          .textAlign(TextAlign.Center)
          .fontFamily(this.getFontFamily()) // 新增：应用字体族

        ForEach(this.weekDays, (day: string, index: number) => {
          Column() {
            Text(day)
              .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
              .fontColor(this.selectedDay === index + 1 ? this.themeColors.primary : this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族

            if (this.selectedDay === index + 1) {
              Column()
                .width(4)
                .height(4)
                .borderRadius(2)
                .backgroundColor(this.themeColors.primary)
                .margin({ top: 4 })
            }
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .height(40)
      .backgroundColor(this.themeColors.surface)

      List({ space: 0 }) {
        ForEach(Array.from<number, number>({ length: this.scheduleConfig.totalSections }, (_, i: number): number => i + 1), 
          (section: number, sectionIndex: number) => {
          ListItem() {
            Row() {
              Text(`第${section}节`)
                .width(40)
                .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
                .fontColor(this.themeColors.textSecondary)
                .textAlign(TextAlign.Center)
                .fontFamily(this.getFontFamily()) // 新增：应用字体族

              ForEach([1, 2, 3, 4, 5, 6, 7], (day: number) => {
                Column() {
                  ForEach(this.getCoursesByDayAndSection(day, section), (course: CourseModel) => {
                    Column() {
                      Text(course.name)
                        .fontSize(this.getScaledFontSize(10)) // 修改：应用字体缩放
                        .fontColor(Color.White)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .fontFamily(this.getFontFamily()) // 新增：应用字体族

                      Text(course.location)
                        .fontSize(this.getScaledFontSize(8)) // 修改：应用字体缩放
                        .fontColor(Color.White)
                        .opacity(0.8)
                        .maxLines(1)
                        .fontFamily(this.getFontFamily()) // 新增：应用字体族
                    }
                    .width('100%')
                    .height('100%')
                    .padding(4)
                    .backgroundColor(course.color)
                    .borderRadius(4)
                    .justifyContent(FlexAlign.Center)
                    .onClick(() => {
                      this.editingCourse = course;
                      // 编辑时回填节次和周几
                      this.selectedDayOfWeek = course.dayOfWeek;
                      this.selectedSection = course.startSection;
                      this.selectedEndSection = course.endSection;
                      this.showAddDialog = true;
                    })
                  })
                }
                .layoutWeight(1)
                .height(50)
                .backgroundColor(day === this.selectedDay ? this.themeColors.surface : this.themeColors.background)
                .border({ width: 0.5, color: this.themeColors.divider })
              })
            }
            .width('100%')
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  courseDialog(): void {
    Column() {
      Text(this.editingCourse ? '编辑课程' : '添加课程')
        .fontSize(this.getScaledFontSize(18)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .margin({ top: 16, bottom: 24 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      // 根据设备类型决定布局方式：平板双列，手机单列
      if (this.isTablet()) {
        // 平板双列布局
        Row({ space: 16 }) {
          Column({ space: 16 }) {
            this.buildLeftColumn()
          }
          .layoutWeight(1)

          Column({ space: 16 }) {
            this.buildRightColumn()
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
      } else {
        // 手机单列布局
        Column({ space: 16 }) {
          this.buildLeftColumn()
          this.buildRightColumn()
        }
        .width('100%')
        .padding({ left: 24, right: 24 })
      }

      // 颜色选择（优化：使用Flex自动换行布局，确保所有颜色圆点在弹窗可视区域内）
      Column() {
        Text('颜色：')
          .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
          .fontColor(this.themeColors.textSecondary)
          .margin({ bottom: 8 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族

        // 使用Flex布局实现自动换行，适配手机/平板不同宽度
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          ForEach(COURSE_COLORS, (color: string) => {
            Column()
              .width(32)
              .height(32)
              .borderRadius(16)
              .backgroundColor(color)
              .border({
                width: this.editingCourse?.color === color ? 2 : 0,
                color: this.themeColors.primary
              })
              .margin({ right: 8, bottom: 8 })
              .onClick(() => {
                if (this.editingCourse) {
                  this.editingCourse.color = color;
                } else {
                  const newCourse = new CourseModel();
                  newCourse.color = color;
                  this.editingCourse = newCourse;
                }
              })
          })
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 24, right: 24 })
      .alignItems(HorizontalAlign.Start)

      Row({ space: 16 }) {
        if (this.editingCourse && this.editingCourse.id) {
          Button('删除')
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(Color.White)
            .backgroundColor('#E24A4A')
            .borderRadius(20)
            .onClick(async () => {
              if (this.editingCourse) {
                await PreferencesUtil.getInstance().deleteCourse(this.editingCourse.id);
                this.showAddDialog = false;
                this.editingCourse = null;
                this.loadCourses();
              }
            })
        }

        Button('保存')
          .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(async () => {
            if (this.editingCourse) {
              if (!this.editingCourse.id) {
                this.editingCourse.id = CourseModel.generateId();
              }
              // 使用选中的周几和节次
              this.editingCourse.dayOfWeek = this.selectedDayOfWeek;
              this.editingCourse.startSection = this.selectedSection;
              this.editingCourse.endSection = this.selectedEndSection;
              
              await PreferencesUtil.getInstance().saveCourse(this.editingCourse);
              this.showAddDialog = false;
              this.editingCourse = null;
              this.loadCourses();
            }
          })
      }
      .width('100%')
      .padding({ top: 24 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(16)
  }

  /**
   * 左列：周几和节次选择
   */
  @Builder
  buildLeftColumn(): void {
    // 周几选择
    Column() {
      Text('上课时间')
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .width('100%')
        .margin({ bottom: 8 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Select(this.getDayOfWeekOptions())
        .selected(this.selectedDayOfWeek - 1)
        .value(this.weekDays[this.selectedDayOfWeek - 1])
        .font({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .fontColor(this.themeColors.text)
        .selectedOptionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Medium } as Font) // 修改：应用字体缩放
        .optionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .onSelect((index: number) => {
          this.selectedDayOfWeek = index + 1;
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)

    // 开始节次选择
    Column() {
      Text('开始节次')
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .width('100%')
        .margin({ bottom: 8 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Select(this.getSectionOptions())
        .selected(this.selectedSection - 1)
        .value(this.getSectionOptions()[this.selectedSection - 1]?.value || '第1节')
        .font({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .fontColor(this.themeColors.text)
        .selectedOptionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Medium } as Font) // 修改：应用字体缩放
        .optionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .onSelect((index: number) => {
          this.selectedSection = index + 1;
          // 自动调整结束节次
          if (this.selectedEndSection < this.selectedSection) {
            this.selectedEndSection = this.selectedSection;
          }
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 8 })

    // 结束节次选择
    Column() {
      Text('结束节次')
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .width('100%')
        .margin({ bottom: 8 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Select(this.getSectionOptions())
        .selected(this.selectedEndSection - 1)
        .value(this.getSectionOptions()[this.selectedEndSection - 1]?.value || '第1节')
        .font({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .fontColor(this.themeColors.text)
        .selectedOptionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Medium } as Font) // 修改：应用字体缩放
        .optionFont({ size: this.getScaledFontSize(14), weight: FontWeight.Normal } as Font) // 修改：应用字体缩放
        .onSelect((index: number) => {
          const newEndSection = index + 1;
          // 确保结束节次不小于开始节次
          if (newEndSection >= this.selectedSection) {
            this.selectedEndSection = newEndSection;
          }
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 8 })
  }

  /**
   * 右列：课程基本信息
   */
  @Builder
  buildRightColumn(): void {
    TextInput({ placeholder: '课程名称', text: this.editingCourse?.name })
      .width('100%')
      .height(40)
      .backgroundColor(this.themeColors.background)
      .borderRadius(8)
      .fontColor(this.themeColors.text)
      .placeholderColor(this.themeColors.textSecondary)
      .onChange((value: string) => {
        if (this.editingCourse) {
          this.editingCourse.name = value;
        } else {
          const newCourse = new CourseModel();
          newCourse.name = value;
          this.editingCourse = newCourse;
        }
      })

    TextInput({ placeholder: '教师', text: this.editingCourse?.teacher })
      .width('100%')
      .height(40)
      .backgroundColor(this.themeColors.background)
      .borderRadius(8)
      .fontColor(this.themeColors.text)
      .placeholderColor(this.themeColors.textSecondary)
      .onChange((value: string) => {
        if (this.editingCourse) {
          this.editingCourse.teacher = value;
        }
      })

    TextInput({ placeholder: '地点', text: this.editingCourse?.location })
      .width('100%')
      .height(40)
      .backgroundColor(this.themeColors.background)
      .borderRadius(8)
      .fontColor(this.themeColors.text)
      .placeholderColor(this.themeColors.textSecondary)
      .onChange((value: string) => {
        if (this.editingCourse) {
          this.editingCourse.location = value;
        }
      })
  }

  /**
   * 周数调节弹窗
   */
  @Builder
  weekDialog(): void {
    Column() {
      Text('设置当前周数')
        .fontSize(this.getScaledFontSize(18)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .margin({ top: 16, bottom: 24 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      // 周数范围提示
      Text('周数范围：1 ~ 30')
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .margin({ bottom: 20 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      // 加减按钮和输入框
      Row({ space: 16 }) {
        // 减少按钮
        Button() {
          SymbolGlyph($r('sys.symbol.minus'))
            .fontSize(20)
            .fontColor([Color.White])
        }
        .width(48)
        .height(48)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(24)
        .onClick(() => {
          // 减少周数（增加异常捕获处理）
          try {
            const currentNum = parseInt(this.tempWeekInput) || 1;
            const newNum = Math.max(1, currentNum - 1);
            this.tempWeekInput = newNum.toString();
          } catch (error) {
            console.error('Failed to decrease week in dialog:', error);
          }
        })

        // 输入框
        TextInput({ text: this.tempWeekInput })
          .width(80)
          .height(48)
          .fontSize(this.getScaledFontSize(20)) // 修改：应用字体缩放
          .fontWeight(FontWeight.Bold)
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .textAlign(TextAlign.Center)
          .type(InputType.Number)
          .onChange((value: string) => {
            // 只允许输入数字（增加异常捕获处理）
            try {
              const num = parseInt(value);
              if (!isNaN(num) && num >= 1 && num <= 30) {
                this.tempWeekInput = value;
              } else if (value === '') {
                this.tempWeekInput = '1';
              }
            } catch (error) {
              console.error('Failed to parse week input:', error);
            }
          })

        // 增加按钮
        Button() {
          SymbolGlyph($r('sys.symbol.plus'))
            .fontSize(20)
            .fontColor([Color.White])
        }
        .width(48)
        .height(48)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(24)
        .onClick(() => {
          // 增加周数（增加异常捕获处理）
          try {
            const currentNum = parseInt(this.tempWeekInput) || 1;
            const newNum = Math.min(30, currentNum + 1);
            this.tempWeekInput = newNum.toString();
          } catch (error) {
            console.error('Failed to increase week in dialog:', error);
          }
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 24 })

      // 确认按钮
      Button('确认')
        .width('80%')
        .height(44)
        .fontSize(this.getScaledFontSize(16)) // 修改：应用字体缩放
        .fontColor(Color.White)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(22)
        .onClick(() => {
          // 确认修改周数（增加异常捕获处理）
          try {
            const newWeek = parseInt(this.tempWeekInput) || 1;
            this.currentWeek = Math.max(1, Math.min(30, newWeek));
            this.tempWeekInput = this.currentWeek.toString();
            this.saveCurrentWeek();
            this.showWeekDialog = false;
          } catch (error) {
            console.error('Failed to confirm week:', error);
          }
        })
    }
    .width('100%')
    .padding(16)
  }
}
