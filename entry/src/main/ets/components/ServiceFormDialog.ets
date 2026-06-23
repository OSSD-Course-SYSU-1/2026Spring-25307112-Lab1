import { LostFoundModel, RepairModel } from '../model/ServiceModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';

/**
 * 服务表单对话框组件
 */
@Component
export struct ServiceFormDialog {
  @Prop currentTab: number = 0;
  @State formType: number = 0;

  @State lfType: number = 1;
  @State lfItemName: string = '';
  @State lfDescription: string = '';
  @State lfLocation: string = '';
  @State lfTime: string = '';
  @State lfContact: string = '';
  @State lfContactInfo: string = '';

  @State rpBuilding: string = '';
  @State rpRoom: string = '';
  @State rpRepairType: string = '';
  @State rpDescription: string = '';
  @State rpContact: string = '';
  @State rpPhone: string = '';

  onSubmit?: (type: number, data: LostFoundModel | RepairModel) => void;
  onCancel?: () => void;

  aboutToAppear(): void {
    this.formType = this.currentTab;
  }

  build() {
    Column() {
      Text(this.formType === 0 ? '发布失物招领' : '提交宿舍报修')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 16 })

      Scroll() {
        Column({ space: 16 }) {
          Row() {
            Button('失物招领')
              .fontSize(14)
              .fontColor(this.formType === 0 ? Color.White : '#333333')
              .backgroundColor(this.formType === 0 ? '#4A90E2' : '#F0F0F0')
              .layoutWeight(1)
              .onClick(() => this.formType = 0)

            Button('宿舍报修')
              .fontSize(14)
              .fontColor(this.formType === 1 ? Color.White : '#333333')
              .backgroundColor(this.formType === 1 ? '#4A90E2' : '#F0F0F0')
              .layoutWeight(1)
              .onClick(() => this.formType = 1)
          }
          .width('100%')

          if (this.formType === 0) {
            this.lostFoundForm()
          } else {
            this.repairForm()
          }
        }
        .padding(16)
      }
      .layoutWeight(1)

      Row({ space: 16 }) {
        Button('取消')
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F0F0F0')
          .layoutWeight(1)
          .onClick(() => {
            if (this.onCancel) this.onCancel();
          })

        Button('提交')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#4A90E2')
          .layoutWeight(1)
          .onClick(() => {
            this.submitForm();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  lostFoundForm(): void {
    Column({ space: 12 }) {
      Row() {
        Button('丢失')
          .fontSize(14)
          .fontColor(this.lfType === 1 ? Color.White : '#333333')
          .backgroundColor(this.lfType === 1 ? '#F56C6C' : '#F0F0F0')
          .layoutWeight(1)
          .onClick(() => this.lfType = 1)

        Button('拾获')
          .fontSize(14)
          .fontColor(this.lfType === 2 ? Color.White : '#333333')
          .backgroundColor(this.lfType === 2 ? '#67C23A' : '#F0F0F0')
          .layoutWeight(1)
          .onClick(() => this.lfType = 2)
      }
      .width('100%')

      TextInput({ placeholder: '物品名称', text: this.lfItemName })
        .onChange((value: string) => this.lfItemName = value)
        .width('100%')

      TextArea({ placeholder: '物品描述', text: this.lfDescription })
        .onChange((value: string) => this.lfDescription = value)
        .width('100%')
        .height(80)

      TextInput({ placeholder: '地点', text: this.lfLocation })
        .onChange((value: string) => this.lfLocation = value)
        .width('100%')

      TextInput({ placeholder: '时间', text: this.lfTime })
        .onChange((value: string) => this.lfTime = value)
        .width('100%')

      TextInput({ placeholder: '联系人', text: this.lfContact })
        .onChange((value: string) => this.lfContact = value)
        .width('100%')

      TextInput({ placeholder: '联系方式', text: this.lfContactInfo })
        .onChange((value: string) => this.lfContactInfo = value)
        .width('100%')
    }
  }

  @Builder
  repairForm(): void {
    Column({ space: 12 }) {
      TextInput({ placeholder: '宿舍楼', text: this.rpBuilding })
        .onChange((value: string) => this.rpBuilding = value)
        .width('100%')

      TextInput({ placeholder: '房间号', text: this.rpRoom })
        .onChange((value: string) => this.rpRoom = value)
        .width('100%')

      TextInput({ placeholder: '报修类型（如：电路、水管、门窗）', text: this.rpRepairType })
        .onChange((value: string) => this.rpRepairType = value)
        .width('100%')

      TextArea({ placeholder: '问题描述', text: this.rpDescription })
        .onChange((value: string) => this.rpDescription = value)
        .width('100%')
        .height(80)

      TextInput({ placeholder: '联系人', text: this.rpContact })
        .onChange((value: string) => this.rpContact = value)
        .width('100%')

      TextInput({ placeholder: '联系电话', text: this.rpPhone })
        .onChange((value: string) => this.rpPhone = value)
        .type(InputType.PhoneNumber)
        .width('100%')
    }
  }

  submitForm(): void {
    if (this.formType === 0) {
      if (!this.lfItemName || !this.lfContact) {
        return;
      }
      const data = new LostFoundModel({
        id: LostFoundModel.generateId(),
        type: this.lfType,
        itemName: this.lfItemName,
        description: this.lfDescription,
        location: this.lfLocation,
        time: this.lfTime || DateTimeUtil.formatDate(Date.now(), 'YYYY-MM-DD'),
        contact: this.lfContact,
        contactInfo: this.lfContactInfo
      });
      if (this.onSubmit) this.onSubmit(0, data);
    } else {
      if (!this.rpBuilding || !this.rpRoom || !this.rpContact) {
        return;
      }
      const data = new RepairModel({
        id: RepairModel.generateId(),
        building: this.rpBuilding,
        room: this.rpRoom,
        repairType: this.rpRepairType,
        description: this.rpDescription,
        contact: this.rpContact,
        phone: this.rpPhone
      });
      if (this.onSubmit) this.onSubmit(1, data);
    }
  }
}
