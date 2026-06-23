import { ThemeManager, ThemeColors } from '../utils/ThemeManager';
import { NewsModel } from '../model/NewsModel';
import { DateTimeUtil } from '../utils/DateTimeUtil';
import { FontConfigUtil, FontConfig } from '../utils/FontConfigUtil'; // 新增：字体配置
import { FontHelper } from '../utils/FontHelper'; // 新增：字体辅助工具
import { BackgroundImage } from '../components/BackgroundImage'; // 新增：背景图组件

/**
 * 校园资讯页面
 * 功能：资讯列表展示 + 详情弹窗
 * 特性：GridRow响应式布局、深浅色主题适配
 */
@Component
export struct CampusNewsPage {
  // 资讯列表数据
  @State newsList: NewsModel[] = [];
  // 当前主题颜色
  @State themeColors: ThemeColors = ThemeManager.getInstance().getThemeColor();
  // 当前选中的资讯（用于详情弹窗）
  @State selectedNews: NewsModel | null = null;
  // 是否显示详情弹窗
  @State showDetail: boolean = false;
  // 是否为深色模式
  @State isDarkMode: boolean = false;
  @State fontConfig: FontConfig = new FontConfig(); // 新增：字体配置状态
  // 新增：监听器引用，用于在组件销毁时移除
  private themeListener: ((isDark: boolean) => void) | null = null;
  private fontConfigListener: ((config: FontConfig) => void) | null = null;

  /**
   * 组件即将出现时初始化
   */
  aboutToAppear(): void {
    // 加载模拟数据
    this.loadMockData();
    // 监听主题变化
    // 修复：保存监听器引用，以便在aboutToDisappear中移除
    this.themeListener = (isDark: boolean) => {
      this.isDarkMode = isDark;
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

  /**
   * 加载模拟校园资讯数据
   * 内置5条模拟数据，无需额外存储
   */
  loadMockData(): void {
    // 资讯1：教务通知
    const news1 = new NewsModel();
    news1.id = '1';
    news1.title = '关于2024年春季学期开学安排的通知';
    news1.source = '教务处';
    news1.publishTime = new Date().getTime() - 2 * 24 * 60 * 60 * 1000; // 2天前
    news1.summary = '根据学校校历安排，2024年春季学期将于2月26日正式开学，请各位同学按时返校报到...';
    news1.content = '根据学校校历安排，2024年春季学期将于2月26日正式开学。\n\n请各位同学按时返校报到，做好开学准备工作。具体安排如下：\n\n1. 报到时间：2月25日-26日\n2. 正式上课：2月27日\n3. 选课时间：开学第一周\n\n请提前准备好相关材料，如有疑问请联系教务处。';
    news1.readCount = 1256;
    news1.type = 1; // 教务

    // 资讯2：后勤公告
    const news2 = new NewsModel();
    news2.id = '2';
    news2.title = '图书馆开放时间调整公告';
    news2.source = '后勤管理处';
    news2.publishTime = new Date().getTime() - 5 * 24 * 60 * 60 * 1000; // 5天前
    news2.summary = '为满足师生学习需求，图书馆将延长开放时间，新开放时间如下...';
    news2.content = '为满足师生学习需求，图书馆将延长开放时间。\n\n新开放时间安排：\n\n周一至周五：8:00-22:00\n周六至周日：9:00-21:00\n\n考试周期间（第16-18周）：\n每天 7:30-23:00\n\n请同学们合理安排学习时间。';
    news2.readCount = 892;
    news2.type = 2; // 后勤

    // 资讯3：社团活动
    const news3 = new NewsModel();
    news3.id = '3';
    news3.title = '校园歌手大赛报名开始';
    news3.source = '校学生会';
    news3.publishTime = new Date().getTime() - 1 * 24 * 60 * 60 * 1000; // 1天前
    news3.summary = '第15届校园歌手大赛即将举行，欢迎广大同学踊跃报名参加...';
    news3.content = '第15届校园歌手大赛即将举行！\n\n报名时间：3月1日-15日\n比赛时间：3月20日初赛\n比赛地点：大学生活动中心\n\n奖项设置：\n一等奖：3000元\n二等奖：2000元\n三等奖：1000元\n\n欢迎广大同学踊跃报名参加，展示你的才艺！';
    news3.readCount = 2341;
    news3.type = 3; // 社团

    // 资讯4：教务通知
    const news4 = new NewsModel();
    news4.id = '4';
    news4.title = '关于2024年上半年英语四六级考试报名的通知';
    news4.source = '教务处';
    news4.publishTime = new Date().getTime() - 3 * 24 * 60 * 60 * 1000; // 3天前
    news4.summary = '2024年上半年英语四六级考试报名即将开始，请符合条件的同学及时报名...';
    news4.content = '2024年上半年英语四六级考试报名即将开始。\n\n报名时间：3月15日-25日\n考试时间：6月15日\n\n报名条件：\n1. 已修完大学英语四级课程\n2. 四级成绩425分以上可报考六级\n\n报名方式：登录教务系统在线报名\n\n请符合条件的同学及时报名，逾期不再补报。';
    news4.readCount = 1567;
    news4.type = 1; // 教务

    // 资讯5：后勤公告
    const news5 = new NewsModel();
    news5.id = '5';
    news5.title = '食堂新菜品上线通知';
    news5.source = '后勤管理处';
    news5.publishTime = new Date().getTime() - 7 * 24 * 60 * 60 * 1000; // 7天前
    news5.summary = '为丰富师生饮食选择，食堂推出多款新菜品，欢迎品尝...';
    news5.content = '为丰富师生饮食选择，食堂推出多款新菜品。\n\n一食堂：\n- 麻辣香锅\n- 黄焖鸡米饭\n- 重庆小面\n\n二食堂：\n- 铁板烧\n- 寿司套餐\n- 精致甜点\n\n欢迎广大师生前来品尝，提出宝贵意见！';
    news5.readCount = 678;
    news5.type = 2; // 后勤

    this.newsList = [news1, news2, news3, news4, news5];
  }

  /**
   * 获取资讯类型标签文本
   * @param type 类型编号
   * @returns 标签文本
   */
  getTypeTag(type: number): string {
    const tags: string[] = ['教务', '后勤', '社团'];
    return tags[type - 1] || '其他';
  }

  /**
   * 获取资讯类型对应颜色
   * @param type 类型编号
   * @returns 颜色值
   */
  getTypeColor(type: number): string {
    const colors: string[] = ['#4A90E2', '#E2A04A', '#4AE24A'];
    return colors[type - 1] || '#888888';
  }

  /**
   * 构建页面主体
   */
  build() {
    // 新增：使用Stack包裹背景图和内容
    Stack() {
      // 新增：背景图层
      BackgroundImage()
      
      Column() {
        // 顶部标题栏
        this.buildTitleBar()

      // 资讯列表区域（使用GridRow实现响应式布局）
      Scroll() {
        GridRow({ columns: { sm: 1, md: 2, lg: 2 } }) {
          ForEach(this.newsList, (news: NewsModel) => {
            GridCol() {
              this.buildNewsCard(news)
            }
            .padding({ left: 8, right: 8, bottom: 12 })
          })
        }
        .width('100%')
        .padding({ left: 8, right: 8, top: 8 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeColors.background)
    // 绑定全屏详情弹窗
    .bindSheet($$this.showDetail, this.buildDetailSheet(), {
      height: '100%',
      backgroundColor: this.themeColors.surface,
      dragBar: false,
      showClose: false // 禁用bindSheet默认关闭按钮，使用自定义关闭按钮
    })
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 构建顶部标题栏
   */
  @Builder
  buildTitleBar(): void {
    Row() {
      Text('校园资讯')
        .fontSize(this.getScaledFontSize(20)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      Blank()

      // 刷新按钮
      SymbolGlyph($r('sys.symbol.arrow_clockwise'))
        .fontSize(20)
        .fontColor([this.themeColors.textSecondary])
        .onClick(() => {
          this.loadMockData();
        })
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(this.themeColors.surface)
  }

  /**
   * 构建资讯卡片
   * @param news 资讯数据
   */
  @Builder
  buildNewsCard(news: NewsModel): void {
    Column() {
      // 顶部：类型标签 + 发布时间
      Row() {
        // 类型标签（教务/后勤/社团）
        Text(this.getTypeTag(news.type))
          .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
          .fontColor(Color.White)
          .backgroundColor(this.getTypeColor(news.type))
          .borderRadius(4)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .fontFamily(this.getFontFamily()) // 新增：应用字体族

        Blank()

        // 发布时间
        Text(DateTimeUtil.getTimeAgo(news.publishTime))
          .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
          .fontColor(this.themeColors.textSecondary)
          .fontFamily(this.getFontFamily()) // 新增：应用字体族
      }
      .width('100%')

      // 标题
      Text(news.title)
        .fontSize(this.getScaledFontSize(16)) // 修改：应用字体缩放
        .fontWeight(FontWeight.Bold)
        .fontColor(this.themeColors.text)
        .margin({ top: 8 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      // 摘要
      Text(news.summary)
        .fontSize(this.getScaledFontSize(14)) // 修改：应用字体缩放
        .fontColor(this.themeColors.textSecondary)
        .margin({ top: 8 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontFamily(this.getFontFamily()) // 新增：应用字体族

      // 底部：发布部门 + 浏览量
      Row() {
        Text(news.source)
          .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
          .fontColor(this.themeColors.textSecondary)
          .fontFamily(this.getFontFamily()) // 新增：应用字体族

        Blank()

        Row({ space: 4 }) {
          SymbolGlyph($r('sys.symbol.eye'))
            .fontSize(14)
            .fontColor([this.themeColors.textSecondary])

          Text(`${news.readCount}`)
            .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.themeColors.surface)
    .borderRadius(12)
    .onClick(() => {
      // 点击卡片，显示详情弹窗
      this.selectedNews = news;
      this.showDetail = true;
    })
  }

  /**
   * 构建详情弹窗
   * 修复：移除重复关闭按钮，仅保留右上角唯一关闭图标
   */
  @Builder
  buildDetailSheet(): void {
    Column() {
      if (this.selectedNews) {
        // 顶部区域：标题 + 关闭按钮
        Row() {
          // 标题区域（占据剩余空间，自动换行）
          Text(this.selectedNews.title)
            .fontSize(this.getScaledFontSize(22)) // 修改：应用字体缩放
            .fontWeight(FontWeight.Bold)
            .fontColor(this.themeColors.text)
            .letterSpacing(1)
            .layoutWeight(1)
            .padding({ left: 16, right: 8 })
            .fontFamily(this.getFontFamily()) // 新增：应用字体族

          // 关闭按钮（固定宽度，右上角定位）
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize(18)
            .fontColor([this.themeColors.textSecondary])
            .width(32)
            .height(32)
            .margin({ right: 16 })
            .onClick(() => {
              // 点击关闭按钮，关闭详情弹窗返回列表页
              this.showDetail = false;
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .margin({ top: 20 })

        // 类型标签 + 来源日期信息
        Row({ space: 10 }) {
          // 类型标签
          Text(this.getTypeTag(this.selectedNews.type))
            .fontSize(this.getScaledFontSize(12)) // 修改：应用字体缩放
            .fontColor(Color.White)
            .backgroundColor(this.getTypeColor(this.selectedNews.type))
            .borderRadius(4)
            .height(22)
            .padding({ left: 8, right: 8 })
            .textAlign(TextAlign.Center)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族

          // 来源 + 发布时间
          Text(`${this.selectedNews.source} | ${DateTimeUtil.formatDateTime(this.selectedNews.publishTime)}`)
            .fontSize(this.getScaledFontSize(13)) // 修改：应用字体缩放
            .fontColor(this.themeColors.textSecondary)
            .fontFamily(this.getFontFamily()) // 新增：应用字体族
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)
        .margin({ top: 20 })

        // 正文内容（分段展示）
        Scroll() {
          Column() {
            // 将正文按段落分割展示
            ForEach(this.selectedNews.content.split('\n\n'), (paragraph: string, index: number) => {
              if (paragraph.trim()) {
                Text(paragraph.trim())
                  .fontSize(this.getScaledFontSize(16)) // 修改：应用字体缩放
                  .fontColor(this.themeColors.text)
                  .lineHeight(28)
                  .width('100%')
                  .margin({ bottom: 16 })
                  .fontFamily(this.getFontFamily()) // 新增：应用字体族
              }
            })
          }
          .width('100%')
          .padding({ left: 18, right: 18, top: 20 })
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
      }
    }
    .width('100%')
    .height('100%')
  }
}
