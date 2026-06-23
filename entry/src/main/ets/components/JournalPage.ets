/**
 * 日志/历史日程页面
 * 功能：查看和管理每日日志、归档的已完成待办
 */
import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { JournalModel, TodoItem, JournalInit } from '../model/JournalModel';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil';
import { FontHelper } from '../utils/FontHelper';
import { BackgroundImage } from './BackgroundImage';
import { TodoDataManager } from '../utils/TodoDataManager';

@Component
export struct JournalPage {
  @State journals: JournalModel[] = [];
  @State selectedDate: Date = new Date();
  @State currentJournal: JournalModel | null = null;
  @State showEditDialog: boolean = false;
  @State editingContent: string = '';
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State isDarkMode: boolean = false;
  @State fontConfig: FontConfig = new FontConfig();
  @State dateExists: boolean = false;
  @State showDatePicker: boolean = false;
  private dataManager: TodoDataManager = TodoDataManager.getInstance();
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null;

  aboutToAppear(): void {
    this.loadJournals();
    // 修复：保存监听器引用，以便在aboutToDisappear中移除
    this.themeListener = (isDark: boolean) => {
      this.isDarkMode = isDark;
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    this.fontConfigListener = (config: FontConfig) => {
      this.fontConfig = config;
    };
    FontConfigUtil.getInstance().addListener(this.fontConfigListener);
    this.fontConfig = FontConfigUtil.getInstance().getFontConfig();
    // 初始化时检查当前日期的日志
    this.checkCurrentDate();
  }

  // 新增：组件销毁时移除监听器，防止内存泄漏
  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
    if (this.fontConfigListener) {
      FontConfigUtil.getInstance().removeListener(this.fontConfigListener);
    }
  }

  async loadJournals(): Promise<void> {
    this.journals = await PreferencesUtil.getInstance().getJournals();
    this.checkCurrentDate();
  }

  // 检查当前选中日期是否存在日志
  async checkCurrentDate(): Promise<void> {
    const dateStr = this.formatDate(this.selectedDate);
    this.dateExists = await PreferencesUtil.getInstance().hasJournalForDate(dateStr);
    if (this.dateExists) {
      this.currentJournal = await PreferencesUtil.getInstance().getJournalByDate(dateStr);
    } else {
      this.currentJournal = null;
    }
  }

  // 格式化日期为YYYY-MM-DD
  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 获取缩放后的字体大小
  getScaledFontSize(baseSize: number): number {
    return Math.round(baseSize * this.fontConfig.getFontScale());
  }

  // 获取当前字体族
  getFontFamily(): string {
    return this.fontConfig.getFontFamily();
  }

  // 获取相对日期描述
  getDateDesc(date: Date): string {
    const dateStr = this.formatDate(date);
    return this.dataManager.getRelativeDateDesc(dateStr);
  }

  build() {
    Stack() {
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()
        
        // 日期选择区域
        this.buildDateSelector()
        
        // 日志内容区域
        if (this.currentJournal) {
          this.buildJournalContent()
        } else {
          this.buildEmptyState()
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.themeColors.background)
    }
    .width('100%')
    .height('100%')
    .bindSheet($$this.showDatePicker, this.buildDatePickerSheet(), {
      height: 400,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
    .bindSheet($$this.showEditDialog, this.buildEditDialog(), {
      height: 500,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      Text('日志/历史日程')
        .fontSize(this.getScaledFontSize(20))
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .fontFamily(this.getFontFamily())

      Blank()

      Text(`${this.journals.length}条记录`)
        .fontSize(this.getScaledFontSize(14))
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily())
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  @Builder
  buildDateSelector(): void {
    Column() {
      Row() {
        // 日期显示
        Column() {
          Text(this.formatDate(this.selectedDate))
            .fontSize(this.getScaledFontSize(18))
            .fontWeight(FontWeight.Medium)
            .fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily())
          
          Text(this.getDateDesc(this.selectedDate))
            .fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 选择日期按钮
        Button('选择日期')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(() => {
            this.showDatePicker = true;
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.themeColors.surface)
      .borderRadius(12)
      .margin({ top: 16, left: 16, right: 16 })

      // 日期状态提示
      if (this.dateExists) {
        Text('该日期已有日志记录')
          .fontSize(this.getScaledFontSize(12))
          .fontColor(this.themeColors.success)
          .fontFamily(this.getFontFamily())
          .margin({ top: 8 })
      }
    }
    .width('100%')
  }

  @Builder
  buildJournalContent(): void {
    Column() {
      // 日志内容卡片
      if (this.currentJournal!.content) {
        Column() {
          Row() {
            Text('日志内容')
              .fontSize(this.getScaledFontSize(16))
              .fontWeight(FontWeight.Medium)
              .fontColor(this.themeColors.text)
              .fontFamily(this.getFontFamily())

            Blank()

            SymbolGlyph($r('sys.symbol.square_and_pencil'))
              .fontSize(18)
              .fontColor([this.themeColors.textSecondary])
              .onClick(() => {
                this.editingContent = this.currentJournal!.content;
                this.showEditDialog = true;
              })
          }
          .width('100%')
          .margin({ bottom: 12 })

          Text(this.currentJournal!.content)
            .fontSize(this.getScaledFontSize(14))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
            .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.themeColors.surface)
        .borderRadius(12)
        .margin({ top: 16, left: 16, right: 16 })
        .alignItems(HorizontalAlign.Start)
      }

      // 已归档的待办列表
      if (this.currentJournal!.completedTodos.length > 0) {
        Column() {
          Text(`已完成待办 (${this.currentJournal!.completedTodos.length}项)`)
            .fontSize(this.getScaledFontSize(16))
            .fontWeight(FontWeight.Medium)
            .fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily())
            .width('100%')
            .margin({ bottom: 12 })

          ForEach(this.currentJournal!.completedTodos, (todo: TodoItem, index: number) => {
            this.buildCompletedTodoItem(todo)
          })
        }
        .width('100%')
        .padding(16)
        .backgroundColor(this.themeColors.surface)
        .borderRadius(12)
        .margin({ top: 16, left: 16, right: 16 })
        .alignItems(HorizontalAlign.Start)
      }

      // 删除日志按钮
      Row() {
        Button('删除此日志')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.error)
          .borderRadius(20)
          .onClick(async () => {
            await PreferencesUtil.getInstance().deleteJournal(this.currentJournal!.id);
            this.currentJournal = null;
            this.dateExists = false;
            this.loadJournals();
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  buildCompletedTodoItem(todo: TodoItem): void {
    Row() {
      SymbolGlyph($r('sys.symbol.checkmark_circle'))
        .fontSize(20)
        .fontColor([this.themeColors.success])

      Column() {
        Text(todo.title)
          .fontSize(this.getScaledFontSize(14))
          .fontColor(this.themeColors.text)
          .fontFamily(this.getFontFamily())

        if (todo.description) {
          Text(todo.description)
            .fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }

        // 显示原始日期
        if (todo.originalDate) {
          Text(`来自: ${todo.originalDate}`)
            .fontSize(this.getScaledFontSize(10))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
            .margin({ top: 4 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
  }

  @Builder
  buildEmptyState(): void {
    Column() {
      SymbolGlyph($r('sys.symbol.doc_text'))
        .fontSize(48)
        .fontColor([this.themeColors.textSecondary])

      Text('该日期暂无日志记录')
        .fontSize(this.getScaledFontSize(16))
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily())
        .margin({ top: 16 })

      Button('创建日志')
        .fontSize(this.getScaledFontSize(14))
        .fontColor(Color.White)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(20)
        .margin({ top: 16 })
        .onClick(() => {
          this.editingContent = '';
          this.showEditDialog = true;
        })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildDatePickerSheet(): void {
    Column() {
      Text('选择日期')
        .fontSize(this.getScaledFontSize(18))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 24 })
        .fontFamily(this.getFontFamily())

      DatePicker({
        selected: this.selectedDate
      })
        .onChange((value: DatePickerResult) => {
          this.selectedDate = new Date(value.year!, value.month!, value.day!);
        })

      Row({ space: 16 }) {
        Button('取消')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(20)
          .onClick(() => {
            this.showDatePicker = false;
          })

        Button('确定')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(async () => {
            this.showDatePicker = false;
            await this.checkCurrentDate();
          })
      }
      .width('100%')
      .padding({ top: 24 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(16)
  }

  @Builder
  buildEditDialog(): void {
    Column() {
      Text(this.currentJournal ? '编辑日志' : '创建日志')
        .fontSize(this.getScaledFontSize(18))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 24 })
        .fontFamily(this.getFontFamily())

      TextArea({ placeholder: '记录今天的内容...', text: this.editingContent })
        .width('100%')
        .height(200)
        .backgroundColor(this.themeColors.background)
        .borderRadius(8)
        .onChange((value: string) => {
          this.editingContent = value;
        })

      Row({ space: 16 }) {
        Button('取消')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(20)
          .onClick(() => {
            this.showEditDialog = false;
            this.editingContent = '';
          })

        Button('保存')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(async () => {
            const dateStr = this.formatDate(this.selectedDate);
            
            if (this.currentJournal) {
              // 更新现有日志
              this.currentJournal.content = this.editingContent;
              this.currentJournal.updateTime = new Date().getTime();
              await PreferencesUtil.getInstance().saveJournal(this.currentJournal);
            } else {
              // 创建新日志
              const journalData: JournalInit = {
                id: JournalModel.generateId(),
                date: dateStr,
                content: this.editingContent,
                completedTodos: [] as TodoItem[],
                createTime: new Date().getTime(),
                updateTime: new Date().getTime()
              };
              const newJournal = new JournalModel(journalData);
              await PreferencesUtil.getInstance().saveJournal(newJournal);
              this.currentJournal = newJournal;
              this.dateExists = true;
            }
            
            this.showEditDialog = false;
            this.editingContent = '';
            this.loadJournals();
          })
      }
      .width('100%')
      .padding({ top: 24 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(16)
  }
}
