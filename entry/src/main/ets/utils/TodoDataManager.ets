/**
 * 待办数据管理器
 * 负责每日自动流转逻辑：已完成归档、未完成继承
 */
import { TodoModel } from '../model/TodoModel';
import { JournalModel, TodoItem } from '../model/JournalModel';
import { PreferencesUtil } from './PreferencesUtil';

/**
 * 日期分组数据类
 * 用于按日期分组待办项
 */
class DateGroup {
  date: string = '';
  todos: TodoModel[] = [];
}

export class TodoDataManager {
  private static instance: TodoDataManager;
  // 上次检查日期（YYYY-MM-DD格式）
  private lastCheckDate: string = '';
  // 当前日期（YYYY-MM-DD格式）
  private currentDate: string = '';

  private constructor() {}

  static getInstance(): TodoDataManager {
    if (!TodoDataManager.instance) {
      TodoDataManager.instance = new TodoDataManager();
    }
    return TodoDataManager.instance;
  }

  /**
   * 获取当前日期（YYYY-MM-DD格式）
   */
  getCurrentDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * 获取昨天的日期（YYYY-MM-DD格式）
   */
  getYesterdayDate(): string {
    const now = new Date();
    now.setDate(now.getDate() - 1);
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * 获取相对日期描述（如：昨日、2天前等）
   */
  getRelativeDateDesc(date: string): string {
    // 修复：添加日期有效性验证
    if (!date || typeof date !== 'string' || date.trim() === '') {
      return '未知';
    }
    
    const current = this.getCurrentDate();
    if (date === current) {
      return '今日';
    }
    
    const yesterday = this.getYesterdayDate();
    if (date === yesterday) {
      return '昨日';
    }
    
    // 计算天数差
    const dateObj = new Date(date);
    // 修复：检查日期对象是否有效
    if (isNaN(dateObj.getTime())) {
      return '未知';
    }
    const currentObj = new Date(current);
    const diffDays = Math.floor((currentObj.getTime() - dateObj.getTime()) / (1000 * 60 * 60 * 24));
    
    if (diffDays > 0) {
      return `${diffDays}天前`;
    } else {
      return '未来';
    }
  }

  /**
   * 执行每日流转检查
   * 在应用启动时调用，检测日期变化并执行流转逻辑
   */
  async performDailyTransition(): Promise<void> {
    try {
      this.currentDate = this.getCurrentDate();
      
      // 获取上次检查日期
      this.lastCheckDate = await this.getLastCheckDate();
      
      // 如果日期未变化，不执行流转
      if (this.lastCheckDate === this.currentDate) {
        console.info('[TodoDataManager] 日期未变化，跳过流转');
        return;
      }
      
      console.info(`[TodoDataManager] 检测到日期变化：${this.lastCheckDate} -> ${this.currentDate}`);
      
      // 执行流转逻辑
      await this.executeTransition();
      
      // 更新最后检查日期
      await this.saveLastCheckDate(this.currentDate);
      
    } catch (error) {
      console.error('[TodoDataManager] 每日流转执行失败:', error);
    }
  }

  /**
   * 执行流转逻辑
   * 1. 归档已完成的待办到对应日期的日志
   * 2. 继承未完成的待办到新的一天
   */
  private async executeTransition(): Promise<void> {
    // 获取所有待办
    const todos = await PreferencesUtil.getInstance().getTodos();
    
    // 分类：已完成和未完成
    const completedTodos: TodoModel[] = [];
    const uncompletedTodos: TodoModel[] = [];
    
    for (let i = 0; i < todos.length; i++) {
      if (todos[i].isCompleted) {
        completedTodos.push(todos[i]);
      } else {
        uncompletedTodos.push(todos[i]);
      }
    }
    
    // 1. 归档已完成的待办
    if (completedTodos.length > 0) {
      await this.archiveCompletedTodos(completedTodos);
    }
    
    // 2. 继承未完成的待办（标记原始日期）
    if (uncompletedTodos.length > 0) {
      await this.inheritUncompletedTodos(uncompletedTodos);
    }
    
    console.info(`[TodoDataManager] 流转完成：归档${completedTodos.length}项，继承${uncompletedTodos.length}项`);
  }

  /**
   * 归档已完成的待办到对应日期的日志
   */
  private async archiveCompletedTodos(completedTodos: TodoModel[]): Promise<void> {
    // 按完成日期分组
    const dateGroups: DateGroup[] = [];
    
    for (let i = 0; i < completedTodos.length; i++) {
      const todo = completedTodos[i];
      // 使用completedDate或lastCheckDate作为归档日期
      const archiveDate = todo.completedDate || this.lastCheckDate || this.getYesterdayDate();
      
      // 查找是否已有该日期的分组
      let foundGroup: DateGroup | null = null;
      for (let j = 0; j < dateGroups.length; j++) {
        if (dateGroups[j].date === archiveDate) {
          foundGroup = dateGroups[j];
          break;
        }
      }
      
      if (foundGroup) {
        foundGroup.todos.push(todo);
      } else {
        const newGroup = new DateGroup();
        newGroup.date = archiveDate;
        newGroup.todos = [todo];
        dateGroups.push(newGroup);
      }
    }
    
    // 为每个日期创建或更新日志
    for (let i = 0; i < dateGroups.length; i++) {
      await this.addTodosToJournal(dateGroups[i].date, dateGroups[i].todos);
    }
    
    // 从待办列表中删除已归档的待办
    for (let i = 0; i < completedTodos.length; i++) {
      await PreferencesUtil.getInstance().deleteTodo(completedTodos[i].id);
    }
  }

  /**
   * 将待办添加到指定日期的日志
   */
  private async addTodosToJournal(date: string, todos: TodoModel[]): Promise<void> {
    // 获取或创建该日期的日志
    let journal = await PreferencesUtil.getInstance().getJournalByDate(date);
    
    if (!journal) {
      // 使用显式类型创建日志
      journal = new JournalModel();
      journal.id = JournalModel.generateId();
      journal.date = date;
      journal.content = '';
      journal.completedTodos = [];
      journal.createTime = new Date().getTime();
      journal.updateTime = new Date().getTime();
    }
    
    // 转换待办为日志项
    const todoItems: TodoItem[] = [];
    for (let i = 0; i < todos.length; i++) {
      const todo = todos[i];
      const item: TodoItem = {
        id: todo.id,
        title: todo.title,
        description: todo.description,
        completedTime: new Date().getTime(),
        originalDate: todo.originalDate || date
      };
      todoItems.push(item);
    }
    
    // 添加到日志（不使用展开运算符）
    const newCompletedTodos: TodoItem[] = [];
    for (let i = 0; i < journal.completedTodos.length; i++) {
      newCompletedTodos.push(journal.completedTodos[i]);
    }
    for (let i = 0; i < todoItems.length; i++) {
      newCompletedTodos.push(todoItems[i]);
    }
    
    journal.completedTodos = newCompletedTodos;
    journal.updateTime = new Date().getTime();
    
    // 保存日志
    await PreferencesUtil.getInstance().saveJournal(journal);
  }

  /**
   * 继承未完成的待办到新的一天
   * 为未标记原始日期的待办添加原始日期标记
   */
  private async inheritUncompletedTodos(uncompletedTodos: TodoModel[]): Promise<void> {
    for (let i = 0; i < uncompletedTodos.length; i++) {
      const todo = uncompletedTodos[i];
      // 如果没有原始日期，设置为上次检查日期或昨天
      if (!todo.originalDate) {
        todo.originalDate = this.lastCheckDate || this.getYesterdayDate();
        await PreferencesUtil.getInstance().saveTodo(todo);
      }
    }
  }

  /**
   * 获取上次检查日期
   */
  private async getLastCheckDate(): Promise<string> {
    try {
      const date = await PreferencesUtil.getInstance().getLastCheckDate();
      return date || '';
    } catch (error) {
      console.error('[TodoDataManager] 获取上次检查日期失败:', error);
      return '';
    }
  }

  /**
   * 保存最后检查日期
   */
  private async saveLastCheckDate(date: string): Promise<void> {
    try {
      await PreferencesUtil.getInstance().saveLastCheckDate(date);
    } catch (error) {
      console.error('[TodoDataManager] 保存最后检查日期失败:', error);
    }
  }

  /**
   * 初始化新待办（设置当前日期为原始日期）
   */
  initNewTodo(todo: TodoModel): TodoModel {
    todo.originalDate = this.getCurrentDate();
    return todo;
  }

  /**
   * 标记待办为已完成（设置完成日期）
   */
  async markTodoAsCompleted(todo: TodoModel): Promise<void> {
    todo.isCompleted = true;
    todo.completedDate = this.getCurrentDate();
    await PreferencesUtil.getInstance().saveTodo(todo);
  }
}
