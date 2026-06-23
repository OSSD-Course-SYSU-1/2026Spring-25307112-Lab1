import formProvider from '@ohos.app.form.formProvider';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CourseModel } from '../model/CourseModel';
import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';

/**
 * FormProvider
 * 服务卡片数据提供者
 */
export class FormProvider {
  private static instance: FormProvider;

  private constructor() {}

  static getInstance(): FormProvider {
    if (!FormProvider.instance) {
      FormProvider.instance = new FormProvider();
    }
    return FormProvider.instance;
  }

  /**
   * 更新卡片数据
   */
  async updateFormData(formId: string): Promise<void> {
    const courses = await PreferencesUtil.getInstance().getCourses();
    const todos = await PreferencesUtil.getInstance().getTodos();
    const today = DateTimeUtil.getCurrentDayOfWeek();

    const todayCourses = courses.filter(c => c.dayOfWeek === today);
    const pendingTodos = todos.filter(t => !t.isCompleted);

    const courseList = todayCourses.slice(0, 3).map((c: CourseModel) => ({
      name: c.name,
      location: c.location,
      section: `第${c.startSection}-${c.endSection}节`
    }));

    const todoList = pendingTodos.slice(0, 3).map((t: TodoModel) => ({
      title: t.title,
      deadline: DateTimeUtil.formatDateTime(t.deadline)
    }));

    const formData: Record<string, Object> = {
      'title': '校园助手',
      'date': DateTimeUtil.getFormattedDate(),
      'courseCount': todayCourses.length.toString(),
      'todoCount': pendingTodos.length.toString(),
      'courses': courseList,
      'todos': todoList
    };

    try {
      await formProvider.updateForm(formId, formProvider.createFormBindingData(formData));
    } catch (err) {
      console.error('FormProvider updateFormData failed:', err);
    }
  }

  /**
   * 刷新所有卡片
   */
  async refreshAllForms(): Promise<void> {
    // 在实际应用中，需要维护一个卡片ID列表
    console.log('FormProvider refreshAllForms called');
  }
}
