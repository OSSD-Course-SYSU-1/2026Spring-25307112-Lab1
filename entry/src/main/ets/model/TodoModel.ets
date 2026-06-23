/**
 * 待办任务数据模型
 * 新增字段：originalDate（原始所属日期）、completedDate（完成日期）
 * 用于支持跨天任务继承和归档功能
 */
export class TodoModel {
  id: string = '';
  title: string = '';
  description: string = '';
  deadline: number = 0;
  isCompleted: boolean = false;
  createTime: number = 0;
  priority: number = 2;
  type: number = 1;
  isExam: boolean = false;
  examSubject: string = '';
  // 新增：原始所属日期（YYYY-MM-DD格式），用于标识跨天继承的任务来源
  originalDate: string = '';
  // 新增：完成日期（YYYY-MM-DD格式），用于归档到对应日期的日志
  completedDate: string = '';

  constructor(init?: Partial<TodoModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.title = init.title ?? '';
      this.description = init.description ?? '';
      this.deadline = init.deadline ?? 0;
      this.isCompleted = init.isCompleted ?? false;
      this.createTime = init.createTime ?? new Date().getTime();
      this.priority = init.priority ?? 2;
      this.type = init.type ?? 1;
      this.isExam = init.isExam ?? false;
      this.examSubject = init.examSubject ?? '';
      // 新增字段初始化
      this.originalDate = init.originalDate ?? '';
      this.completedDate = init.completedDate ?? '';
    }
  }

  static generateId(): string {
    return `todo_${new Date().getTime()}`;
  }

  getRemainingTime(): number {
    return this.deadline - new Date().getTime();
  }

  isOverdue(): boolean {
    return !this.isCompleted && new Date().getTime() > this.deadline;
  }
}
