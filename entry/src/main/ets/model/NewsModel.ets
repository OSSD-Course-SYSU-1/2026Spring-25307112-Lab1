/**
 * 校园资讯数据模型
 */
export class NewsModel {
  id: string = '';
  title: string = '';
  source: string = '';
  publishTime: number = 0;
  summary: string = '';
  content: string = '';
  images: string[] = [];
  readCount: number = 0;
  type: number = 1;

  constructor(init?: Partial<NewsModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.title = init.title ?? '';
      this.source = init.source ?? '';
      this.publishTime = init.publishTime ?? new Date().getTime();
      this.summary = init.summary ?? '';
      this.content = init.content ?? '';
      this.images = init.images ?? [];
      this.readCount = init.readCount ?? 0;
      this.type = init.type ?? 1;
    }
  }

  static generateId(): string {
    return `news_${new Date().getTime()}`;
  }
}

/**
 * AI聊天消息数据模型
 */
export class ChatMessageModel {
  id: string = '';
  content: string = '';
  isUser: boolean = true;
  timestamp: number = 0;

  constructor(init?: Partial<ChatMessageModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.content = init.content ?? '';
      this.isUser = init.isUser ?? true;
      this.timestamp = init.timestamp ?? new Date().getTime();
    }
  }

  static generateId(): string {
    return `msg_${new Date().getTime()}`;
  }
}
