import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CourseModel } from '../model/CourseModel';
import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';

/**
 * 服务卡片页面
 * 功能：展示当日课表和待办
 */
@Entry
@Component
struct WidgetPage {
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State todayCourses: CourseModel[] = [];
  @State pendingTodos: TodoModel[] = [];
  @State formId: string = '';

  aboutToAppear(): void {
    this.loadData();
  }

  async loadData(): Promise<void> {
    const courses = await PreferencesUtil.getInstance().getCourses();
    const todos = await PreferencesUtil.getInstance().getTodos();
    const today = DateTimeUtil.getCurrentDayOfWeek();
    this.todayCourses = courses.filter(c => c.dayOfWeek === today).slice(0, 3);
    this.pendingTodos = todos.filter(t => !t.isCompleted).slice(0, 3);
  }

  build() {
    Column() {
      Row() {
        Text('校园助手')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.themeColors.text)

        Blank()

        Text(DateTimeUtil.getFormattedDate().split(' ')[0])
          .fontSize(12)
          .fontColor(this.themeColors.textSecondary)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })

      Column({ space: 8 }) {
        Text('今日课程')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text)
          .width('100%')

        if (this.todayCourses.length > 0) {
          ForEach(this.todayCourses, (course: CourseModel) => {
            Row() {
              Column()
                .width(4)
                .height(40)
                .backgroundColor(course.color)
                .borderRadius(2)

              Column() {
                Text(course.name)
                  .fontSize(14)
                  .fontColor(this.themeColors.text)

                Text(`${course.location} | 第${course.startSection}-${course.endSection}节`)
                  .fontSize(12)
                  .fontColor(this.themeColors.textSecondary)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 8 })
              .layoutWeight(1)
            }
            .width('100%')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor(this.themeColors.surface)
            .borderRadius(8)
          })
        } else {
          Text('今日无课程安排')
            .fontSize(12)
            .fontColor(this.themeColors.textSecondary)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(8)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8 })

      Column({ space: 8 }) {
        Text('待办事项')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.text)
          .width('100%')

        if (this.pendingTodos.length > 0) {
          ForEach(this.pendingTodos, (todo: TodoModel) => {
            Row() {
              SymbolGlyph($r('sys.symbol.circle'))
                .fontSize(16)
                .fontColor([this.themeColors.textSecondary])

              Text(todo.title)
                .fontSize(14)
                .fontColor(this.themeColors.text)
                .margin({ left: 8 })
                .layoutWeight(1)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .backgroundColor(this.themeColors.surface)
            .borderRadius(8)
          })
        } else {
          Text('暂无待办事项')
            .fontSize(12)
            .fontColor(this.themeColors.textSecondary)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(8)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    .borderRadius(16)
  }
}
