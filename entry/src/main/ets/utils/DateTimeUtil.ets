/**
 * 日期时间工具类
 */
export class DateTimeUtil {
  /**
   * 获取当前是周几 (1-7)
   */
  static getCurrentDayOfWeek(): number {
    const day = new Date().getDay();
    return day === 0 ? 7 : day;
  }

  /**
   * 获取格式化的日期字符串
   */
  static getFormattedDate(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    const weekDay = weekDays[now.getDay()];
    return `${year}年${month}月${day}日 ${weekDay}`;
  }

  /**
   * 格式化时间戳为日期时间字符串
   */
  static formatDateTime(timestamp: number): string {
    // 修复：添加timestamp有效性验证
    if (typeof timestamp !== 'number' || isNaN(timestamp)) {
      return '';
    }
    const date = new Date(timestamp);
    // 修复：检查日期对象是否有效
    if (isNaN(date.getTime())) {
      return '';
    }
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hour = date.getHours();
    const minute = date.getMinutes();
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')} ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
  }

  /**
   * 获取倒计时文本
   */
  static getCountdownText(deadline: number): string {
    // 修复：添加deadline有效性验证
    if (typeof deadline !== 'number' || isNaN(deadline)) {
      return '未知';
    }
    const now = Date.now();
    const diff = deadline - now;

    if (diff <= 0) {
      return '已结束';
    }

    const days = Math.floor(diff / (24 * 60 * 60 * 1000));
    const hours = Math.floor((diff % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000));
    const minutes = Math.floor((diff % (60 * 60 * 1000)) / (60 * 1000));

    if (days > 0) {
      return `${days}天${hours}小时${minutes}分钟`;
    } else if (hours > 0) {
      return `${hours}小时${minutes}分钟`;
    } else {
      return `${minutes}分钟`;
    }
  }

  /**
   * 获取相对时间描述
   */
  static getTimeAgo(timestamp: number): string {
    // 修复：添加timestamp有效性验证
    if (typeof timestamp !== 'number' || isNaN(timestamp)) {
      return '未知';
    }
    const now = Date.now();
    const diff = now - timestamp;

    const minutes = Math.floor(diff / (60 * 1000));
    const hours = Math.floor(diff / (60 * 60 * 1000));
    const days = Math.floor(diff / (24 * 60 * 60 * 1000));

    if (minutes < 1) {
      return '刚刚';
    } else if (minutes < 60) {
      return `${minutes}分钟前`;
    } else if (hours < 24) {
      return `${hours}小时前`;
    } else if (days < 7) {
      return `${days}天前`;
    } else {
      return DateTimeUtil.formatDateTime(timestamp).split(' ')[0];
    }
  }

  /**
   * 获取当前周数
   */
  static getCurrentWeek(startDate?: Date): number {
    const now = new Date();
    const start = startDate || new Date(now.getFullYear(), 0, 1);
    const diff = now.getTime() - start.getTime();
    const week = Math.ceil(diff / (7 * 24 * 60 * 60 * 1000));
    return week > 0 ? week : 1;
  }
}
