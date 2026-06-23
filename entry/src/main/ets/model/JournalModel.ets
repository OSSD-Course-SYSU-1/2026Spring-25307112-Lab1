/**
 * 日志/历史日程数据模型
 * 用于存储每日日志和归档的已完成待办
 */

/**
 * 日志初始化参数接口
 */
export interface JournalInit {
  id: string;
  date: string;
  content: string;
  completedTodos: TodoItem[];
  createTime: number;
  updateTime: number;
}

export class JournalModel {
  id: string = '';
  // 日志日期（YYYY-MM-DD格式），唯一标识
  date: string = '';
  // 日志内容
  content: string = '';
  // 归档的已完成待办列表
  completedTodos: TodoItem[] = [];
  // 创建时间戳
  createTime: number = 0;
  // 更新时间戳
  updateTime: number = 0;

  constructor(init?: JournalInit) {
    if (init) {
      this.id = init.id ?? '';
      this.date = init.date ?? '';
      this.content = init.content ?? '';
      this.completedTodos = init.completedTodos ?? [];
      this.createTime = init.createTime ?? new Date().getTime();
      this.updateTime = init.updateTime ?? new Date().getTime();
    }
  }

  /**
   * 生成唯一ID
   */
  static generateId(): string {
    return `journal_${new Date().getTime()}`;
  }
}

/**
 * 日志中的待办项简化模型
 * 用于存储在日志中的已完成待办信息
 */
export interface TodoItem {
  id: string;
  title: string;
  description: string;
  completedTime: number;
  originalDate: string;
}
