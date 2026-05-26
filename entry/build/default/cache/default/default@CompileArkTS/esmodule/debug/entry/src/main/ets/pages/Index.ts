if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    context?: common.UIAbilityContext;
    currentSwiperIndex?: number;
    imageList?: Array<ImageSource>;
    imageFilterTags?: Array<string>;
    imageAdjustParams?: Array<AdjustParams>;
    editMode?: EditMode;
    currentBrightness?: number;
    currentContrast?: number;
    currentSaturation?: number;
    currentHue?: number;
    currentWarmth?: number;
    currentExposure?: number;
    currentGamma?: number;
    scrollOffset?: number;
    MAX_IMAGE_HEIGHT?: number;
    MIN_IMAGE_HEIGHT?: number;
    IMAGE_SHRINK_RANGE?: number;
    scroller?: Scroller;
}
import { CAROUSEL_DATA_SOURCE, FILTER_OPTIONS, ORIGINAL_MATRIX, DEFAULT_ADJUST_PARAMS, generateAdjustMatrix } from "@normalized:N&&&entry/src/main/ets/constants/CommonConstants&";
import type { FilterOption, AdjustParams } from "@normalized:N&&&entry/src/main/ets/constants/CommonConstants&";
import { AdjustPanel } from "@normalized:N&&&entry/src/main/ets/components/AdjustPanel&";
import { ImagePickerUtil } from "@normalized:N&&&entry/src/main/ets/utils/ImagePickerUtil&";
import type common from "@ohos:app.ability.common";
// Edit mode type
type EditMode = 'preset' | 'adjust';
// Image source type - can be Resource or file URI string
type ImageSource = Resource | string;
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.context = getContext(this) as common.UIAbilityContext;
        this.__currentSwiperIndex = new ObservedPropertySimplePU(0, this, "currentSwiperIndex");
        this.__imageList = new ObservedPropertyObjectPU([], this, "imageList");
        this.__imageFilterTags = new ObservedPropertyObjectPU([], this, "imageFilterTags");
        this.__imageAdjustParams = new ObservedPropertyObjectPU([], this, "imageAdjustParams");
        this.__editMode = new ObservedPropertySimplePU('preset', this, "editMode");
        this.__currentBrightness = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.brightness, this, "currentBrightness");
        this.__currentContrast = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.contrast, this, "currentContrast");
        this.__currentSaturation = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.saturation, this, "currentSaturation");
        this.__currentHue = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.hue, this, "currentHue");
        this.__currentWarmth = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.warmth, this, "currentWarmth");
        this.__currentExposure = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.exposure, this, "currentExposure");
        this.__currentGamma = new ObservedPropertySimplePU(DEFAULT_ADJUST_PARAMS.gamma, this, "currentGamma");
        this.__scrollOffset = new ObservedPropertySimplePU(0, this, "scrollOffset");
        this.MAX_IMAGE_HEIGHT = 320;
        this.MIN_IMAGE_HEIGHT = 160;
        this.IMAGE_SHRINK_RANGE = 160;
        this.scroller = new Scroller();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.context !== undefined) {
            this.context = params.context;
        }
        if (params.currentSwiperIndex !== undefined) {
            this.currentSwiperIndex = params.currentSwiperIndex;
        }
        if (params.imageList !== undefined) {
            this.imageList = params.imageList;
        }
        if (params.imageFilterTags !== undefined) {
            this.imageFilterTags = params.imageFilterTags;
        }
        if (params.imageAdjustParams !== undefined) {
            this.imageAdjustParams = params.imageAdjustParams;
        }
        if (params.editMode !== undefined) {
            this.editMode = params.editMode;
        }
        if (params.currentBrightness !== undefined) {
            this.currentBrightness = params.currentBrightness;
        }
        if (params.currentContrast !== undefined) {
            this.currentContrast = params.currentContrast;
        }
        if (params.currentSaturation !== undefined) {
            this.currentSaturation = params.currentSaturation;
        }
        if (params.currentHue !== undefined) {
            this.currentHue = params.currentHue;
        }
        if (params.currentWarmth !== undefined) {
            this.currentWarmth = params.currentWarmth;
        }
        if (params.currentExposure !== undefined) {
            this.currentExposure = params.currentExposure;
        }
        if (params.currentGamma !== undefined) {
            this.currentGamma = params.currentGamma;
        }
        if (params.scrollOffset !== undefined) {
            this.scrollOffset = params.scrollOffset;
        }
        if (params.MAX_IMAGE_HEIGHT !== undefined) {
            this.MAX_IMAGE_HEIGHT = params.MAX_IMAGE_HEIGHT;
        }
        if (params.MIN_IMAGE_HEIGHT !== undefined) {
            this.MIN_IMAGE_HEIGHT = params.MIN_IMAGE_HEIGHT;
        }
        if (params.IMAGE_SHRINK_RANGE !== undefined) {
            this.IMAGE_SHRINK_RANGE = params.IMAGE_SHRINK_RANGE;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentSwiperIndex.purgeDependencyOnElmtId(rmElmtId);
        this.__imageList.purgeDependencyOnElmtId(rmElmtId);
        this.__imageFilterTags.purgeDependencyOnElmtId(rmElmtId);
        this.__imageAdjustParams.purgeDependencyOnElmtId(rmElmtId);
        this.__editMode.purgeDependencyOnElmtId(rmElmtId);
        this.__currentBrightness.purgeDependencyOnElmtId(rmElmtId);
        this.__currentContrast.purgeDependencyOnElmtId(rmElmtId);
        this.__currentSaturation.purgeDependencyOnElmtId(rmElmtId);
        this.__currentHue.purgeDependencyOnElmtId(rmElmtId);
        this.__currentWarmth.purgeDependencyOnElmtId(rmElmtId);
        this.__currentExposure.purgeDependencyOnElmtId(rmElmtId);
        this.__currentGamma.purgeDependencyOnElmtId(rmElmtId);
        this.__scrollOffset.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentSwiperIndex.aboutToBeDeleted();
        this.__imageList.aboutToBeDeleted();
        this.__imageFilterTags.aboutToBeDeleted();
        this.__imageAdjustParams.aboutToBeDeleted();
        this.__editMode.aboutToBeDeleted();
        this.__currentBrightness.aboutToBeDeleted();
        this.__currentContrast.aboutToBeDeleted();
        this.__currentSaturation.aboutToBeDeleted();
        this.__currentHue.aboutToBeDeleted();
        this.__currentWarmth.aboutToBeDeleted();
        this.__currentExposure.aboutToBeDeleted();
        this.__currentGamma.aboutToBeDeleted();
        this.__scrollOffset.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // Get context for image picker
    private context: common.UIAbilityContext;
    // Tracks the current index of the Swiper
    private __currentSwiperIndex: ObservedPropertySimplePU<number>;
    get currentSwiperIndex() {
        return this.__currentSwiperIndex.get();
    }
    set currentSwiperIndex(newValue: number) {
        this.__currentSwiperIndex.set(newValue);
    }
    // Dynamic image list - supports both Resource and URI
    private __imageList: ObservedPropertyObjectPU<Array<ImageSource>>;
    get imageList() {
        return this.__imageList.get();
    }
    set imageList(newValue: Array<ImageSource>) {
        this.__imageList.set(newValue);
    }
    // Stores the filter "tag" (value) for EACH image independently (preset mode)
    private __imageFilterTags: ObservedPropertyObjectPU<Array<string>>;
    get imageFilterTags() {
        return this.__imageFilterTags.get();
    }
    set imageFilterTags(newValue: Array<string>) {
        this.__imageFilterTags.set(newValue);
    }
    // Stores the adjustment parameters for EACH image independently (adjust mode)
    private __imageAdjustParams: ObservedPropertyObjectPU<Array<AdjustParams>>;
    get imageAdjustParams() {
        return this.__imageAdjustParams.get();
    }
    set imageAdjustParams(newValue: Array<AdjustParams>) {
        this.__imageAdjustParams.set(newValue);
    }
    // Current edit mode: preset filters or parameter adjustment
    private __editMode: ObservedPropertySimplePU<EditMode>;
    get editMode() {
        return this.__editMode.get();
    }
    set editMode(newValue: EditMode) {
        this.__editMode.set(newValue);
    }
    // Current image adjustment parameters (for @Link binding with AdjustPanel)
    private __currentBrightness: ObservedPropertySimplePU<number>;
    get currentBrightness() {
        return this.__currentBrightness.get();
    }
    set currentBrightness(newValue: number) {
        this.__currentBrightness.set(newValue);
    }
    private __currentContrast: ObservedPropertySimplePU<number>;
    get currentContrast() {
        return this.__currentContrast.get();
    }
    set currentContrast(newValue: number) {
        this.__currentContrast.set(newValue);
    }
    private __currentSaturation: ObservedPropertySimplePU<number>;
    get currentSaturation() {
        return this.__currentSaturation.get();
    }
    set currentSaturation(newValue: number) {
        this.__currentSaturation.set(newValue);
    }
    private __currentHue: ObservedPropertySimplePU<number>;
    get currentHue() {
        return this.__currentHue.get();
    }
    set currentHue(newValue: number) {
        this.__currentHue.set(newValue);
    }
    private __currentWarmth: ObservedPropertySimplePU<number>;
    get currentWarmth() {
        return this.__currentWarmth.get();
    }
    set currentWarmth(newValue: number) {
        this.__currentWarmth.set(newValue);
    }
    private __currentExposure: ObservedPropertySimplePU<number>;
    get currentExposure() {
        return this.__currentExposure.get();
    }
    set currentExposure(newValue: number) {
        this.__currentExposure.set(newValue);
    }
    private __currentGamma: ObservedPropertySimplePU<number>;
    get currentGamma() {
        return this.__currentGamma.get();
    }
    set currentGamma(newValue: number) {
        this.__currentGamma.set(newValue);
    }
    // Scroll related states for sticky image effect
    private __scrollOffset: ObservedPropertySimplePU<number>;
    get scrollOffset() {
        return this.__scrollOffset.get();
    }
    set scrollOffset(newValue: number) {
        this.__scrollOffset.set(newValue);
    }
    // Image height constraints
    private readonly MAX_IMAGE_HEIGHT: number; // Maximum image height
    private readonly MIN_IMAGE_HEIGHT: number; // Minimum image height when sticky
    private readonly IMAGE_SHRINK_RANGE: number; // Range for image to shrink (MAX - MIN)
    // Scroller controller
    private scroller: Scroller;
    // [Start aboutToAppear]
    aboutToAppear(): void {
        // Initialize with default images from resources
        this.imageList = [...CAROUSEL_DATA_SOURCE];
        // Initialize all images to 'original' filter.
        this.imageFilterTags = new Array<string>(this.imageList.length).fill('original');
        // Initialize all images with default adjustment parameters
        this.initAdjustParams();
    }
    // [End aboutToAppear]
    // Initialize adjustment parameters array
    private initAdjustParams(): void {
        const defaultParams: AdjustParams = {
            brightness: DEFAULT_ADJUST_PARAMS.brightness,
            contrast: DEFAULT_ADJUST_PARAMS.contrast,
            saturation: DEFAULT_ADJUST_PARAMS.saturation,
            hue: DEFAULT_ADJUST_PARAMS.hue,
            warmth: DEFAULT_ADJUST_PARAMS.warmth,
            exposure: DEFAULT_ADJUST_PARAMS.exposure,
            gamma: DEFAULT_ADJUST_PARAMS.gamma
        };
        this.imageAdjustParams = [];
        for (let i = 0; i < this.imageList.length; i++) {
            this.imageAdjustParams.push({
                brightness: defaultParams.brightness,
                contrast: defaultParams.contrast,
                saturation: defaultParams.saturation,
                hue: defaultParams.hue,
                warmth: defaultParams.warmth,
                exposure: defaultParams.exposure,
                gamma: defaultParams.gamma
            });
        }
        // Sync current params from first image
        this.syncCurrentParams();
    }
    // Sync current params from imageAdjustParams array to currentXxx variables
    private syncCurrentParams(): void {
        if (this.currentSwiperIndex < this.imageAdjustParams.length) {
            const params = this.imageAdjustParams[this.currentSwiperIndex];
            this.currentBrightness = params.brightness;
            this.currentContrast = params.contrast;
            this.currentSaturation = params.saturation;
            this.currentHue = params.hue;
            this.currentWarmth = params.warmth;
            this.currentExposure = params.exposure;
            this.currentGamma = params.gamma;
        }
    }
    // Save current params back to imageAdjustParams array
    private saveCurrentParams(): void {
        if (this.currentSwiperIndex < this.imageAdjustParams.length) {
            this.imageAdjustParams[this.currentSwiperIndex] = {
                brightness: this.currentBrightness,
                contrast: this.currentContrast,
                saturation: this.currentSaturation,
                hue: this.currentHue,
                warmth: this.currentWarmth,
                exposure: this.currentExposure,
                gamma: this.currentGamma
            };
        }
    }
    // Calculate dynamic image height based on scroll offset
    private calculateImageHeight(): number {
        if (this.scrollOffset <= 0) {
            return this.MAX_IMAGE_HEIGHT;
        }
        // Calculate shrink progress (0 to 1)
        const shrinkProgress = Math.min(this.scrollOffset / this.IMAGE_SHRINK_RANGE, 1);
        // Linear interpolation between MAX and MIN
        const height = this.MAX_IMAGE_HEIGHT - (this.MAX_IMAGE_HEIGHT - this.MIN_IMAGE_HEIGHT) * shrinkProgress;
        return Math.max(height, this.MIN_IMAGE_HEIGHT);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Top });
            Stack.height('100%');
            Stack.width('100%');
            Stack.backgroundColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Stack.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底层：滚动内容区域（参数调整区域）
            Scroll.create(this.scroller);
            // 底层：滚动内容区域（参数调整区域）
            Scroll.width('100%');
            // 底层：滚动内容区域（参数调整区域）
            Scroll.height('100%');
            // 底层：滚动内容区域（参数调整区域）
            Scroll.scrollBar(BarState.Off);
            // 底层：滚动内容区域（参数调整区域）
            Scroll.edgeEffect(EdgeEffect.Spring);
            // 底层：滚动内容区域（参数调整区域）
            Scroll.onScroll(() => {
                // Update scroll offset
                this.scrollOffset = this.scroller.currentOffset().yOffset;
            });
            // 底层：滚动内容区域（参数调整区域）
            Scroll.onScrollEdge((side: Edge) => {
                // Reset scroll offset when reaching top edge
                if (side === Edge.Top) {
                    this.scrollOffset = 0;
                }
            });
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 占位区域，为顶部的图片区域留出空间
            Column.create();
            // 占位区域，为顶部的图片区域留出空间
            Column.width('100%');
            // 占位区域，为顶部的图片区域留出空间
            Column.height(this.calculateImageHeight() + 100);
        }, Column);
        // 占位区域，为顶部的图片区域留出空间
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Mode Switch Tabs
            Row.create();
            // Mode Switch Tabs
            Row.width('100%');
            // Mode Switch Tabs
            Row.justifyContent(FlexAlign.Center);
            // Mode Switch Tabs
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('预设滤镜');
            Text.fontSize(16);
            Text.fontWeight(this.editMode === 'preset' ? FontWeight.Bold : FontWeight.Normal);
            Text.fontColor(this.editMode === 'preset'
                ? { "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" } : { "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.padding({ left: 20, right: 20, top: 8, bottom: 8 });
            Text.borderRadius(20);
            Text.backgroundColor(this.editMode === 'preset'
                ? { "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" } : 'transparent');
            Text.onClick(() => {
                this.editMode = 'preset';
            });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('参数调整');
            Text.fontSize(16);
            Text.fontWeight(this.editMode === 'adjust' ? FontWeight.Bold : FontWeight.Normal);
            Text.fontColor(this.editMode === 'adjust'
                ? { "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" } : { "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.padding({ left: 20, right: 20, top: 8, bottom: 8 });
            Text.borderRadius(20);
            Text.backgroundColor(this.editMode === 'adjust'
                ? { "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" } : 'transparent');
            Text.onClick(() => {
                this.editMode = 'adjust';
            });
        }, Text);
        Text.pop();
        // Mode Switch Tabs
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Bottom Section: Control Panel
            Column.create();
            // Bottom Section: Control Panel
            Column.width('100%');
            // Bottom Section: Control Panel
            Column.padding({ left: 16, right: 16, bottom: 16 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.editMode === 'preset') {
                this.ifElseBranchUpdateFunction(0, () => {
                    // Preset Filter Panel
                    this.PresetFilterPanel.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new 
                                // Parameter Adjustment Panel - use @Link for two-way binding
                                AdjustPanel(this, {
                                    brightnessValue: this.__currentBrightness,
                                    contrastValue: this.__currentContrast,
                                    saturationValue: this.__currentSaturation,
                                    hueValue: this.__currentHue,
                                    warmthValue: this.__currentWarmth,
                                    exposureValue: this.__currentExposure,
                                    gammaValue: this.__currentGamma,
                                    onReset: () => {
                                        this.resetCurrentParams();
                                    }
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 204, col: 15 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        brightnessValue: this.currentBrightness,
                                        contrastValue: this.currentContrast,
                                        saturationValue: this.currentSaturation,
                                        hueValue: this.currentHue,
                                        warmthValue: this.currentWarmth,
                                        exposureValue: this.currentExposure,
                                        gammaValue: this.currentGamma,
                                        onReset: () => {
                                            this.resetCurrentParams();
                                        }
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "AdjustPanel" });
                    }
                });
            }
        }, If);
        If.pop();
        // Bottom Section: Control Panel
        Column.pop();
        Column.pop();
        // 底层：滚动内容区域（参数调整区域）
        Scroll.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶层：固定的图片区域（吸顶效果）
            Column.create();
            // 顶层：固定的图片区域（吸顶效果）
            Column.width('100%');
            // 顶层：固定的图片区域（吸顶效果）
            Column.backgroundColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Top status bar area
            Row.create();
            // Top status bar area
            Row.width('100%');
            // Top status bar area
            Row.height(45);
            // Top status bar area
            Row.backgroundColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Row);
        // Top status bar area
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Image Carousel Section
            Column.create();
            // Image Carousel Section
            Column.width('100%');
            // Image Carousel Section
            Column.height(this.calculateImageHeight());
            // Image Carousel Section
            Column.justifyContent(FlexAlign.Center);
            // Image Carousel Section
            Column.padding({ left: 16, right: 16, top: 8 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [Start swiperUsagePosition]
            Swiper.create();
            // [Start swiperUsagePosition]
            Swiper.onChange((index: number) => {
                // Save current params before switching
                this.saveCurrentParams();
                // Update global index state when user swipes
                this.currentSwiperIndex = index;
                // Sync params from new image
                this.syncCurrentParams();
            });
            // [Start swiperUsagePosition]
            Swiper.width('100%');
            // [Start swiperUsagePosition]
            Swiper.height('100%');
            // [Start swiperUsagePosition]
            Swiper.itemSpace(20);
            // [Start swiperUsagePosition]
            Swiper.indicator(Indicator.dot()
                .selectedColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" })
                .color({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" }));
            // [Start swiperUsagePosition]
            Swiper.loop(false);
            // [Start swiperUsagePosition]
            Swiper.effectMode(EdgeEffect.Spring);
        }, Swiper);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = (_item, index: number) => {
                const imgSource = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // Container needed for individual scale animation
                    Column.create();
                    Context.animation({
                        duration: 300,
                        curve: Curve.FastOutSlowIn // Smooth physics curve
                    });
                    // Container needed for individual scale animation
                    Column.justifyContent(FlexAlign.Center);
                    // Container needed for individual scale animation
                    Column.scale({
                        x: this.currentSwiperIndex === index ? 1.0 : 0.9,
                        y: this.currentSwiperIndex === index ? 1.0 : 0.9
                    });
                    Context.animation(null);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // [Start imageUsagePosition]
                    Image.create(imgSource);
                    // [Start imageUsagePosition]
                    Image.width('100%');
                    // [Start imageUsagePosition]
                    Image.height('100%');
                    // [Start imageUsagePosition]
                    Image.objectFit(ImageFit.Contain);
                    // [Start imageUsagePosition]
                    Image.borderRadius(16);
                    // [Start imageUsagePosition]
                    Image.colorFilter(this.getCurrentFilter(index));
                }, Image);
                // Container needed for individual scale animation
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, this.imageList, forEachItemGenFunction, (item: ImageSource, index: number) => index + '_' + (typeof item === 'string' ? item : 'resource'), true, true);
        }, ForEach);
        ForEach.pop();
        // [Start swiperUsagePosition]
        Swiper.pop();
        // Image Carousel Section
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Image counter and add button
            Row.create();
            // Image counter and add button
            Row.width('100%');
            // Image counter and add button
            Row.padding({ left: 16, right: 16 });
            // Image counter and add button
            Row.margin({ top: 8, bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`图片 ${this.currentSwiperIndex + 1} / ${this.imageList.length}`);
            Text.fontSize(14);
            Text.fontColor({ "id": 125830983, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild({ type: ButtonType.Normal });
            Button.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Button.borderRadius(20);
            Button.height(36);
            Button.padding({ left: 16, right: 16 });
            Button.onClick(() => {
                this.pickImages();
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('+');
            Text.fontSize(18);
            Text.fontColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('添加图片');
            Text.fontSize(14);
            Text.fontColor({ "id": 125830986, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Text.margin({ left: 4 });
        }, Text);
        Text.pop();
        Row.pop();
        Button.pop();
        // Image counter and add button
        Row.pop();
        // 顶层：固定的图片区域（吸顶效果）
        Column.pop();
        Stack.pop();
    }
    // Preset Filter Panel Builder
    PresetFilterPanel(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.padding(24);
            Column.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Column.borderRadius(16);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("Apply Filter");
            Text.fontSize(18);
            Text.fontWeight(FontWeight.Bold);
            Text.width('100%');
            Text.margin({ bottom: 16 });
            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [Start radioUsagePosition]
            Grid.create();
            // [Start radioUsagePosition]
            Grid.columnsTemplate('1fr 1fr 1fr');
            // [Start radioUsagePosition]
            Grid.rowsGap(16);
            // [Start radioUsagePosition]
            Grid.columnsGap(10);
            // [Start radioUsagePosition]
            Grid.width('100%');
            // [Start radioUsagePosition]
            Grid.layoutWeight(1);
            // [Start radioUsagePosition]
            Grid.scrollBar(BarState.Off);
            // [Start radioUsagePosition]
            Grid.edgeEffect(EdgeEffect.Spring);
        }, Grid);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                {
                    const itemCreation2 = (elmtId, isInitialRender) => {
                        GridItem.create(() => { }, false);
                    };
                    const observedDeepRender = () => {
                        this.observeComponentCreation2(itemCreation2, GridItem);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Row.create();
                            Row.width('100%');
                        }, Row);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Radio.create({ value: item.value, group: 'filterGroup' });
                            Radio.checked(this.imageFilterTags[this.currentSwiperIndex] === item.value);
                            Radio.onChange((isChecked: boolean) => {
                                if (isChecked) {
                                    this.imageFilterTags[this.currentSwiperIndex] = item.value;
                                }
                            });
                        }, Radio);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create(item.label);
                            Text.fontSize(14);
                            Text.fontColor({ "id": 125830982, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
                            Text.margin({ left: 4 });
                            Text.onClick(() => {
                                this.imageFilterTags[this.currentSwiperIndex] = item.value;
                            });
                        }, Text);
                        Text.pop();
                        Row.pop();
                        GridItem.pop();
                    };
                    observedDeepRender();
                }
            };
            this.forEachUpdateFunction(elmtId, FILTER_OPTIONS, forEachItemGenFunction, (item: FilterOption, index: number) => index + '_' + JSON.stringify(item), false, true);
        }, ForEach);
        ForEach.pop();
        // [Start radioUsagePosition]
        Grid.pop();
        Column.pop();
    }
    // Pick images from gallery
    private async pickImages(): Promise<void> {
        const uris = await ImagePickerUtil.pickImages(this.context, 10);
        if (uris.length > 0) {
            // Add new images to the list
            for (let i = 0; i < uris.length; i++) {
                this.imageList.push(uris[i]);
                this.imageFilterTags.push('original');
                this.imageAdjustParams.push({
                    brightness: DEFAULT_ADJUST_PARAMS.brightness,
                    contrast: DEFAULT_ADJUST_PARAMS.contrast,
                    saturation: DEFAULT_ADJUST_PARAMS.saturation,
                    hue: DEFAULT_ADJUST_PARAMS.hue,
                    warmth: DEFAULT_ADJUST_PARAMS.warmth,
                    exposure: DEFAULT_ADJUST_PARAMS.exposure,
                    gamma: DEFAULT_ADJUST_PARAMS.gamma
                });
            }
        }
    }
    // Reset current image parameters to default (triggers reactive update)
    private resetCurrentParams(): void {
        const currentIndex = this.currentSwiperIndex;
        // Reset to default values
        const defaultParams: AdjustParams = {
            brightness: DEFAULT_ADJUST_PARAMS.brightness,
            contrast: DEFAULT_ADJUST_PARAMS.contrast,
            saturation: DEFAULT_ADJUST_PARAMS.saturation,
            hue: DEFAULT_ADJUST_PARAMS.hue,
            warmth: DEFAULT_ADJUST_PARAMS.warmth,
            exposure: DEFAULT_ADJUST_PARAMS.exposure,
            gamma: DEFAULT_ADJUST_PARAMS.gamma
        };
        // Update imageAdjustParams array
        this.imageAdjustParams[currentIndex] = defaultParams;
        // Update currentXxx variables for @Link binding (this will update sliders)
        this.currentBrightness = defaultParams.brightness;
        this.currentContrast = defaultParams.contrast;
        this.currentSaturation = defaultParams.saturation;
        this.currentHue = defaultParams.hue;
        this.currentWarmth = defaultParams.warmth;
        this.currentExposure = defaultParams.exposure;
        this.currentGamma = defaultParams.gamma;
    }
    // Get current filter based on edit mode
    private getCurrentFilter(index: number): ColorFilter | number[] {
        if (this.editMode === 'preset') {
            return this.getFilterByTag(this.imageFilterTags[index]);
        }
        else {
            // For current image, use currentXxx variables (for real-time preview)
            if (index === this.currentSwiperIndex) {
                return generateAdjustMatrix({
                    brightness: this.currentBrightness,
                    contrast: this.currentContrast,
                    saturation: this.currentSaturation,
                    hue: this.currentHue,
                    warmth: this.currentWarmth,
                    exposure: this.currentExposure,
                    gamma: this.currentGamma
                });
            }
            else {
                return generateAdjustMatrix(this.imageAdjustParams[index]);
            }
        }
    }
    // [Start getFilterByTagFunc]
    // Helper: Retrieves the actual filter object based on the tag string
    private getFilterByTag(tag: string): ColorFilter | number[] {
        const option = FILTER_OPTIONS.find(opt => opt.value === tag);
        return option ? option.filter : ORIGINAL_MATRIX;
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.imagefilter", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
