import wantAgent from '@ohos.app.ability.wantAgent';
import formProvider from '@ohos.app.form.formProvider';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { CourseModel } from '../model/CourseModel';
import { TodoModel } from '../model/TodoModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';

/**
 * 服务卡片提供者
 * 用于更新卡片数据
 */
export class FormProvider {
  /**
   * 更新卡片数据
   */
  static async updateFormData(formId: string, context: Context): Promise<void> {
    try {
      // 加载数据
      await PreferencesUtil.getInstance().init(context);
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
      formProvider.updateForm(formId, formData).then(() => {
        console.info(`[FormProvider] 卡片更新成功: ${formId}`);
      }).catch((error: Error) => {
        console.error(`[FormProvider] 卡片更新失败: ${error.message}`);
      });
    } catch (error) {
      console.error(`[FormProvider] 更新卡片数据失败: ${error}`);
    }
  }

  /**
   * 创建跳转Intent
   */
  static async createJumpIntent(context: Context, targetPage: string): Promise<wantAgent.WantAgent> {
    const want: wantAgent.Want = {
      bundleName: context.applicationInfo.name,
      abilityName: 'EntryAbility',
      parameters: {
        targetPage: targetPage
      }
    };

    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [want],
      requestCode: 0,
      operationType: wantAgent.OperationType.START_ABILITY,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    return await wantAgent.getWantAgent(wantAgentInfo);
  }
}
