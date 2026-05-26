if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AdjustPanel_Params {
    brightnessValue?: number;
    contrastValue?: number;
    saturationValue?: number;
    hueValue?: number;
    warmthValue?: number;
    exposureValue?: number;
    gammaValue?: number;
    // Callback for reset
    onReset?: () => void;
}
export class AdjustPanel extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__brightnessValue = new SynchedPropertySimpleTwoWayPU(params.brightnessValue, this, "brightnessValue");
        this.__contrastValue = new SynchedPropertySimpleTwoWayPU(params.contrastValue, this, "contrastValue");
        this.__saturationValue = new SynchedPropertySimpleTwoWayPU(params.saturationValue, this, "saturationValue");
        this.__hueValue = new SynchedPropertySimpleTwoWayPU(params.hueValue, this, "hueValue");
        this.__warmthValue = new SynchedPropertySimpleTwoWayPU(params.warmthValue, this, "warmthValue");
        this.__exposureValue = new SynchedPropertySimpleTwoWayPU(params.exposureValue, this, "exposureValue");
        this.__gammaValue = new SynchedPropertySimpleTwoWayPU(params.gammaValue, this, "gammaValue");
        this.onReset = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AdjustPanel_Params) {
        if (params.onReset !== undefined) {
            this.onReset = params.onReset;
        }
    }
    updateStateVars(params: AdjustPanel_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__brightnessValue.purgeDependencyOnElmtId(rmElmtId);
        this.__contrastValue.purgeDependencyOnElmtId(rmElmtId);
        this.__saturationValue.purgeDependencyOnElmtId(rmElmtId);
        this.__hueValue.purgeDependencyOnElmtId(rmElmtId);
        this.__warmthValue.purgeDependencyOnElmtId(rmElmtId);
        this.__exposureValue.purgeDependencyOnElmtId(rmElmtId);
        this.__gammaValue.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__brightnessValue.aboutToBeDeleted();
        this.__contrastValue.aboutToBeDeleted();
        this.__saturationValue.aboutToBeDeleted();
        this.__hueValue.aboutToBeDeleted();
        this.__warmthValue.aboutToBeDeleted();
        this.__exposureValue.aboutToBeDeleted();
        this.__gammaValue.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // Use @Link for two-way data binding to ensure slider updates on reset
    private __brightnessValue: SynchedPropertySimpleTwoWayPU<number>;
    get brightnessValue() {
        return this.__brightnessValue.get();
    }
    set brightnessValue(newValue: number) {
        this.__brightnessValue.set(newValue);
    }
    private __contrastValue: SynchedPropertySimpleTwoWayPU<number>;
    get contrastValue() {
        return this.__contrastValue.get();
    }
    set contrastValue(newValue: number) {
        this.__contrastValue.set(newValue);
    }
    private __saturationValue: SynchedPropertySimpleTwoWayPU<number>;
    get saturationValue() {
        return this.__saturationValue.get();
    }
    set saturationValue(newValue: number) {
        this.__saturationValue.set(newValue);
    }
    private __hueValue: SynchedPropertySimpleTwoWayPU<number>;
    get hueValue() {
        return this.__hueValue.get();
    }
    set hueValue(newValue: number) {
        this.__hueValue.set(newValue);
    }
    private __warmthValue: SynchedPropertySimpleTwoWayPU<number>;
    get warmthValue() {
        return this.__warmthValue.get();
    }
    set warmthValue(newValue: number) {
        this.__warmthValue.set(newValue);
    }
    private __exposureValue: SynchedPropertySimpleTwoWayPU<number>;
    get exposureValue() {
        return this.__exposureValue.get();
    }
    set exposureValue(newValue: number) {
        this.__exposureValue.set(newValue);
    }
    private __gammaValue: SynchedPropertySimpleTwoWayPU<number>;
    get gammaValue() {
        return this.__gammaValue.get();
    }
    set gammaValue(newValue: number) {
        this.__gammaValue.set(newValue);
    }
    // Callback for reset
    private onReset?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.padding(24);
            Column.backgroundColor('#ffffff');
            Column.borderRadius(24);
            Column.shadow({
                radius: 20,
                color: 'rgba(0, 0, 0, 0.08)',
                offsetX: 0,
                offsetY: 8
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Header with title and reset button - 美化的标题栏
            Row.create();
            // Header with title and reset button - 美化的标题栏
            Row.width('100%');
            // Header with title and reset button - 美化的标题栏
            Row.margin({ bottom: 20 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('⚙️ ');
            Text.fontSize(20);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("参数调整");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#2d3748');
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 重置按钮 - 渐变背景
            Button.createWithChild();
            // 重置按钮 - 渐变背景
            Button.linearGradient({
                angle: 90,
                colors: [
                    ['#667eea', 0.0],
                    ['#764ba2', 1.0]
                ]
            });
            // 重置按钮 - 渐变背景
            Button.borderRadius(18);
            // 重置按钮 - 渐变背景
            Button.height(36);
            // 重置按钮 - 渐变背景
            Button.padding({ left: 16, right: 16 });
            // 重置按钮 - 渐变背景
            Button.shadow({
                radius: 8,
                color: 'rgba(102, 126, 234, 0.3)',
                offsetX: 0,
                offsetY: 3
            });
            // 重置按钮 - 渐变背景
            Button.onClick(() => {
                if (this.onReset) {
                    this.onReset();
                }
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('↺');
            Text.fontSize(16);
            Text.fontColor('#ffffff');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('重置');
            Text.fontSize(13);
            Text.fontColor('#ffffff');
            Text.fontWeight(FontWeight.Medium);
            Text.margin({ left: 4 });
        }, Text);
        Text.pop();
        Row.pop();
        // 重置按钮 - 渐变背景
        Button.pop();
        // Header with title and reset button - 美化的标题栏
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Scrollable slider list
            Scroll.create();
            // Scrollable slider list
            Scroll.width('100%');
            // Scrollable slider list
            Scroll.layoutWeight(1);
            // Scrollable slider list
            Scroll.scrollBar(BarState.Off);
            // Scrollable slider list
            Scroll.edgeEffect(EdgeEffect.Spring);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        // Brightness - 亮度
        this.SliderItem.bind(this)('💡', '亮度', this.brightnessValue, 0, 200, (newValue: number) => {
            this.brightnessValue = Math.round(newValue);
        });
        // Contrast - 对比度
        this.SliderItem.bind(this)('🔲', '对比度', this.contrastValue, 0, 200, (newValue: number) => {
            this.contrastValue = Math.round(newValue);
        });
        // Saturation - 饱和度
        this.SliderItem.bind(this)('🎨', '饱和度', this.saturationValue, 0, 200, (newValue: number) => {
            this.saturationValue = Math.round(newValue);
        });
        // Hue - 色相
        this.SliderItem.bind(this)('🌈', '色相', this.hueValue, 0, 360, (newValue: number) => {
            this.hueValue = Math.round(newValue);
        }, '°');
        // Warmth - 色温
        this.SliderItem.bind(this)('🌡️', '色温', this.warmthValue, 0, 200, (newValue: number) => {
            this.warmthValue = Math.round(newValue);
        });
        // Exposure - 曝光
        this.SliderItem.bind(this)('☀️', '曝光', this.exposureValue, 0, 200, (newValue: number) => {
            this.exposureValue = Math.round(newValue);
        });
        // Gamma - 伽马
        this.SliderItem.bind(this)('📊', '伽马', this.gammaValue, 0, 200, (newValue: number) => {
            this.gammaValue = Math.round(newValue);
        });
        Column.pop();
        // Scrollable slider list
        Scroll.pop();
        Column.pop();
    }
    // 美化的滑块项组件
    SliderItem(icon: string, label: string, value: number, min: number, max: number, onChange: (value: number) => void, unit: string = '', parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.padding({ top: 12, bottom: 12 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 标签和数值显示
            Row.create();
            // 标签和数值显示
            Row.width('100%');
            // 标签和数值显示
            Row.margin({ bottom: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 图标和标签
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(icon);
            Text.fontSize(18);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(label);
            Text.fontSize(14);
            Text.fontColor('#4a5568');
            Text.fontWeight(FontWeight.Medium);
            Text.margin({ left: 6 });
        }, Text);
        Text.pop();
        // 图标和标签
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 数值显示 - 带背景卡片
            Row.create();
            // 数值显示 - 带背景卡片
            Row.padding({ left: 12, right: 12, top: 4, bottom: 4 });
            // 数值显示 - 带背景卡片
            Row.backgroundColor('rgba(102, 126, 234, 0.1)');
            // 数值显示 - 带背景卡片
            Row.borderRadius(10);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(value)}${unit}`);
            Text.fontSize(14);
            Text.fontColor('#667eea');
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        // 数值显示 - 带背景卡片
        Row.pop();
        // 标签和数值显示
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 滑块轨道 - 自定义样式
            Stack.create();
            // 滑块轨道 - 自定义样式
            Stack.width('100%');
            // 滑块轨道 - 自定义样式
            Stack.height(6);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 背景轨道
            Row.create();
            // 背景轨道
            Row.width('100%');
            // 背景轨道
            Row.height(6);
            // 背景轨道
            Row.backgroundColor('rgba(102, 126, 234, 0.15)');
            // 背景轨道
            Row.borderRadius(3);
        }, Row);
        // 背景轨道
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 进度填充
            Row.create();
            // 进度填充
            Row.width(`${((value - min) / (max - min)) * 100}%`);
            // 进度填充
            Row.height(6);
            // 进度填充
            Row.linearGradient({
                angle: 90,
                colors: [
                    ['#667eea', 0.0],
                    ['#764ba2', 1.0]
                ]
            });
            // 进度填充
            Row.borderRadius(3);
        }, Row);
        // 进度填充
        Row.pop();
        // 滑块轨道 - 自定义样式
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 实际滑块（透明，用于交互）
            Slider.create({
                value: value,
                min: min,
                max: max,
                step: 1,
                style: SliderStyle.OutSet
            });
            // 实际滑块（透明，用于交互）
            Slider.blockColor('transparent');
            // 实际滑块（透明，用于交互）
            Slider.trackColor('transparent');
            // 实际滑块（透明，用于交互）
            Slider.selectedColor('transparent');
            // 实际滑块（透明，用于交互）
            Slider.showSteps(false);
            // 实际滑块（透明，用于交互）
            Slider.showTips(false);
            // 实际滑块（透明，用于交互）
            Slider.width('100%');
            // 实际滑块（透明，用于交互）
            Slider.height(20);
            // 实际滑块（透明，用于交互）
            Slider.onChange(onChange);
        }, Slider);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
