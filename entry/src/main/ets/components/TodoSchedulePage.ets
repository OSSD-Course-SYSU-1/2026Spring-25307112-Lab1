import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil'; // 新增：字体配置
import { FontHelper } from '../utils/FontHelper'; // 新增：字体辅助工具
import { BackgroundImage } from './BackgroundImage'; // 新增：背景图组件
import { TodoDataManager } from '../utils/TodoDataManager'; // 新增：待办数据管理器
import router from '@ohos.router'; // 新增：路由跳转

// 新增：路由参数接口
interface RouteParams {
  selectedDate?: number;
  tabIndex?: number;
}

/**
 * 待办日程页面
 * 功能：任务管理、勾选完成、删除
 */
@Component
export struct TodoSchedulePage {
  @State todos: TodoModel[] = [];
  @State showAddDialog: boolean = false;
  @State editingTodo: TodoModel | null = null;
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State filterType: number = 0;
  @State isDarkMode: boolean = false;
  @State selectedDeadline: Date = new Date(Date.now() + 24 * 60 * 60 * 1000); // 默认明天
  @State fontConfig: FontConfig = new FontConfig(); // 新增：字体配置状态
  @State selectedDate: Date = new Date(); // 新增：当前选择的基准日期
  @State showDatePicker: boolean = false; // 新增：日期选择器显示状态
  private dataManager: TodoDataManager = TodoDataManager.getInstance(); // 新增：待办数据管理器实例
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null;

  aboutToAppear(): void {
    // 新增：检查是否有从日志页面传递的日期参数
    this.checkRouteParams();
    
    this.loadTodos();
    // 修复：保存监听器引用，以便在aboutToDisappear中移除
    this.themeListener = (isDark: boolean) => {
      this.isDarkMode = isDark;
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    // 新增：字体配置监听
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

  // 新增：检查路由参数
  async checkRouteParams(): Promise<void> {
    try {
      const params = router.getParams() as RouteParams;
      if (params && params.selectedDate) {
        const timestamp = params.selectedDate as number;
        this.selectedDate = new Date(timestamp);
      }
    } catch (error) {
      console.error('[TodoSchedulePage] 获取路由参数失败:', error);
    }
  }

  async loadTodos(): Promise<void> {
    this.todos = await PreferencesUtil.getInstance().getTodos();
  }

  // 新增：获取缩放后的字体大小，用于全局字体配置生效
  getScaledFontSize(baseSize: number): number {
    return Math.round(baseSize * this.fontConfig.getFontScale());
  }

  // 新增：获取当前字体族，用于全局字体配置生效
  getFontFamily(): string {
    return this.fontConfig.getFontFamily();
  }

  // 修改：根据选中日期和筛选类型过滤待办
  getFilteredTodos(): TodoModel[] {
    // 1. 先按日期过滤
    const selectedDateStr = this.formatDate(this.selectedDate);
    const todayStr = this.formatDate(new Date());
    
    let dateFilteredTodos: TodoModel[];
    
    if (selectedDateStr === todayStr) {
      // 今日：显示今日新增 + 昨日未完成继承的任务
      dateFilteredTodos = this.todos.filter(t => {
        const todoDateStr = this.formatDate(new Date(t.deadline));
        // 今日新增的任务（deadline为今日）
        if (todoDateStr === todayStr) {
          return true;
        }
        // 昨日未完成继承的任务（originalDate为昨日且未完成且deadline为今日）
        const yesterdayStr = this.formatDate(new Date(Date.now() - 24 * 60 * 60 * 1000));
        if (t.originalDate === yesterdayStr && !t.isCompleted && todoDateStr === todayStr) {
          return true;
        }
        return false;
      });
    } else {
      // 非今日：仅显示该日期的待办任务
      dateFilteredTodos = this.todos.filter(t => {
        const todoDateStr = this.formatDate(new Date(t.deadline));
        return todoDateStr === selectedDateStr;
      });
    }
    
    // 2. 再按完成状态筛选
    if (this.filterType === 0) {
      return dateFilteredTodos;
    } else if (this.filterType === 1) {
      return dateFilteredTodos.filter(t => !t.isCompleted);
    } else {
      return dateFilteredTodos.filter(t => t.isCompleted);
    }
  }

  // 新增：用于防止弹窗动效期间的重复点击（独立状态，避免事件互锁）
  private isAddDialogAnimating: boolean = false;
  private isDatePickerAnimating: boolean = false;

  build() {
    // 新增：使用Stack包裹背景图和内容
    // 修复：将bindSheet绑定到Stack上，避免与内部Column组件冲突
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()

        Column() {
          Row({ space: 16 }) {
            Text('全部')
              .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
              .fontColor(this.filterType === 0 ? this.themeColors.primary : this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
              .onClick(() => { this.filterType = 0; })

            Text('未完成')
              .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
              .fontColor(this.filterType === 1 ? this.themeColors.primary : this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
              .onClick(() => { this.filterType = 1; })

            Text('已完成')
              .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
              .fontColor(this.filterType === 2 ? this.themeColors.primary : this.themeColors.textSecondary)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
              .onClick(() => { this.filterType = 2; })
          }
          .width('100%')
          .padding(16)
          .justifyContent(FlexAlign.Center)

          List({ space: 8 }) {
            ForEach(this.getFilteredTodos(), (todo: TodoModel) => {
              ListItem() {
                this.buildTodoItem(todo)
              }
            })
          }
          .width('100%')
          .height('100%')
          .layoutWeight(1)
          .padding({ left: 16, right: 16 })
        }
        .layoutWeight(1)

        Row() {
          Button('添加待办')
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(Color.White)
            .backgroundColor(this.themeColors.primary)
            .borderRadius(20)
            .onClick(() => {
              // 修复：防止弹窗动效期间的重复点击（检查添加弹窗状态）
              if (this.isAddDialogAnimating) {
                return;
              }
              // 修复：协调检查，确保其他弹窗完全关闭后再打开（解决事件抢占问题）
              if (this.isDatePickerAnimating) {
                return;
              }
              // 修复：先设置弹窗内容依赖的状态，再触发弹窗显示
              this.editingTodo = null;
              // 修改：自动绑定当前选中日期为截止日期
              this.selectedDeadline = new Date(this.selectedDate.getTime());
              // 修复：直接设置状态，确保弹窗立即显示
              this.showAddDialog = true;
            })
        }
        .width('100%')
        .padding(16)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.themeColors.background)
      // 修复：将日期弹窗的bindSheet绑定在Column上，与添加弹窗分离，避免状态冲突
      .bindSheet($$this.showDatePicker, this.datePickerSheet(), {
        height: 400,
        backgroundColor: this.themeColors.surface,
        dragBar: true,
        // 新增：弹窗生命周期回调，用于管理动效状态（独立状态，避免事件互锁）
        onWillAppear: () => {
          this.isDatePickerAnimating = true;
        },
        onDisappear: () => {
          this.isDatePickerAnimating = false;
        }
      })
    }
    .width('100%')
    .height('100%')
    // 修复：将添加弹窗的bindSheet绑定在Stack上，与日期弹窗分离
    .bindSheet($$this.showAddDialog, this.todoDialog(), {
      height: 500,
      backgroundColor: this.themeColors.surface,
      dragBar: true,
      // 新增：弹窗生命周期回调，用于管理动效状态（独立状态，避免事件互锁）
      onWillAppear: () => {
        this.isAddDialogAnimating = true;
      },
      onAppear: () => {
        // 弹窗完全显示后，重置动效状态
      },
      onWillDisappear: () => {
        // 弹窗即将消失
      },
      onDisappear: () => {
        this.isAddDialogAnimating = false;
      }
    })
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      // 新增：日期选择控件（左上角）
      Row({ space: 8 }) {
        SymbolGlyph($r('sys.symbol.calendar'))
          .fontSize(20)
          .fontColor([this.themeColors.primary])
        
        Column() {
          Text(this.formatDate(this.selectedDate))
            .fontSize(this.getScaledFontSize(14))
            .fontColor(this.themeColors.text)
            .fontFamily(this.getFontFamily())
            .fontWeight(FontWeight.Medium)
          
          Text(this.getDateDesc(this.selectedDate))
            .fontSize(this.getScaledFontSize(10))
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily())
        }
        .alignItems(HorizontalAlign.Start)
      }
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .backgroundColor(this.themeColors.background)
      .borderRadius(8)
      .onClick(() => {
        // 修复：防止弹窗动效期间的重复点击（检查日期选择弹窗状态）
        if (this.isDatePickerAnimating) {
          return;
        }
        // 修复：协调检查，确保其他弹窗完全关闭后再打开（解决事件抢占问题）
        if (this.isAddDialogAnimating) {
          return;
        }
        // 修复：直接设置状态，确保弹窗立即显示
        this.showDatePicker = true;
      })

      Blank()

      // 新增：日志页面入口按钮
      Row({ space: 8 }) {
        SymbolGlyph($r('sys.symbol.doc_text'))
          .fontSize(20)
          .fontColor([this.themeColors.textSecondary])
          .onClick(() => {
            router.pushUrl({ url: 'pages/JournalPage' });
          })
      }

      // 修改：显示当前日期的待办数量
      Text(`${this.getFilteredTodos().filter(t => !t.isCompleted).length}项待办`)
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .fontFamily(this.getFontFamily()) // 新增：应用字体族
        .margin({ left: 12 })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  // 新增：格式化日期为YYYY-MM-DD
  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 新增：获取日期描述（今日、昨日、明日等）
  getDateDesc(date: Date): string {
    const today = new Date();
    const todayStr = this.formatDate(today);
    const dateStr = this.formatDate(date);
    
    if (dateStr === todayStr) {
      return '今日';
    }
    
    // 计算天数差
    const diffTime = date.getTime() - today.getTime();
    const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24));
    
    if (diffDays === 1) {
      return '明日';
    } else if (diffDays === -1) {
      return '昨日';
    } else if (diffDays > 1) {
      return `${diffDays}天后`;
    } else if (diffDays < -1) {
      return `${Math.abs(diffDays)}天前`;
    }
    
    return '';
  }

  @Builder
  buildTodoItem(todo: TodoModel): void {
    Row() {
      Checkbox({ name: `todo_${todo.id}`, group: 'todoGroup' })
        .select(todo.isCompleted)
        .selectedColor(this.themeColors.primary)
        .onChange(async (isChecked: boolean) => {
          // 新增：标记完成时设置完成日期
          if (isChecked) {
            await this.dataManager.markTodoAsCompleted(todo);
          } else {
            todo.isCompleted = false;
            todo.completedDate = '';
            await PreferencesUtil.getInstance().saveTodo(todo);
          }
          this.loadTodos();
        })

      Column() {
        // 新增：显示遗留任务标签
        if (todo.originalDate && todo.originalDate !== this.dataManager.getCurrentDate()) {
          Row() {
            SymbolGlyph($r('sys.symbol.clock'))
              .fontSize(12)
              .fontColor([this.themeColors.warning])
            
            Text(`${this.dataManager.getRelativeDateDesc(todo.originalDate)}遗留`)
              .fontSize(this.getScaledFontSize(10))
              .fontColor(this.themeColors.warning)
              .fontFamily(this.getFontFamily())
              .margin({ left: 4 })
          }
          .margin({ bottom: 4 })
        }
        
        Text(todo.title)
          .fontSize(this.getScaledFontSize(16)) // 修改：应用字体缩放
          .fontColor(todo.isCompleted ? this.themeColors.textSecondary : this.themeColors.text)
          .decoration({ type: todo.isCompleted ? TextDecorationType.LineThrough : TextDecorationType.None })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族

        if (todo.description) {
          Text(todo.description)
            .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
            .fontColor(this.themeColors.textSecondary)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }

        // 修改：显示截止日期，添加明确前缀
        Text(`截止日期：${DateTimeUtil.formatDateTime(todo.deadline)}`)
          .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
          .fontColor(todo.isOverdue() ? this.themeColors.error : this.themeColors.textSecondary)
          .margin({ top: 4 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 12 })

      Row({ space: 8 }) {
        SymbolGlyph($r('sys.symbol.square_and_pencil'))
          .fontSize(18)
          .fontColor([this.themeColors.textSecondary])
          .onClick(() => {
            // 修复：防止弹窗动效期间的重复点击（检查添加弹窗状态）
            if (this.isAddDialogAnimating) {
              return;
            }
            // 修复：协调检查，确保其他弹窗完全关闭后再打开（解决事件抢占问题）
            if (this.isDatePickerAnimating) {
              return;
            }
            this.editingTodo = todo;
            this.selectedDeadline = todo.deadline > 0 ? new Date(todo.deadline) : new Date(Date.now() + 24 * 60 * 60 * 1000);
            // 修复：直接设置状态，确保弹窗立即显示
            this.showAddDialog = true;
          })

        SymbolGlyph($r('sys.symbol.trash'))
          .fontSize(18)
          .fontColor([this.themeColors.error])
          .onClick(async () => {
            await PreferencesUtil.getInstance().deleteTodo(todo.id);
            this.loadTodos();
          })
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.themeColors.surface)
    .borderRadius(12)
  }

  @Builder
  todoDialog(): void {
    Column() {
      Text(this.editingTodo ? '编辑待办' : '添加待办')
        .fontSize(this.getScaledFontSize(18)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 24 })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Column({ space: 16 }) {
        TextInput({ placeholder: '标题', text: this.editingTodo?.title })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingTodo) {
              this.editingTodo.title = value;
            } else {
              const newTodo = new TodoModel();
              newTodo.title = value;
              this.editingTodo = newTodo;
            }
          })

        TextInput({ placeholder: '描述', text: this.editingTodo?.description })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingTodo) {
              this.editingTodo.description = value;
            } else if (this.editingTodo === null) {
              const newTodo = new TodoModel();
              newTodo.description = value;
              this.editingTodo = newTodo;
            }
          })

        // 截止日期选择
        Column({ space: 8 }) {
          Text('截止日期')
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(this.themeColors.textSecondary)
            .width('100%')
            .fontFamily(this.getFontFamily()) // 新增：应用字体族

          DatePicker({
            selected: this.selectedDeadline
          })
            .onChange((value: DatePickerResult) => {
              this.selectedDeadline = new Date(value.year!, value.month!, value.day!);
            })
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 24, right: 24 })

      Row({ space: 16 }) {
        Button('取消')
          .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(20)
          .onClick(() => {
            this.showAddDialog = false;
            this.editingTodo = null;
          })

        Button('保存')
          .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(async () => {
            if (this.editingTodo) {
              if (!this.editingTodo.id) {
                this.editingTodo.id = TodoModel.generateId();
                // 新增：创建新待办时设置原始日期为当前日期
                this.editingTodo = this.dataManager.initNewTodo(this.editingTodo);
              }
              // 将选择的日期转换为时间戳
              this.editingTodo.deadline = this.selectedDeadline.getTime();
              await PreferencesUtil.getInstance().saveTodo(this.editingTodo);
              this.showAddDialog = false;
              this.editingTodo = null;
              this.loadTodos();
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

  // 新增：日期选择器弹窗
  @Builder
  datePickerSheet(): void {
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
        Button('今天')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(this.themeColors.text)
          .backgroundColor(this.themeColors.background)
          .borderRadius(20)
          .onClick(() => {
            this.selectedDate = new Date();
            this.showDatePicker = false;
          })

        Button('确定')
          .fontSize(this.getScaledFontSize(14))
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(() => {
            this.showDatePicker = false;
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
