/**
 * 课时配置数据模型
 * 用于存储每一节课的起止时间
 */
export class SectionTime {
  section: number = 1;        // 节次（第1节、第2节...）
  startTime: string = '';     // 开始时间（格式：HH:mm）
  endTime: string = '';       // 结束时间（格式：HH:mm）

  constructor(init?: Partial<SectionTime>) {
    if (init) {
      this.section = init.section ?? 1;
      this.startTime = init.startTime ?? '';
      this.endTime = init.endTime ?? '';
    }
  }
}

/**
 * 默认时间配置接口
 */
interface DefaultTimeConfig {
  start: string;
  end: string;
}

/**
 * 课程表配置模型
 * 包含单日总节数和每节课的时间配置
 */
export class ScheduleConfig {
  totalSections: number = 8;                    // 单日总课程节数
  sectionTimes: SectionTime[] = [];             // 每节课的时间配置

  constructor(init?: Partial<ScheduleConfig>) {
    if (init) {
      this.totalSections = init.totalSections ?? 8;
      this.sectionTimes = init.sectionTimes?.map(st => new SectionTime(st)) ?? [];
    }
  }

  /**
   * 获取默认课时配置（8节课）
   */
  static getDefaultConfig(): ScheduleConfig {
    const config = new ScheduleConfig();
    config.totalSections = 8;
    
    // 创建8节课的默认时间配置
    const section1 = new SectionTime();
    section1.section = 1;
    section1.startTime = '08:00';
    section1.endTime = '08:45';
    
    const section2 = new SectionTime();
    section2.section = 2;
    section2.startTime = '08:55';
    section2.endTime = '09:40';
    
    const section3 = new SectionTime();
    section3.section = 3;
    section3.startTime = '10:00';
    section3.endTime = '10:45';
    
    const section4 = new SectionTime();
    section4.section = 4;
    section4.startTime = '10:55';
    section4.endTime = '11:40';
    
    const section5 = new SectionTime();
    section5.section = 5;
    section5.startTime = '14:00';
    section5.endTime = '14:45';
    
    const section6 = new SectionTime();
    section6.section = 6;
    section6.startTime = '14:55';
    section6.endTime = '15:40';
    
    const section7 = new SectionTime();
    section7.section = 7;
    section7.startTime = '16:00';
    section7.endTime = '16:45';
    
    const section8 = new SectionTime();
    section8.section = 8;
    section8.startTime = '16:55';
    section8.endTime = '17:40';
    
    config.sectionTimes = [section1, section2, section3, section4, section5, section6, section7, section8];
    return config;
  }

  /**
   * 根据总节数生成默认时间配置
   * @param totalSections 总节数
   */
  static generateDefaultConfig(totalSections: number): ScheduleConfig {
    const config = new ScheduleConfig();
    config.totalSections = totalSections;
    config.sectionTimes = [];

    // 默认时间模板（上午4节，下午4节，晚上2节）
    const defaultTimes: DefaultTimeConfig[] = [
      { start: '08:00', end: '08:45' },
      { start: '08:55', end: '09:40' },
      { start: '10:00', end: '10:45' },
      { start: '10:55', end: '11:40' },
      { start: '14:00', end: '14:45' },
      { start: '14:55', end: '15:40' },
      { start: '16:00', end: '16:45' },
      { start: '16:55', end: '17:40' },
      { start: '19:00', end: '19:45' },
      { start: '19:55', end: '20:40' }
    ];

    for (let i = 0; i < totalSections; i++) {
      const time = defaultTimes[i] || { start: '00:00', end: '00:00' };
      const sectionTime = new SectionTime();
      sectionTime.section = i + 1;
      sectionTime.startTime = time.start;
      sectionTime.endTime = time.end;
      config.sectionTimes.push(sectionTime);
    }

    return config;
  }
}
