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
            Column.padding(20);
            Column.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Header with title and reset button
            Row.create();
            // Header with title and reset button
            Row.width('100%');
            // Header with title and reset button
            Row.margin({ bottom: 16 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("参数调整");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel("重置");
            Button.fontSize(14);
            Button.fontColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Button.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Button.borderRadius(8);
            Button.height(32);
            Button.padding({ left: 12, right: 12 });
            Button.onClick(() => {
                if (this.onReset) {
                    this.onReset();
                }
            });
        }, Button);
        Button.pop();
        // Header with title and reset button
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
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Brightness
            Column.create();
            // Brightness
            Column.width('100%');
            // Brightness
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('亮度');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.brightnessValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.brightnessValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.brightnessValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Brightness
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Contrast
            Column.create();
            // Contrast
            Column.width('100%');
            // Contrast
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('对比度');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.contrastValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.contrastValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.contrastValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Contrast
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Saturation
            Column.create();
            // Saturation
            Column.width('100%');
            // Saturation
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('饱和度');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.saturationValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.saturationValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.saturationValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Saturation
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Hue
            Column.create();
            // Hue
            Column.width('100%');
            // Hue
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('色相');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.hueValue)}°`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.hueValue,
                min: 0,
                max: 360,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.hueValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Hue
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Warmth
            Column.create();
            // Warmth
            Column.width('100%');
            // Warmth
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('色温');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.warmthValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.warmthValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.warmthValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Warmth
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Exposure
            Column.create();
            // Exposure
            Column.width('100%');
            // Exposure
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('曝光');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.exposureValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.exposureValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.exposureValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Exposure
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Gamma
            Column.create();
            // Gamma
            Column.width('100%');
            // Gamma
            Column.padding({ top: 8, bottom: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('伽马');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${Math.round(this.gammaValue)}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.width(60);
            Text.textAlign(TextAlign.End);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Slider.create({
                value: this.gammaValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
            });
            Slider.blockColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.trackColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.selectedColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Slider.showSteps(false);
            Slider.showTips(true);
            Slider.width('100%');
            Slider.onChange((newValue: number) => {
                this.gammaValue = Math.round(newValue);
            });
        }, Slider);
        Row.pop();
        // Gamma
        Column.pop();
        Column.pop();
        // Scrollable slider list
        Scroll.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
