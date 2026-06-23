import FormExtension from '@ohos.app.form.FormExtension';
import formBindingData from '@ohos.app.form.formBindingData';
import { FormProvider } from '../utils/FormProvider';

/**
 * 服务卡片扩展能力
 */
export default class FormAbility extends FormExtension {
  /**
   * 卡片创建时回调
   */
  onCreate(want: Want): formBindingData.FormBindingData {
    console.info('[FormAbility] onCreate');

    // 创建卡片数据
    const formData = {
      todayCourses: [],
      pendingTodos: [],
      weekDay: '周一',
      courseCount: 0,
      todoCount: 0
    };

    return formBindingData.createFormBindingData(formData);
  }

  /**
   * 卡片更新时回调
   */
  onUpdate(formId: string): void {
    console.info(`[FormAbility] onUpdate: ${formId}`);

    // 更新卡片数据
    FormProvider.updateFormData(formId, this.context);
  }

  /**
   * 卡片销毁时回调
   */
  onDestroy(formId: string): void {
    console.info(`[FormAbility] onDestroy: ${formId}`);
  }

  /**
   * 卡片事件处理
   */
  onEvent(formId: string, message: string): void {
    console.info(`[FormAbility] onEvent: ${formId}, ${message}`);
  }
}

import Want from '@ohos.app.ability.Want';
