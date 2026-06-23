import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { ChatMessageModel } from '../model/NewsModel';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil'; // 新增：字体配置
import { FontHelper } from '../utils/FontHelper'; // 新增：字体辅助工具
import { BackgroundImage } from '../components/BackgroundImage'; // 新增：背景图组件

/**
 * AI问答页面
 * 功能：简易聊天交互
 */
@Component
export struct AIChatPage {
  @State messages: ChatMessageModel[] = [];
  @State inputText: string = '';
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  @State isTyping: boolean = false;
  @State fontConfig: FontConfig = new FontConfig(); // 新增：字体配置状态
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null;

  aboutToAppear(): void {
    this.initWelcomeMessage();
    // 修复：保存监听器引用，以便在aboutToDisappear中移除
    this.themeListener = (isDark: boolean) => {
      this.themeColors = ThemeManager.getInstance().getThemeColor();
    };
    ThemeManager.getInstance().addListener(this.themeListener);
    // 新增：字体配置监听
    this.fontConfigListener = (config: FontConfig) => {
      this.fontConfig = config;
    };
    FontConfigUtil.getInstance().addListener(this.fontConfigListener);
    this.fontConfig = FontConfigUtil.getInstance().getFontConfig();
  }

  // 新增：组件销毁时移除监听器，防止内存泄漏
  aboutToDisappear(): void {
    if (this.themeListener) {
      ThemeManager.getInstance().removeListener(this.themeListener);
    }
    if (this.fontConfigListener) {
      FontConfigUtil.getInstance().removeListener(this.fontConfigListener);
    }
  }

  // 新增：获取缩放后的字体大小，用于全局字体配置生效
  getScaledFontSize(baseSize: number): number {
    return Math.round(baseSize * this.fontConfig.getFontScale());
  }

  // 新增：获取当前字体族，用于全局字体配置生效
  getFontFamily(): string {
    return this.fontConfig.getFontFamily();
  }

  initWelcomeMessage(): void {
    const welcomeMsg = new ChatMessageModel();
    welcomeMsg.id = 'welcome';
    welcomeMsg.content = '你好！我是校园AI助手，有什么可以帮助你的吗？\n\n我可以帮你：\n• 查询课程信息\n• 了解校园服务\n• 解答学习问题\n• 提供生活建议';
    welcomeMsg.isUser = false;
    this.messages = [welcomeMsg];
  }

  sendMessage(): void {
    if (!this.inputText.trim()) return;

    const userMessage = new ChatMessageModel();
    userMessage.id = ChatMessageModel.generateId();
    userMessage.content = this.inputText;
    userMessage.isUser = true;

    this.messages.push(userMessage);
    const userInput = this.inputText;
    this.inputText = '';
    this.isTyping = true;

    setTimeout(() => {
      const aiResponse = this.generateResponse(userInput);
      const aiMsg = new ChatMessageModel();
      aiMsg.id = ChatMessageModel.generateId();
      aiMsg.content = aiResponse;
      aiMsg.isUser = false;
      this.messages.push(aiMsg);
      this.isTyping = false;
    }, 1000);
  }

  generateResponse(input: string): string {
    const lowerInput = input.toLowerCase();

    if (lowerInput.includes('课程') || lowerInput.includes('课表')) {
      return '关于课程信息，你可以在首页的课程表页面查看本周课程安排。如需添加新课程，点击底部"添加课程"按钮即可。';
    }

    if (lowerInput.includes('考试')) {
      return '考试安排可以在待办页面查看，支持设置考试倒计时提醒。建议提前做好复习计划！';
    }

    if (lowerInput.includes('报修') || lowerInput.includes('维修')) {
      return '宿舍报修可以在"服务"页面提交。填写楼栋、房间号和问题描述后，工作人员会尽快处理。';
    }

    if (lowerInput.includes('失物') || lowerInput.includes('丢失')) {
      return '失物招领服务在"服务"页面可以找到。你可以发布丢失或捡到的物品信息，帮助物品找回。';
    }

    if (lowerInput.includes('图书馆')) {
      return '图书馆开放时间：\n周一至周五 8:00-22:00\n周六至周日 9:00-21:00\n需要带学生证进入哦！';
    }

    if (lowerInput.includes('食堂') || lowerInput.includes('吃饭')) {
      return '学校有多个食堂：\n• 一食堂：靠近教学楼，价格实惠\n• 二食堂：品种丰富，有特色窗口\n• 三食堂：环境较好，适合聚餐\n\n建议错峰就餐，避开12:00-12:30高峰期。';
    }

    if (lowerInput.includes('你好') || lowerInput.includes('hi') || lowerInput.includes('hello')) {
      return '你好！很高兴见到你！有什么问题随时问我，我会尽力帮助你的。😊';
    }

    return '我理解你的问题了。作为校园助手，我建议你可以：\n\n1. 查看课程表了解课程安排\n2. 使用待办功能管理学习任务\n3. 通过服务页面办理校园事务\n\n如有其他问题，欢迎继续提问！';
  }

  build() {
    // 新增：使用Stack包裹背景图和内容
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      Column() {
        this.buildTitleBar()

      List({ space: 12 }) {
        ForEach(this.messages, (message: ChatMessageModel) => {
          ListItem() {
            this.buildMessageItem(message)
          }
        })

        if (this.isTyping) {
          ListItem() {
            Row() {
              Row({ space: 4 }) {
                LoadingProgress()
                  .width(16)
                  .height(16)
                  .color(this.themeColors.textSecondary)

                Text('AI正在输入...')
                  .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
                  .fontColor(this.themeColors.textSecondary)
                  .fontFamily(this.getFontFamily()) // 新增：应用字体族
              }
              .padding(12)
              .backgroundColor(this.themeColors.surface)
              .borderRadius(16)
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ left: 16 })
          }
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })

      this.buildInputArea()
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
      Text('AI助手')
        .fontSize(this.getScaledFontSize(20)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Blank()

      SymbolGlyph($r('sys.symbol.trash'))
        .fontSize(20)
        .fontColor([this.themeColors.textSecondary])
        .onClick(() => {
          this.initWelcomeMessage();
        })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  @Builder
  buildMessageItem(message: ChatMessageModel): void {
    Row() {
      if (message.isUser) {
        Blank()

        Column() {
          Text(message.content)
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(Color.White)
            .padding(12)
            .backgroundColor(this.themeColors.primary)
            .borderRadius(16)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .alignItems(HorizontalAlign.End)
        .margin({ left: 60 })
      } else {
        Column() {
          Row() {
            Column()
              .width(32)
              .height(32)
              .borderRadius(16)
              .backgroundColor(this.themeColors.primary)
              .justifyContent(FlexAlign.Center)

            Text('AI')
              .fontSize(this.getScaledFontSize(10)) // 修改：应用字体缩放
              .fontColor(Color.White)
              .fontFamily(this.getFontFamily()) // 新增：应用字体族
          }

          Text(message.content)
            .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
            .fontColor(this.themeColors.text)
            .padding(12)
            .backgroundColor(this.themeColors.surface)
            .borderRadius(16)
            .margin({ top: 8 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ right: 60 })
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .justifyContent(message.isUser ? FlexAlign.End : FlexAlign.Start)
  }

  @Builder
  buildInputArea(): void {
    Row({ space: 12 }) {
      TextInput({ text: $$this.inputText, placeholder: '输入问题...' })
        .layoutWeight(1)
        .height(40)
        .backgroundColor(this.themeColors.surface)
        .borderRadius(20)
        .padding({ left: 16, right: 16 })
        .onSubmit(() => {
          this.sendMessage();
        })

      Column() {
        SymbolGlyph($r('sys.symbol.paperplane'))
          .fontSize(20)
          .fontColor([Color.White])
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor(this.themeColors.primary)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.sendMessage();
      })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 8, bottom: 16 })
    .backgroundColor(this.themeColors.surface)
  }
}
