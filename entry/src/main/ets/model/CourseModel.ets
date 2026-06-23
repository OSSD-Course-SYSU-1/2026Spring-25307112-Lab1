/**
 * 课程数据模型
 * 用于存储课程表信息
 */
export class CourseModel {
  id: string = '';
  name: string = '';
  teacher: string = '';
  location: string = '';
  dayOfWeek: number = 1;
  startSection: number = 1;
  endSection: number = 2;
  color: string = '#4A90E2';
  startWeek: number = 1;
  endWeek: number = 16;
  remark: string = '';

  constructor(init?: Partial<CourseModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.name = init.name ?? '';
      this.teacher = init.teacher ?? '';
      this.location = init.location ?? '';
      this.dayOfWeek = init.dayOfWeek ?? 1;
      this.startSection = init.startSection ?? 1;
      this.endSection = init.endSection ?? 2;
      this.color = init.color ?? '#4A90E2';
      this.startWeek = init.startWeek ?? 1;
      this.endWeek = init.endWeek ?? 16;
      this.remark = init.remark ?? '';
    }
  }

  static generateId(): string {
    return `course_${new Date().getTime()}`;
  }
}
