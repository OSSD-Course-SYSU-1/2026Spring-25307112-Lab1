import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CourseModel } from '../model/CourseModel';
import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';
import formBindingData from '@ohos.app.form.formBindingData';

/**
 * 服务卡片数据提供者
 */
export class FormProvider {
  /**
   * 更新卡片数据
   */
  static async updateFormData(formId: string, context: Context): Promise<void> {
    try {
      // 初始化Preferences
      await PreferencesUtil.getInstance().init(context);
      
      // 加载数据
      const courses = await PreferencesUtil.getInstance().getCourses();
      const todos = await PreferencesUtil.getInstance().getTodos();
      
      const today = DateTimeUtil.getCurrentDayOfWeek();
      const todayCourses = courses.filter(c => c.dayOfWeek === today);
      const pendingTodos = todos.filter(t => !t.isCompleted).slice(0, 3);

      // 构建卡片数据
      const formData = {
        todayCourses: todayCourses.map(c => ({
          name: c.name,
          time: `第${c.startSection}-${c.endSection}节`,
          location: c.location,
          color: c.color
        })),
        pendingTodos: pendingTodos.map(t => ({
          title: t.title,
          countdown: t.deadline > 0 ? DateTimeUtil.getCountdown(t.deadline) : ''
        })),
        weekDay: DateTimeUtil.getWeekDayName(today),
        courseCount: todayCourses.length,
        todoCount: pendingTodos.length
      };

      // 更新卡片
      const bindingData = formBindingData.createFormBindingData(formData);
      formBindingData.updateForm(formId, bindingData).then(() => {
        console.info(`[FormProvider] 卡片更新成功: ${formId}`);
      }).catch((error: Error) => {
        console.error(`[FormProvider] 卡片更新失败: ${error.message}`);
      });
    } catch (error) {
      console.error(`[FormProvider] 更新卡片数据失败: ${error}`);
    }
  }
}
