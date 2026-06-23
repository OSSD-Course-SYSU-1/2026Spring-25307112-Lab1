import common from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import { CourseModel } from '../model/CourseModel';
import { TodoModel } from '../model/TodoModel';
import { LostFoundModel, RepairModel } from '../model/ServiceModel';
import { ScheduleConfig } from '../model/ScheduleConfigModel';
import { FontConfig, FontSize, FontStyle } from './FontConfigUtil'; // 新增：导入字体配置类
import { JournalModel, JournalInit } from '../model/JournalModel'; // 新增：导入日志模型

/**
 * Preferences工具类
 * 用于本地数据持久化存储
 */
export class PreferencesUtil {
  private static instance: PreferencesUtil;
  private preferences: preferences.Preferences | null = null;
  private context: common.UIAbilityContext | null = null;

  private constructor() {}

  static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  async init(context: common.UIAbilityContext): Promise<void> {
    this.context = context;
    try {
      this.preferences = await preferences.getPreferences(context, 'campus_helper_db');
    } catch (err) {
      console.error('PreferencesUtil init failed:', err);
    }
  }

  // 课程相关操作
  async getCourses(): Promise<CourseModel[]> {
    if (!this.preferences) return [];
    try {
      const data = await this.preferences.get('courses', '[]');
      const jsonStr = data as string;
      const arr = JSON.parse(jsonStr) as object[];
      return arr.map((item: object) => new CourseModel(item as Partial<CourseModel>));
    } catch (err) {
      console.error('getCourses failed:', err);
      return [];
    }
  }

  async saveCourse(course: CourseModel): Promise<void> {
    if (!this.preferences) return;
    const courses = await this.getCourses();
    const index = courses.findIndex(c => c.id === course.id);
    if (index >= 0) {
      courses[index] = course;
    } else {
      courses.push(course);
    }
    await this.preferences.put('courses', JSON.stringify(courses));
    await this.preferences.flush();
  }

  async deleteCourse(id: string): Promise<void> {
    if (!this.preferences) return;
    const courses = await this.getCourses();
    const filtered = courses.filter(c => c.id !== id);
    await this.preferences.put('courses', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  // 待办相关操作
  async getTodos(): Promise<TodoModel[]> {
    if (!this.preferences) return [];
    try {
      const data = await this.preferences.get('todos', '[]');
      const jsonStr = data as string;
      const arr = JSON.parse(jsonStr) as object[];
      return arr.map((item: object) => new TodoModel(item as Partial<TodoModel>));
    } catch (err) {
      console.error('getTodos failed:', err);
      return [];
    }
  }

  async saveTodo(todo: TodoModel): Promise<void> {
    if (!this.preferences) return;
    const todos = await this.getTodos();
    const index = todos.findIndex(t => t.id === todo.id);
    if (index >= 0) {
      todos[index] = todo;
    } else {
      todos.push(todo);
    }
    await this.preferences.put('todos', JSON.stringify(todos));
    await this.preferences.flush();
  }

  async deleteTodo(id: string): Promise<void> {
    if (!this.preferences) return;
    const todos = await this.getTodos();
    const filtered = todos.filter(t => t.id !== id);
    await this.preferences.put('todos', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  // 新增：批量保存待办列表（用于删除某日期所有待办）
  async saveTodos(todos: TodoModel[]): Promise<void> {
    if (!this.preferences) return;
    try {
      await this.preferences.put('todos', JSON.stringify(todos));
      await this.preferences.flush();
    } catch (err) {
      console.error('saveTodos failed:', err);
    }
  }

  // 失物招领相关操作
  async getLostFound(): Promise<LostFoundModel[]> {
    if (!this.preferences) return [];
    try {
      const data = await this.preferences.get('lostFound', '[]');
      const jsonStr = data as string;
      const arr = JSON.parse(jsonStr) as object[];
      return arr.map((item: object) => new LostFoundModel(item as Partial<LostFoundModel>));
    } catch (err) {
      console.error('getLostFound failed:', err);
      return [];
    }
  }

  async saveLostFound(item: LostFoundModel): Promise<void> {
    if (!this.preferences) return;
    const list = await this.getLostFound();
    const index = list.findIndex(l => l.id === item.id);
    if (index >= 0) {
      list[index] = item;
    } else {
      list.push(item);
    }
    await this.preferences.put('lostFound', JSON.stringify(list));
    await this.preferences.flush();
  }

  async deleteLostFound(id: string): Promise<void> {
    if (!this.preferences) return;
    const list = await this.getLostFound();
    const filtered = list.filter(l => l.id !== id);
    await this.preferences.put('lostFound', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  // 报修相关操作
  async getRepairs(): Promise<RepairModel[]> {
    if (!this.preferences) return [];
    try {
      const data = await this.preferences.get('repairs', '[]');
      const jsonStr = data as string;
      const arr = JSON.parse(jsonStr) as object[];
      return arr.map((item: object) => new RepairModel(item as Partial<RepairModel>));
    } catch (err) {
      console.error('getRepairs failed:', err);
      return [];
    }
  }

  async saveRepair(repair: RepairModel): Promise<void> {
    if (!this.preferences) return;
    const list = await this.getRepairs();
    const index = list.findIndex(r => r.id === repair.id);
    if (index >= 0) {
      list[index] = repair;
    } else {
      list.push(repair);
    }
    await this.preferences.put('repairs', JSON.stringify(list));
    await this.preferences.flush();
  }

  async deleteRepair(id: string): Promise<void> {
    if (!this.preferences) return;
    const list = await this.getRepairs();
    const filtered = list.filter(r => r.id !== id);
    await this.preferences.put('repairs', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  // 课时配置相关操作
  /**
   * 获取课时配置
   * @returns 课时配置对象
   */
  async getScheduleConfig(): Promise<ScheduleConfig> {
    if (!this.preferences) return ScheduleConfig.getDefaultConfig();
    try {
      const data = await this.preferences.get('scheduleConfig', '');
      const jsonStr = data as string;
      if (!jsonStr) {
        return ScheduleConfig.getDefaultConfig();
      }
      const obj = JSON.parse(jsonStr) as object;
      return new ScheduleConfig(obj as Partial<ScheduleConfig>);
    } catch (err) {
      console.error('getScheduleConfig failed:', err);
      return ScheduleConfig.getDefaultConfig();
    }
  }

  /**
   * 保存课时配置
   * @param config 课时配置对象
   */
  async saveScheduleConfig(config: ScheduleConfig): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('scheduleConfig', JSON.stringify(config));
    await this.preferences.flush();
  }

  // 当前周数相关操作
  /**
   * 获取当前周数
   * @returns 当前周数，默认为1
   */
  async getCurrentWeek(): Promise<number> {
    if (!this.preferences) return 1;
    try {
      const data = await this.preferences.get('currentWeek', 1);
      return data as number;
    } catch (err) {
      console.error('getCurrentWeek failed:', err);
      return 1;
    }
  }

  /**
   * 保存当前周数
   * @param week 周数（1-30）
   */
  async saveCurrentWeek(week: number): Promise<void> {
    if (!this.preferences) return;
    // 确保周数在有效范围内
    const validWeek = Math.max(1, Math.min(30, week));
    await this.preferences.put('currentWeek', validWeek);
    await this.preferences.flush();
  }

  // 新增：学期总周数相关操作
  /**
   * 获取学期总周数
   * @returns 学期总周数，默认为20
   */
  async getTotalWeeks(): Promise<number> {
    if (!this.preferences) return 20;
    try {
      const data = await this.preferences.get('totalWeeks', 20);
      return data as number;
    } catch (err) {
      console.error('getTotalWeeks failed:', err);
      return 20;
    }
  }

  /**
   * 保存学期总周数
   * @param weeks 总周数（1-30）
   */
  async saveTotalWeeks(weeks: number): Promise<void> {
    if (!this.preferences) return;
    // 确保周数在有效范围内
    const validWeeks = Math.max(1, Math.min(30, weeks));
    await this.preferences.put('totalWeeks', validWeeks);
    await this.preferences.flush();
  }

  // 新增：数据管理相关操作
  /**
   * 清空所有课程数据
   */
  async clearAllCourses(): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('courses', '[]');
    await this.preferences.flush();
  }

  /**
   * 清空所有待办数据
   */
  async clearAllTodos(): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('todos', '[]');
    await this.preferences.flush();
  }

  // 新增：字体配置相关操作
  /**
   * 获取字体配置
   * @returns 字体配置对象
   */
  async getFontConfig(): Promise<FontConfig> {
    if (!this.preferences) return new FontConfig();
    try {
      const data = await this.preferences.get('fontConfig', '');
      const jsonStr = data as string;
      if (!jsonStr) {
        return new FontConfig();
      }
      const obj = JSON.parse(jsonStr) as Record<string, number>;
      return new FontConfig(obj.fontSize as FontSize, obj.fontStyle as FontStyle);
    } catch (err) {
      console.error('getFontConfig failed:', err);
      return new FontConfig();
    }
  }

  /**
   * 保存字体配置
   * @param config 字体配置对象
   */
  async saveFontConfig(config: FontConfig): Promise<void> {
    if (!this.preferences) return;
    // 新增：使用类替代对象字面量以符合ArkTS规范
    const fontConfigData = new FontConfigData();
    fontConfigData.fontSize = config.fontSize;
    fontConfigData.fontStyle = config.fontStyle;
    await this.preferences.put('fontConfig', JSON.stringify(fontConfigData));
    await this.preferences.flush();
  }

  // 新增：背景图相关操作
  /**
   * 获取背景图URI
   * @returns 背景图URI字符串，空字符串表示无自定义背景
   */
  async getBackgroundUri(): Promise<string> {
    if (!this.preferences) return '';
    try {
      const data = await this.preferences.get('backgroundUri', '');
      return data as string;
    } catch (err) {
      console.error('getBackgroundUri failed:', err);
      return '';
    }
  }

  /**
   * 保存背景图URI
   * @param uri 背景图URI字符串
   */
  async saveBackgroundUri(uri: string): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('backgroundUri', uri);
    await this.preferences.flush();
  }

  /**
   * 清除背景图
   */
  async clearBackgroundUri(): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('backgroundUri', '');
    await this.preferences.flush();
  }

  // 新增：日志相关操作
  /**
   * 获取所有日志
   * @returns 日志列表
   */
  async getJournals(): Promise<JournalModel[]> {
    if (!this.preferences) return [];
    try {
      const data = await this.preferences.get('journals', '[]');
      const jsonStr = data as string;
      const arr = JSON.parse(jsonStr) as object[];
      return arr.map((item: object) => new JournalModel(item as JournalInit));
    } catch (err) {
      console.error('getJournals failed:', err);
      return [];
    }
  }

  /**
   * 根据日期获取日志
   * @param date 日期（YYYY-MM-DD格式）
   * @returns 日志对象，不存在则返回null
   */
  async getJournalByDate(date: string): Promise<JournalModel | null> {
    const journals = await this.getJournals();
    return journals.find(j => j.date === date) || null;
  }

  /**
   * 保存日志
   * @param journal 日志对象
   */
  async saveJournal(journal: JournalModel): Promise<void> {
    if (!this.preferences) return;
    const journals = await this.getJournals();
    const index = journals.findIndex(j => j.id === journal.id);
    if (index >= 0) {
      journals[index] = journal;
    } else {
      journals.push(journal);
    }
    await this.preferences.put('journals', JSON.stringify(journals));
    await this.preferences.flush();
  }

  /**
   * 删除日志
   * @param id 日志ID
   */
  async deleteJournal(id: string): Promise<void> {
    if (!this.preferences) return;
    const journals = await this.getJournals();
    const filtered = journals.filter(j => j.id !== id);
    await this.preferences.put('journals', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  /**
   * 根据日期删除日志
   * @param date 日期（YYYY-MM-DD格式）
   */
  async deleteJournalByDate(date: string): Promise<void> {
    if (!this.preferences) return;
    const journals = await this.getJournals();
    const filtered = journals.filter(j => j.date !== date);
    await this.preferences.put('journals', JSON.stringify(filtered));
    await this.preferences.flush();
  }

  /**
   * 检查指定日期是否已有日志
   * @param date 日期（YYYY-MM-DD格式）
   * @returns 是否存在
   */
  async hasJournalForDate(date: string): Promise<boolean> {
    const journal = await this.getJournalByDate(date);
    return journal !== null;
  }

  // 新增：每日流转检查日期相关操作
  /**
   * 获取上次检查日期
   * @returns 日期字符串（YYYY-MM-DD格式）
   */
  async getLastCheckDate(): Promise<string> {
    if (!this.preferences) return '';
    try {
      const data = await this.preferences.get('lastCheckDate', '');
      return data as string;
    } catch (err) {
      console.error('getLastCheckDate failed:', err);
      return '';
    }
  }

  /**
   * 保存最后检查日期
   * @param date 日期字符串（YYYY-MM-DD格式）
   */
  async saveLastCheckDate(date: string): Promise<void> {
    if (!this.preferences) return;
    await this.preferences.put('lastCheckDate', date);
    await this.preferences.flush();
  }
}

/**
 * 字体配置数据类
 * 说明：用于JSON序列化的字体配置数据结构
 */
class FontConfigData {
  fontSize: number = 0;
  fontStyle: number = 0;
}
