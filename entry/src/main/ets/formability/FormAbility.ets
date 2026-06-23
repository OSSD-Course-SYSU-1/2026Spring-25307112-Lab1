import FormExtension from '@ohos.app.form.FormExtension';
import formProvider from '@ohos.app.form.formProvider';
import formInfo from '@ohos.app.form.formInfo';
import hilog from '@ohos.hilog';

/**
 * FormAbility
 * 服务卡片能力，处理卡片生命周期
 */
export default class FormAbility extends FormExtension {
  /**
   * 卡片创建时调用
   */
  onAddForm(want: Want): formProvider.FormBindingData {
    hilog.info(0x0000, 'FormAbility', 'onAddForm');

    const formData: Record<string, string> = {
      'title': '校园助手',
      'courseCount': '0',
      'todoCount': '0'
    };

    return formProvider.createFormBindingData(formData);
  }

  /**
   * 卡片更新时调用
   */
  onUpdateForm(formId: string): void {
    hilog.info(0x0000, 'FormAbility', 'onUpdateForm: %{public}s', formId);

    const formData: Record<string, string> = {
      'title': '校园助手',
      'courseCount': '0',
      'todoCount': '0'
    };

    formProvider.updateForm(formId, formProvider.createFormBindingData(formData))
      .then(() => {
        hilog.info(0x0000, 'FormAbility', 'updateForm success');
      })
      .catch((err: Error) => {
        hilog.error(0x0000, 'FormAbility', 'updateForm failed: %{public}s', err.message);
      });
  }

  /**
   * 卡片移除时调用
   */
  onRemoveForm(formId: string): void {
    hilog.info(0x0000, 'FormAbility', 'onRemoveForm: %{public}s', formId);
  }

  /**
   * 卡片事件处理
   */
  onFormEvent(formId: string, message: string): void {
    hilog.info(0x0000, 'FormAbility', 'onFormEvent: %{public}s, %{public}s', formId, message);
  }

  /**
   * 卡片提供者数据恢复
   */
  onAcquireFormState(want: Want): formInfo.FormState {
    return formInfo.FormState.READY;
  }
}

interface Want {
  parameters?: Record<string, Object>;
}
