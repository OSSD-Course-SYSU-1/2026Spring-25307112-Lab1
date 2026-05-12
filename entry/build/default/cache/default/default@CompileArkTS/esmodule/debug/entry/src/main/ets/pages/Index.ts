if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    currentSwiperIndex?: number;
    imageFilterTags?: Array<string>;
}
import { CAROUSEL_DATA_SOURCE, FILTER_OPTIONS, ORIGINAL_MATRIX } from "@normalized:N&&&entry/src/main/ets/constants/CommonConstants&";
import type { FilterOption } from "@normalized:N&&&entry/src/main/ets/constants/CommonConstants&";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__currentSwiperIndex = new ObservedPropertySimplePU(0, this, "currentSwiperIndex");
        this.__imageFilterTags = new ObservedPropertyObjectPU([], this, "imageFilterTags");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.currentSwiperIndex !== undefined) {
            this.currentSwiperIndex = params.currentSwiperIndex;
        }
        if (params.imageFilterTags !== undefined) {
            this.imageFilterTags = params.imageFilterTags;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentSwiperIndex.purgeDependencyOnElmtId(rmElmtId);
        this.__imageFilterTags.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentSwiperIndex.aboutToBeDeleted();
        this.__imageFilterTags.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // Tracks the current index of the Swiper
    private __currentSwiperIndex: ObservedPropertySimplePU<number>;
    get currentSwiperIndex() {
        return this.__currentSwiperIndex.get();
    }
    set currentSwiperIndex(newValue: number) {
        this.__currentSwiperIndex.set(newValue);
    }
    // Stores the filter "tag" (value) for EACH image independently.
    private __imageFilterTags: ObservedPropertyObjectPU<Array<string>>;
    get imageFilterTags() {
        return this.__imageFilterTags.get();
    }
    set imageFilterTags(newValue: Array<string>) {
        this.__imageFilterTags.set(newValue);
    }
    // [Start aboutToAppear]
    aboutToAppear(): void {
        // Initialize all images to 'original' filter.
        this.imageFilterTags = new Array<string>(CAROUSEL_DATA_SOURCE.length).fill('original');
    }
    // [End aboutToAppear]
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('100%');
            Column.width('100%');
            Column.backgroundColor({ "id": 125831062, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            Column.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Top Section: Image Carousel (Swiper)
            Column.create();
            // Top Section: Image Carousel (Swiper)
            Column.width('100%');
            // Top Section: Image Carousel (Swiper)
            Column.height('65%');
            // Top Section: Image Carousel (Swiper)
            Column.justifyContent(FlexAlign.Center);
            // Top Section: Image Carousel (Swiper)
            Column.padding({ left: 16, right: 16, top: 8 });
            // Top Section: Image Carousel (Swiper)
            Column.margin({ top: 45 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [Start swiperUsagePosition]
            Swiper.create();
            // [Start swiperUsagePosition]
            Swiper.onChange((index: number) => {
                // Update global index state when user swipes
                this.currentSwiperIndex = index;
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
                const imgRes = _item;
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
                    Image.create(imgRes);
                    // [Start imageUsagePosition]
                    Image.width('100%');
                    // [Start imageUsagePosition]
                    Image.height('100%');
                    // [Start imageUsagePosition]
                    Image.objectFit(ImageFit.Contain);
                    // [Start imageUsagePosition]
                    Image.borderRadius(16);
                    // [Start imageUsagePosition]
                    Image.colorFilter(this.getFilterByTag(this.imageFilterTags[index]));
                }, Image);
                // Container needed for individual scale animation
                Column.pop();
            };
            this.forEachUpdateFunction(elmtId, CAROUSEL_DATA_SOURCE, forEachItemGenFunction, (item: Resource, index: number) => index + '_' + JSON.stringify(item), true, true);
        }, ForEach);
        ForEach.pop();
        // [Start swiperUsagePosition]
        Swiper.pop();
        // Top Section: Image Carousel (Swiper)
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Bottom Section: Control Panel (Radios)
            Column.create();
            // Bottom Section: Control Panel (Radios)
            Column.layoutWeight(1);
            // Bottom Section: Control Panel (Radios)
            Column.padding(24);
            // Bottom Section: Control Panel (Radios)
            Column.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" });
            // Bottom Section: Control Panel (Radios)
            Column.borderRadius(16);
            // Bottom Section: Control Panel (Radios)
            Column.margin({
                left: 16,
                right: 16,
                top: 36,
                bottom: 16
            });
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
        // Bottom Section: Control Panel (Radios)
        Column.pop();
        Column.pop();
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
