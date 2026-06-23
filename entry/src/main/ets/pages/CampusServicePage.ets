import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { LostFoundModel, RepairModel } from '../model/ServiceModel';
import { BackgroundImage } from '../components/BackgroundImage'; // 新增：背景图组件

/**
 * 校园服务页面
 * 功能：失物招领表单、宿舍报修表单、本地存储
 */
@Component
export struct CampusServicePage {
  @State currentTab: number = 0;
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State lostFoundList: LostFoundModel[] = [];
  @State repairList: RepairModel[] = [];
  @State showLostFoundDialog: boolean = false;
  @State showRepairDialog: boolean = false;
  @State editingLostFound: LostFoundModel | null = null;
  @State editingRepair: RepairModel | null = null;
  @State selectedType: number = 0; // 0:未选中, 1:丢失, 2:捡到
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;

  aboutToAppear(): void {
    this.loadData();
    // 修复：保存监听器引用，以便在aboutToDisappear中移除
    this.themeListener = (isDark: boolean) => {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
  }

  // 新增：组件销毁时移除监听器，防止内存泄漏
  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
  }

  async loadData(): Promise<void> {
    this.lostFoundList = await PreferencesUtil.getInstance().getLostFound();
    this.repairList = await PreferencesUtil.getInstance().getRepairs();
  }

  build() {
    // 新增：使用Stack包裹背景图和内容
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()

      Row({ space: 24 }) {
        Text('失物招领')
          .fontSize(16)
          .fontWeight(this.currentTab === 0 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 0 ? this.themeColors.primary : this.themeColors.textSecondary)
          .onClick(() => { this.currentTab = 0; })

        Text('宿舍报修')
          .fontSize(16)
          .fontWeight(this.currentTab === 1 ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.currentTab === 1 ? this.themeColors.primary : this.themeColors.textSecondary)
          .onClick(() => { this.currentTab = 1; })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.themeColors.surface)

      if (this.currentTab === 0) {
        this.buildLostFoundContent()
      } else {
        this.buildRepairContent()
      }
    }
    .width('100%')
    .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildTitleBar(): void {
    Row() {
      Text('校园服务')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  @Builder
  buildLostFoundContent(): void {
    Column() {
      List({ space: 8 }) {
        ForEach(this.lostFoundList, (item: LostFoundModel) => {
          ListItem() {
            Row() {
              Column() {
                Row() {
                  Text(item.type === 1 ? '【丢失】' : '【捡到】')
                    .fontSize(12)
                    .fontColor(item.type === 1 ? this.themeColors.error : this.themeColors.success)

                  Text(item.itemName)
                    .fontSize(16)
                    .fontColor(this.themeColors.text)
                    .fontWeight(FontWeight.Bold)
                }

                Text(item.description)
                  .fontSize(14)
                  .fontColor(this.themeColors.textSecondary)
                  .margin({ top: 8 })
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Row({ space: 16 }) {
                  Text(`地点: ${item.location}`)
                    .fontSize(12)
                    .fontColor(this.themeColors.textSecondary)

                  Text(`时间: ${item.time}`)
                    .fontSize(12)
                    .fontColor(this.themeColors.textSecondary)
                }
                .margin({ top: 8 })

                Text(`联系方式: ${item.contactInfo}`)
                  .fontSize(12)
                  .fontColor(this.themeColors.primary)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              SymbolGlyph($r('sys.symbol.trash'))
                .fontSize(20)
                .fontColor([this.themeColors.error])
                .onClick(async () => {
                  await PreferencesUtil.getInstance().deleteLostFound(item.id);
                  this.loadData();
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(this.themeColors.surface)
            .borderRadius(12)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })

      Row() {
        Button('发布信息')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(() => {
            this.editingLostFound = null;
            this.selectedType = 0;
            this.showLostFoundDialog = true;
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .layoutWeight(1)
    .bindSheet($$this.showLostFoundDialog, this.lostFoundDialog, {
      height: 500,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
  }

  @Builder
  buildRepairContent(): void {
    Column() {
      List({ space: 8 }) {
        ForEach(this.repairList, (item: RepairModel) => {
          ListItem() {
            Row() {
              Column() {
                Row() {
                  Text(`${item.building} ${item.room}`)
                    .fontSize(16)
                    .fontColor(this.themeColors.text)
                    .fontWeight(FontWeight.Bold)

                  Blank()

                  Text(this.getStatusText(item.status))
                    .fontSize(12)
                    .fontColor(this.getStatusColor(item.status))
                }
                .width('100%')

                Text(`${item.repairType}: ${item.description}`)
                  .fontSize(14)
                  .fontColor(this.themeColors.textSecondary)
                  .margin({ top: 8 })
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(`联系电话: ${item.phone}`)
                  .fontSize(12)
                  .fontColor(this.themeColors.textSecondary)
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              SymbolGlyph($r('sys.symbol.trash'))
                .fontSize(20)
                .fontColor([this.themeColors.error])
                .onClick(async () => {
                  await PreferencesUtil.getInstance().deleteRepair(item.id);
                  this.loadData();
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor(this.themeColors.surface)
            .borderRadius(12)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })

      Row() {
        Button('提交报修')
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.themeColors.primary)
          .borderRadius(20)
          .onClick(() => {
            this.editingRepair = null;
            this.showRepairDialog = true;
          })
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .layoutWeight(1)
    .bindSheet($$this.showRepairDialog, this.repairDialog, {
      height: 550,
      backgroundColor: this.themeColors.surface,
      dragBar: true
    })
  }

  getStatusText(status: number): string {
    const texts: string[] = ['待处理', '处理中', '已完成'];
    return texts[status - 1] || '未知';
  }

  getStatusColor(status: number): ResourceColor {
    const colors: ResourceColor[] = [this.themeColors.warning, this.themeColors.primary, this.themeColors.success];
    return colors[status - 1] || this.themeColors.textSecondary;
  }

  @Builder
  lostFoundDialog(): void {
    Column() {
      Text('发布失物招领')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 24 })

      Column({ space: 16 }) {
        TextInput({ placeholder: '物品名称' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (!this.editingLostFound) {
              this.editingLostFound = new LostFoundModel();
            }
            this.editingLostFound.itemName = value;
          })

        TextInput({ placeholder: '描述' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingLostFound) {
              this.editingLostFound.description = value;
            }
          })

        TextInput({ placeholder: '地点' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingLostFound) {
              this.editingLostFound.location = value;
            }
          })

        TextInput({ placeholder: '联系方式' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingLostFound) {
              this.editingLostFound.contactInfo = value;
            }
          })

        Row({ space: 16 }) {
          Button('丢失')
            .fontSize(14)
            .fontColor(this.selectedType === 1 ? Color.White : this.themeColors.error)
            .backgroundColor(this.selectedType === 1 ? this.themeColors.error : this.themeColors.background)
            .borderRadius(20)
            .border({ width: 1, color: this.themeColors.error })
            .onClick(() => {
              this.selectedType = 1;
              if (!this.editingLostFound) {
                this.editingLostFound = new LostFoundModel();
              }
              this.editingLostFound.type = 1;
            })

          Button('捡到')
            .fontSize(14)
            .fontColor(this.selectedType === 2 ? Color.White : this.themeColors.success)
            .backgroundColor(this.selectedType === 2 ? this.themeColors.success : this.themeColors.background)
            .borderRadius(20)
            .border({ width: 1, color: this.themeColors.success })
            .onClick(() => {
              this.selectedType = 2;
              if (!this.editingLostFound) {
                this.editingLostFound = new LostFoundModel();
              }
              this.editingLostFound.type = 2;
            })
        }
      }
      .width('100%')
      .padding({ left: 24, right: 24 })

      Button('发布')
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(20)
        .margin({ top: 24 })
        .onClick(async () => {
          if (this.editingLostFound && this.selectedType > 0) {
            this.editingLostFound.id = LostFoundModel.generateId();
            this.editingLostFound.time = new Date().toLocaleString();
            await PreferencesUtil.getInstance().saveLostFound(this.editingLostFound);
            this.showLostFoundDialog = false;
            this.editingLostFound = null;
            this.selectedType = 0;
            this.loadData();
          }
        })
    }
    .width('100%')
    .padding(16)
  }

  @Builder
  repairDialog(): void {
    Column() {
      Text('提交报修申请')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 16, bottom: 24 })

      Column({ space: 16 }) {
        TextInput({ placeholder: '楼栋' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (!this.editingRepair) {
              this.editingRepair = new RepairModel();
            }
            this.editingRepair.building = value;
          })

        TextInput({ placeholder: '房间号' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingRepair) {
              this.editingRepair.room = value;
            }
          })

        TextInput({ placeholder: '报修类型' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingRepair) {
              this.editingRepair.repairType = value;
            }
          })

        TextInput({ placeholder: '问题描述' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingRepair) {
              this.editingRepair.description = value;
            }
          })

        TextInput({ placeholder: '联系电话' })
          .width('100%')
          .height(40)
          .backgroundColor(this.themeColors.background)
          .borderRadius(8)
          .onChange((value: string) => {
            if (this.editingRepair) {
              this.editingRepair.phone = value;
            }
          })
      }
      .width('100%')
      .padding({ left: 24, right: 24 })

      Button('提交')
        .fontSize(14)
        .fontColor(Color.White)
        .backgroundColor(this.themeColors.primary)
        .borderRadius(20)
        .margin({ top: 24 })
        .onClick(async () => {
          if (this.editingRepair) {
            this.editingRepair.id = RepairModel.generateId();
            await PreferencesUtil.getInstance().saveRepair(this.editingRepair);
            this.showRepairDialog = false;
            this.editingRepair = null;
            this.loadData();
          }
        })
    }
    .width('100%')
    .padding(16)
  }
}
