/**
 * 失物招领数据模型
 */
export class LostFoundModel {
  id: string = '';
  type: number = 1;
  itemName: string = '';
  description: string = '';
  location: string = '';
  time: string = '';
  contact: string = '';
  contactInfo: string = '';
  createTime: number = 0;
  isResolved: boolean = false;

  constructor(init?: Partial<LostFoundModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.type = init.type ?? 1;
      this.itemName = init.itemName ?? '';
      this.description = init.description ?? '';
      this.location = init.location ?? '';
      this.time = init.time ?? '';
      this.contact = init.contact ?? '';
      this.contactInfo = init.contactInfo ?? '';
      this.createTime = init.createTime ?? new Date().getTime();
      this.isResolved = init.isResolved ?? false;
    }
  }

  static generateId(): string {
    return `lostfound_${new Date().getTime()}`;
  }
}

/**
 * 宿舍报修数据模型
 */
export class RepairModel {
  id: string = '';
  building: string = '';
  room: string = '';
  repairType: string = '';
  description: string = '';
  contact: string = '';
  phone: string = '';
  createTime: number = 0;
  status: number = 1;
  appointmentTime: string = '';

  constructor(init?: Partial<RepairModel>) {
    if (init) {
      this.id = init.id ?? '';
      this.building = init.building ?? '';
      this.room = init.room ?? '';
      this.repairType = init.repairType ?? '';
      this.description = init.description ?? '';
      this.contact = init.contact ?? '';
      this.phone = init.phone ?? '';
      this.createTime = init.createTime ?? new Date().getTime();
      this.status = init.status ?? 1;
      this.appointmentTime = init.appointmentTime ?? '';
    }
  }

  static generateId(): string {
    return `repair_${new Date().getTime()}`;
  }
}
