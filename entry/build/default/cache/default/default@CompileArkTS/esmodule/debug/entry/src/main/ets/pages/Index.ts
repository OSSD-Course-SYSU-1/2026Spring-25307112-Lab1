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
            Stack.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底层：渐变背景
            Column.create();
            // 底层：渐变背景
            Column.width('100%');
            // 底层：渐变背景
            Column.height('100%');
            // 底层：渐变背景
            Column.linearGradient({
                angle: 180,
                colors: [
                    ['#f8f9fa', 0.0],
                    ['#e9ecef', 0.5],
                    ['#dee2e6', 1.0]
                ]
            });
        }, Column);
        // 底层：渐变背景
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 中层：滚动内容区域（参数调整区域）
            Scroll.create(this.scroller);
            // 中层：滚动内容区域（参数调整区域）
            Scroll.width('100%');
            // 中层：滚动内容区域（参数调整区域）
            Scroll.height('100%');
            // 中层：滚动内容区域（参数调整区域）
            Scroll.scrollBar(BarState.Off);
            // 中层：滚动内容区域（参数调整区域）
            Scroll.edgeEffect(EdgeEffect.Spring);
            // 中层：滚动内容区域（参数调整区域）
            Scroll.onScroll(() => {
                // Update scroll offset
                this.scrollOffset = this.scroller.currentOffset().yOffset;
            });
            // 中层：滚动内容区域（参数调整区域）
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
            // Mode Switch Tabs - 美化的标签切换
            Row.create();
            // Mode Switch Tabs - 美化的标签切换
            Row.width('100%');
            // Mode Switch Tabs - 美化的标签切换
            Row.justifyContent(FlexAlign.Center);
            // Mode Switch Tabs - 美化的标签切换
            Row.margin({ bottom: 16 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 预设滤镜标签
            Column.create();
            Context.animation({
                duration: 300,
                curve: Curve.FastOutSlowIn
            });
            // 预设滤镜标签
            Column.padding({ left: 24, right: 24, top: 12, bottom: 12 });
            // 预设滤镜标签
            Column.borderRadius(24);
            // 预设滤镜标签
            Column.backgroundColor(this.editMode === 'preset' ? '#ffffff' : 'transparent');
            // 预设滤镜标签
            Column.shadow(this.editMode === 'preset' ? {
                radius: 12,
                color: 'rgba(102, 126, 234, 0.2)',
                offsetX: 0,
                offsetY: 4
            } : { radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 });
            // 预设滤镜标签
            Column.onClick(() => {
                this.editMode = 'preset';
            });
            Context.animation(null);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('🎨 预设滤镜');
            Text.fontSize(15);
            Text.fontWeight(this.editMode === 'preset' ? FontWeight.Bold : FontWeight.Medium);
            Text.fontColor(this.editMode === 'preset' ? '#667eea' : '#8e9aaf');
        }, Text);
        Text.pop();
        // 预设滤镜标签
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 参数调整标签
            Column.create();
            Context.animation({
                duration: 300,
                curve: Curve.FastOutSlowIn
            });
            // 参数调整标签
            Column.padding({ left: 24, right: 24, top: 12, bottom: 12 });
            // 参数调整标签
            Column.borderRadius(24);
            // 参数调整标签
            Column.backgroundColor(this.editMode === 'adjust' ? '#ffffff' : 'transparent');
            // 参数调整标签
            Column.shadow(this.editMode === 'adjust' ? {
                radius: 12,
                color: 'rgba(102, 126, 234, 0.2)',
                offsetX: 0,
                offsetY: 4
            } : { radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 });
            // 参数调整标签
            Column.onClick(() => {
                this.editMode = 'adjust';
            });
            Context.animation(null);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('⚙️ 参数调整');
            Text.fontSize(15);
            Text.fontWeight(this.editMode === 'adjust' ? FontWeight.Bold : FontWeight.Medium);
            Text.fontColor(this.editMode === 'adjust' ? '#667eea' : '#8e9aaf');
        }, Text);
        Text.pop();
        // 参数调整标签
        Column.pop();
        // Mode Switch Tabs - 美化的标签切换
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
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/Index.ets", line: 235, col: 15 });
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
        // 中层：滚动内容区域（参数调整区域）
        Scroll.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶层：固定的图片区域（吸顶效果）
            Column.create();
            // 顶层：固定的图片区域（吸顶效果）
            Column.width('100%');
            // 顶层：固定的图片区域（吸顶效果）
            Column.linearGradient({
                angle: 180,
                colors: [
                    ['rgba(255, 255, 255, 0.98)', 0.0],
                    ['rgba(255, 255, 255, 0.95)', 1.0]
                ]
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Top status bar area - 渐变背景
            Row.create();
            // Top status bar area - 渐变背景
            Row.width('100%');
            // Top status bar area - 渐变背景
            Row.height(45);
            // Top status bar area - 渐变背景
            Row.linearGradient({
                angle: 90,
                colors: [
                    ['rgba(102, 126, 234, 0.95)', 0.0],
                    ['rgba(118, 75, 162, 0.95)', 1.0]
                ]
            });
        }, Row);
        // Top status bar area - 渐变背景
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
                .selectedColor('#667eea')
                .color('rgba(102, 126, 234, 0.3)'));
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
                    Stack.create();
                }, Stack);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // 图片阴影层
                    Column.create();
                    // 图片阴影层
                    Column.width('100%');
                    // 图片阴影层
                    Column.height('100%');
                    // 图片阴影层
                    Column.backgroundColor('rgba(0, 0, 0, 0.1)');
                    // 图片阴影层
                    Column.blur(20);
                    // 图片阴影层
                    Column.offset({ y: 10 });
                }, Column);
                // 图片阴影层
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    // 主图片
                    Image.create(imgSource);
                    // 主图片
                    Image.width('100%');
                    // 主图片
                    Image.height('100%');
                    // 主图片
                    Image.objectFit(ImageFit.Contain);
                    // 主图片
                    Image.borderRadius(20);
                    // 主图片
                    Image.colorFilter(this.getCurrentFilter(index));
                }, Image);
                // [Start imageUsagePosition]
                Stack.pop();
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
            // Image counter and add button - 美化的按钮样式
            Row.create();
            // Image counter and add button - 美化的按钮样式
            Row.width('100%');
            // Image counter and add button - 美化的按钮样式
            Row.padding({ left: 16, right: 16 });
            // Image counter and add button - 美化的按钮样式
            Row.margin({ top: 12, bottom: 12 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 图片计数器 - 添加背景卡片
            Row.create();
            // 图片计数器 - 添加背景卡片
            Row.padding({ left: 16, right: 16, top: 8, bottom: 8 });
            // 图片计数器 - 添加背景卡片
            Row.backgroundColor('#ffffff');
            // 图片计数器 - 添加背景卡片
            Row.borderRadius(20);
            // 图片计数器 - 添加背景卡片
            Row.shadow({
                radius: 8,
                color: 'rgba(0, 0, 0, 0.08)',
                offsetX: 0,
                offsetY: 2
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`📸 图片 ${this.currentSwiperIndex + 1} / ${this.imageList.length}`);
            Text.fontSize(14);
            Text.fontColor('#667eea');
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        // 图片计数器 - 添加背景卡片
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 添加图片按钮 - 渐变背景
            Button.createWithChild({ type: ButtonType.Normal });
            // 添加图片按钮 - 渐变背景
            Button.linearGradient({
                angle: 90,
                colors: [
                    ['#667eea', 0.0],
                    ['#764ba2', 1.0]
                ]
            });
            // 添加图片按钮 - 渐变背景
            Button.borderRadius(24);
            // 添加图片按钮 - 渐变背景
            Button.height(40);
            // 添加图片按钮 - 渐变背景
            Button.padding({ left: 20, right: 20 });
            // 添加图片按钮 - 渐变背景
            Button.shadow({
                radius: 12,
                color: 'rgba(102, 126, 234, 0.4)',
                offsetX: 0,
                offsetY: 4
            });
            // 添加图片按钮 - 渐变背景
            Button.onClick(() => {
                this.pickImages();
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('+');
            Text.fontSize(20);
            Text.fontColor('#ffffff');
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('添加图片');
            Text.fontSize(14);
            Text.fontColor('#ffffff');
            Text.fontWeight(FontWeight.Medium);
            Text.margin({ left: 6 });
        }, Text);
        Text.pop();
        Row.pop();
        // 添加图片按钮 - 渐变背景
        Button.pop();
        // Image counter and add button - 美化的按钮样式
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
            // 标题栏
            Row.create();
            // 标题栏
            Row.width('100%');
            // 标题栏
            Row.margin({ bottom: 20 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('✨ 应用滤镜');
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#2d3748');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 当前滤镜指示
            Text.create(this.getCurrentFilterName());
            // 当前滤镜指示
            Text.fontSize(12);
            // 当前滤镜指示
            Text.fontColor('#667eea');
            // 当前滤镜指示
            Text.fontWeight(FontWeight.Medium);
            // 当前滤镜指示
            Text.padding({ left: 12, right: 12, top: 6, bottom: 6 });
            // 当前滤镜指示
            Text.backgroundColor('rgba(102, 126, 234, 0.1)');
            // 当前滤镜指示
            Text.borderRadius(12);
        }, Text);
        // 当前滤镜指示
        Text.pop();
        // 标题栏
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [Start radioUsagePosition]
            Grid.create();
            // [Start radioUsagePosition]
            Grid.columnsTemplate('1fr 1fr 1fr');
            // [Start radioUsagePosition]
            Grid.rowsGap(16);
            // [Start radioUsagePosition]
            Grid.columnsGap(12);
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
            const forEachItemGenFunction = (_item, index: number) => {
                const item = _item;
                {
                    const itemCreation2 = (elmtId, isInitialRender) => {
                        GridItem.create(() => { }, false);
                    };
                    const observedDeepRender = () => {
                        this.observeComponentCreation2(itemCreation2, GridItem);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            // 滤镜选项卡片
                            Column.create();
                            Context.animation({
                                duration: 250,
                                curve: Curve.FastOutSlowIn
                            });
                            // 滤镜选项卡片
                            Column.width('100%');
                            // 滤镜选项卡片
                            Column.height(80);
                            // 滤镜选项卡片
                            Column.justifyContent(FlexAlign.Center);
                            // 滤镜选项卡片
                            Column.alignItems(HorizontalAlign.Center);
                            // 滤镜选项卡片
                            Column.backgroundColor(this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#ffffff' : 'rgba(255, 255, 255, 0.6)');
                            // 滤镜选项卡片
                            Column.borderRadius(16);
                            // 滤镜选项卡片
                            Column.border({
                                width: this.imageFilterTags[this.currentSwiperIndex] === item.value ? 2 : 1,
                                color: this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#667eea' : 'rgba(102, 126, 234, 0.2)'
                            });
                            // 滤镜选项卡片
                            Column.shadow(this.imageFilterTags[this.currentSwiperIndex] === item.value ? {
                                radius: 16,
                                color: 'rgba(102, 126, 234, 0.25)',
                                offsetX: 0,
                                offsetY: 6
                            } : {
                                radius: 4,
                                color: 'rgba(0, 0, 0, 0.05)',
                                offsetX: 0,
                                offsetY: 2
                            });
                            // 滤镜选项卡片
                            Column.onClick(() => {
                                this.imageFilterTags[this.currentSwiperIndex] = item.value;
                            });
                            Context.animation(null);
                        }, Column);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            // 图标或装饰
                            Text.create(this.getFilterIcon(item.value));
                            // 图标或装饰
                            Text.fontSize(24);
                            // 图标或装饰
                            Text.margin({ bottom: 8 });
                        }, Text);
                        // 图标或装饰
                        Text.pop();
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            // 滤镜名称
                            Text.create(item.label);
                            // 滤镜名称
                            Text.fontSize(13);
                            // 滤镜名称
                            Text.fontColor(this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#667eea' : '#4a5568');
                            // 滤镜名称
                            Text.fontWeight(this.imageFilterTags[this.currentSwiperIndex] === item.value ? FontWeight.Bold : FontWeight.Medium);
                        }, Text);
                        // 滤镜名称
                        Text.pop();
                        // 滤镜选项卡片
                        Column.pop();
                        GridItem.pop();
                    };
                    observedDeepRender();
                }
            };
            this.forEachUpdateFunction(elmtId, FILTER_OPTIONS, forEachItemGenFunction, (item: FilterOption, index: number) => index + '_' + JSON.stringify(item), true, true);
        }, ForEach);
        ForEach.pop();
        // [Start radioUsagePosition]
        Grid.pop();
        Column.pop();
    }
    // 获取当前滤镜名称
    private getCurrentFilterName(): string {
        const currentTag = this.imageFilterTags[this.currentSwiperIndex];
        const option = FILTER_OPTIONS.find(opt => opt.value === currentTag);
        return option ? option.label : 'Original';
    }
    // 获取滤镜图标
    private getFilterIcon(value: string): string {
        const iconMap: Record<string, string> = {
            'original': '📷',
            'retro': '🎞️',
            'invert': '🔄',
            'enhance': '✨',
            'whitening': '💫',
            'sepia': '🎨',
            'cool': '❄️',
            'warm': '☀️',
            'contrast': '⚡',
            'swap': '🌈',
            'posterize': '🎭',
            'nightvision': '🌙',
            'vintage': '📜'
        };
        return iconMap[value] || '🎨';
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
