import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';

/**
 * 待办编辑对话框组件
 */
@Component
export struct TodoEditDialog {
  @Prop todo: TodoModel | null = null;
  // 表单数据
  @State title: string = '';
  @State description: string = '';
  @State deadline: number = Date.now() + 24 * 60 * 60 * 1000;
  @State priority: number = 2;
  @State isExam: boolean = false;
  @State examSubject: string = '';

  onSave?: (todo: TodoModel) => void;
  onDelete?: () => void;
  onCancel?: () => void;

  aboutToAppear(): void {
    if (this.todo) {
      this.title = this.todo.title;
      this.description = this.todo.description;
      this.deadline = this.todo.deadline > 0 ? this.todo.deadline : Date.now() + 24 * 60 * 60 * 1000;
      this.priority = this.todo.priority;
      this.isExam = this.todo.isExam;
      this.examSubject = this.todo.examSubject;
    }
  }

  build() {
    Column() {
      Text(this.todo ? '编辑' : '添加')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })

      Scroll() {
        Column({ space: 16 }) {
          // 类型切换
          Row() {
            Button('待办事项')
              .fontSize(14)
              .fontColor(!this.isExam ? Color.White : '#333333')
              .backgroundColor(!this.isExam ? '#4A90E2' : '#F0F0F0')
              .layoutWeight(1)
              .onClick(() => this.isExam = false)

            Button('考试安排')
              .fontSize(14)
              .fontColor(this.isExam ? Color.White : '#333333')
              .backgroundColor(this.isExam ? '#4A90E2' : '#F0F0F0')
              .layoutWeight(1)
              .onClick(() => this.isExam = true)
          }
          .width('100%')

          if (this.isExam) {
            Column({ space: 8 }) {
              Text('考试科目')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .width('100%')
              TextInput({ placeholder: '请输入考试科目', text: this.examSubject })
                .onChange((value: string) => this.examSubject = value)
                .width('100%')
            }
            .alignItems(HorizontalAlign.Start)
          }

          Column({ space: 8 }) {
            Text(this.isExam ? '考试说明' : '待办标题')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width('100%')
            TextInput({ placeholder: this.isExam ? '请输入考试说明' : '请输入待办标题', text: this.title })
              .onChange((value: string) => this.title = value)
              .width('100%')
          }
          .alignItems(HorizontalAlign.Start)

          Column({ space: 8 }) {
            Text('详细描述')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width('100%')
            TextArea({ placeholder: '请输入详细描述', text: this.description })
              .onChange((value: string) => this.description = value)
              .width('100%')
              .height(80)
          }
          .alignItems(HorizontalAlign.Start)

          Column({ space: 8 }) {
            Text(this.isExam ? '考试时间' : '截止时间')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .width('100%')
            Row() {
              Text(DateTimeUtil.formatDate(this.deadline, 'YYYY-MM-DD HH:mm'))
                .fontSize(14)
                .layoutWeight(1)
              Button('选择时间')
                .fontSize(12)
                .onClick(() => {
                  this.deadline = Date.now() + 24 * 60 * 60 * 1000;
                })
            }
            .width('100%')
          }
          .alignItems(HorizontalAlign.Start)

          if (!this.isExam) {
            Column({ space: 8 }) {
              Text('优先级')
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .width('100%')
              Row() {
                ForEach(['低', '中', '高'], (label: string, index: number) => {
                  Button(label)
                    .fontSize(12)
                    .fontColor(this.priority === index + 1 ? Color.White : '#333333')
                    .backgroundColor(this.priority === index + 1 ? '#4A90E2' : '#F0F0F0')
                    .layoutWeight(1)
                    .onClick(() => this.priority = index + 1)
                })
              }
              .width('100%')
            }
            .alignItems(HorizontalAlign.Start)
          }
        }
        .padding(16)
      }
      .layoutWeight(1)

      Row({ space: 16 }) {
        if (this.todo && this.todo.id) {
          Button('删除')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#F56C6C')
            .layoutWeight(1)
            .onClick(() => {
              if (this.onDelete) this.onDelete();
            })
        }

        Button('取消')
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F0F0F0')
          .layoutWeight(1)
          .onClick(() => {
            if (this.onCancel) this.onCancel();
          })

        Button('保存')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#4A90E2')
          .layoutWeight(1)
          .onClick(() => {
            if (!this.title.trim() && !this.examSubject.trim()) {
              return;
            }
            const newTodo = new TodoModel({
              id: this.todo && this.todo.id ? this.todo.id : TodoModel.generateId(),
              title: this.title || this.examSubject,
              description: this.description,
              deadline: this.deadline,
              priority: this.priority,
              isExam: this.isExam,
              examSubject: this.examSubject,
              isCompleted: this.todo ? this.todo.isCompleted : false,
              createTime: this.todo ? this.todo.createTime : Date.now()
            });
            if (this.onSave) this.onSave(newTodo);
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }
}
