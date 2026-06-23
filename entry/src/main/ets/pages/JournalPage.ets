/**
 * 日志/历史日程页面（独立页面）
 * 功能：按日期展示所有有任务记录的日期条目，点击跳转到待办页面
 * 修改：改为日期列表模式，支持删除当日所有待办
 */
import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil';
import { BackgroundImage } from '../components/BackgroundImage';
import { TodoDataManager } from '../utils/TodoDataManager';
import router from '@ohos.router';

// 新增：日期条目数据结构
interface DateItem {
  date: string; // YYYY-MM-DD
  totalCount: number; // 总待办数
  completedCount: number; // 已完成数
  uncompletedCount: number; // 未完成数
}

// 新增：日期统计数据结构
interface DateStats {
  total: number;
  completed: number;
  uncompleted: number;
}

@Entry
@Component
struct JournalPage {
  @State dateItems: DateItem[] = []; // 新增：日期条目列表
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State isDarkMode: boolean = false;
  @State fontConfig: FontConfig = new FontConfig();
  @State showDeleteDialog: boolean = false; // 新增：删除确认弹窗
  @State deletingDate: string = ''; // 新增：待删除的日期
  private dataManager: TodoDataManager = TodoDataManager.getInstance();
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null;

  aboutToAppear(): void {
    this.loadDateItems();
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

  // 新增：加载所有有任务记录的日期条目
  async loadDateItems(): Promise<void> {
    try {
      const todos = await PreferencesUtil.getInstance().getTodos();
      
      // 按日期分组统计
      const dateMap = new Map<string, DateStats>();
      
      for (let i = 0; i < todos.length; i++) {
        const todo = todos[i];
        const dateStr = this.formatDate(new Date(todo.deadline));
        
        if (!dateMap.has(dateStr)) {
          const stats: DateStats = { total: 0, completed: 0, uncompleted: 0 };
          dateMap.set(dateStr, stats);
        }
        
        const stats = dateMap.get(dateStr)!;
        stats.total++;
        if (todo.isCompleted) {
          stats.completed++;
        } else {
          stats.uncompleted++;
        }
      }
      
      // 转换为数组并按日期降序排序
      const items: DateItem[] = [];
      dateMap.forEach((value, key) => {
        const item: DateItem = {
          date: key,
          totalCount: value.total,
          completedCount: value.completed,
          uncompletedCount: value.uncompleted
        };
        items.push(item);
      });
      
      // 按日期降序排序（最近的日期在前）
      items.sort((a, b) => {
        return b.date.localeCompare(a.date);
      });
      
      this.dateItems = items;
    } catch (error) {
      console.error('[JournalPage] 加载日期条目失败:', error);
      this.dateItems = [];
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
  getDateDesc(dateStr: string): string {
    return this.dataManager.getRelativeDateDesc(dateStr);
  }

  // 新增：跳转到待办页面并切换为指定日期
  async jumpToTodoPage(dateStr: string): Promise<void> {
    try {
      // 解析日期字符串
      const parts = dateStr.split('-');
      const year = parseInt(parts[0]);
      const month = parseInt(parts[1]) - 1; // 月份从0开始
      const day = parseInt(parts[2]);
      const timestamp = new Date(year, month, day).getTime();
      
      // 替换当前页面为Index页面，传递日期参数和tab索引
      await router.replaceUrl({
        url: 'pages/Index',
        params: {
          selectedDate: timestamp,
          tabIndex: 1 // 切换到待办tab
        }
      });
    } catch (error) {
      console.error('[JournalPage] 跳转失败:', error);
    }
  }

  // 新增：删除指定日期的所有待办
  async deleteDateTodos(): Promise<void> {
    try {
      const todos = await PreferencesUtil.getInstance().getTodos();
      
      // 过滤出非该日期的待办
      const remainingTodos = todos.filter(todo => {
        const todoDateStr = this.formatDate(new Date(todo.deadline));
        return todoDateStr !== this.deletingDate;
      });
      
      // 保存过滤后的待办列表
      await PreferencesUtil.getInstance().saveTodos(remainingTodos);
      
      // 重新加载日期条目
      await this.loadDateItems();
      
      // 关闭弹窗
      this.showDeleteDialog = false;
      this.deletingDate = '';
    } catch (error) {
      console.error('[JournalPage] 删除待办失败:', error);
    }
  }

  build() {
    Stack() {
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()
        
        // 日期列表区域
        if (this.dateItems.length > 0) {
          this.buildDateList()
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
    .bindSheet($$this.showDeleteDialog, this.buildDeleteConfirmDialog(), {
      height: 280,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      // 返回按钮
      SymbolGlyph($r('sys.symbol.chevron_left'))
        .fontSize(24)
        .fontColor([this.themeColors.text])
        .onClick(() => {
          router.back();
        })

      Text('日志/历史日程')
        .fontSize(this.getScaledFontSize(20))
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .fontFamily(this.getFontFamily())
        .margin({ left: 12 })

      Blank()

      Text(`${this.dateItems.length}个日期`)
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
  buildDateList(): void {
    List({ space: 12 }) {
      ForEach(this.dateItems, (item: DateItem) => {
        ListItem() {
          this.buildDateItem(item)
        }
      })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
  }

  @Builder
  buildDateItem(item: DateItem): void {
    Column() {
      Row() {
        // 日期信息
        Column() {
          Text(item.date)
            .fontSize(this.getScaledFontSize(18))
            .fontWeight(FontWeight.Medium)
            .fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily())
          
          Text(this.getDateDesc(item.date))
            .fontSize(this.getScaledFontSize(12))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 统计信息
        Column() {
          Row({ space: 8 }) {
            // 未完成数量
            if (item.uncompletedCount > 0) {
              Row({ space: 4 }) {
                SymbolGlyph($r('sys.symbol.circle'))
                  .fontSize(14)
                  .fontColor([this.themeColors.warning])
                
                Text(`${item.uncompletedCount}`)
                  .fontSize(this.getScaledFontSize(14))
                  .fontColor(this.themeColors.warning)
                  .fontFamily(this.getFontFamily())
              }
            }
            
            // 已完成数量
            if (item.completedCount > 0) {
              Row({ space: 4 }) {
                SymbolGlyph($r('sys.symbol.checkmark_circle'))
                  .fontSize(14)
                  .fontColor([this.themeColors.success])
                
                Text(`${item.completedCount}`)
                  .fontSize(this.getScaledFontSize(14))
                  .fontColor(this.themeColors.success)
                  .fontFamily(this.getFontFamily())
              }
            }
          }
        }
      }
      .width('100%')
      
      // 操作按钮行
      Row() {
        // 查看按钮
        Button('查看待办')
          .fontSize(this.getScaledFontSize(12))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(16)
          .height(32)
          .onClick(() => {
            this.jumpToTodoPage(item.date);
          })
        
        Blank()
        
        // 删除按钮
        Button('删除当日待办')
          .fontSize(this.getScaledFontSize(12))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.error)
          .borderRadius(16)
          .height(32)
          .onClick(() => {
            this.deletingDate = item.date;
            this.showDeleteDialog = true;
          })
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.themeColors.surface)
    .borderRadius(12)
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildEmptyState(): void {
    Column() {
      SymbolGlyph($r('sys.symbol.doc_text'))
        .fontSize(48)
        .fontColor([this.themeColors.textSecondary])

      Text('暂无任务记录')
        .fontSize(this.getScaledFontSize(16))
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily())
        .margin({ top: 16 })

      Text('请通过待办页面创建任务')
        .fontSize(this.getScaledFontSize(12))
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily())
        .margin({ top: 8 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  // 新增：删除确认弹窗
  @Builder
  buildDeleteConfirmDialog(): void {
    Column() {
      Text('确认删除')
        .fontSize(this.getScaledFontSize(18))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })
        .fontFamily(this.getFontFamily())

      Text(`确定要删除 ${this.deletingDate} 的所有待办吗？`)
        .fontSize(this.getScaledFontSize(14))
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily())
        .margin({ bottom: 8 })

      Text('此操作不可撤销')
        .fontSize(this.getScaledFontSize(12))
        .fontColor(this.themeColors.error)
        .fontFamily(this.getFontFamily())
        .margin({ bottom: 24 })

      Row({ space: 16 }) {
        Button('取消')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(20)
          .onClick(() => {
            this.showDeleteDialog = false;
            this.deletingDate = '';
          })

        Button('确认删除')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.error)
          .borderRadius(20)
          .onClick(() => {
            this.deleteDateTodos();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding(16)
  }
}
