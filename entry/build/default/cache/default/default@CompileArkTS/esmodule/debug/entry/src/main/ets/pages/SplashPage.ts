if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface SplashPage_Params {
    logoScale?: number;
    logoOpacity?: number;
    titleOpacity?: number;
    titleTranslateY?: number;
    subtitleOpacity?: number;
    progressWidth?: number;
    progressOpacity?: number;
    circle1Scale?: number;
    circle2Scale?: number;
    circle3Scale?: number;
    bgGradientOffset?: number;
}
import router from "@ohos:router";
class SplashPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__logoScale = new ObservedPropertySimplePU(0.3, this, "logoScale");
        this.__logoOpacity = new ObservedPropertySimplePU(0, this, "logoOpacity");
        this.__titleOpacity = new ObservedPropertySimplePU(0, this, "titleOpacity");
        this.__titleTranslateY = new ObservedPropertySimplePU(30, this, "titleTranslateY");
        this.__subtitleOpacity = new ObservedPropertySimplePU(0, this, "subtitleOpacity");
        this.__progressWidth = new ObservedPropertySimplePU(0, this, "progressWidth");
        this.__progressOpacity = new ObservedPropertySimplePU(0, this, "progressOpacity");
        this.__circle1Scale = new ObservedPropertySimplePU(0, this, "circle1Scale");
        this.__circle2Scale = new ObservedPropertySimplePU(0, this, "circle2Scale");
        this.__circle3Scale = new ObservedPropertySimplePU(0, this, "circle3Scale");
        this.__bgGradientOffset = new ObservedPropertySimplePU(0, this, "bgGradientOffset");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: SplashPage_Params) {
        if (params.logoScale !== undefined) {
            this.logoScale = params.logoScale;
        }
        if (params.logoOpacity !== undefined) {
            this.logoOpacity = params.logoOpacity;
        }
        if (params.titleOpacity !== undefined) {
            this.titleOpacity = params.titleOpacity;
        }
        if (params.titleTranslateY !== undefined) {
            this.titleTranslateY = params.titleTranslateY;
        }
        if (params.subtitleOpacity !== undefined) {
            this.subtitleOpacity = params.subtitleOpacity;
        }
        if (params.progressWidth !== undefined) {
            this.progressWidth = params.progressWidth;
        }
        if (params.progressOpacity !== undefined) {
            this.progressOpacity = params.progressOpacity;
        }
        if (params.circle1Scale !== undefined) {
            this.circle1Scale = params.circle1Scale;
        }
        if (params.circle2Scale !== undefined) {
            this.circle2Scale = params.circle2Scale;
        }
        if (params.circle3Scale !== undefined) {
            this.circle3Scale = params.circle3Scale;
        }
        if (params.bgGradientOffset !== undefined) {
            this.bgGradientOffset = params.bgGradientOffset;
        }
    }
    updateStateVars(params: SplashPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__logoScale.purgeDependencyOnElmtId(rmElmtId);
        this.__logoOpacity.purgeDependencyOnElmtId(rmElmtId);
        this.__titleOpacity.purgeDependencyOnElmtId(rmElmtId);
        this.__titleTranslateY.purgeDependencyOnElmtId(rmElmtId);
        this.__subtitleOpacity.purgeDependencyOnElmtId(rmElmtId);
        this.__progressWidth.purgeDependencyOnElmtId(rmElmtId);
        this.__progressOpacity.purgeDependencyOnElmtId(rmElmtId);
        this.__circle1Scale.purgeDependencyOnElmtId(rmElmtId);
        this.__circle2Scale.purgeDependencyOnElmtId(rmElmtId);
        this.__circle3Scale.purgeDependencyOnElmtId(rmElmtId);
        this.__bgGradientOffset.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__logoScale.aboutToBeDeleted();
        this.__logoOpacity.aboutToBeDeleted();
        this.__titleOpacity.aboutToBeDeleted();
        this.__titleTranslateY.aboutToBeDeleted();
        this.__subtitleOpacity.aboutToBeDeleted();
        this.__progressWidth.aboutToBeDeleted();
        this.__progressOpacity.aboutToBeDeleted();
        this.__circle1Scale.aboutToBeDeleted();
        this.__circle2Scale.aboutToBeDeleted();
        this.__circle3Scale.aboutToBeDeleted();
        this.__bgGradientOffset.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // Logo缩放动画状态
    private __logoScale: ObservedPropertySimplePU<number>;
    get logoScale() {
        return this.__logoScale.get();
    }
    set logoScale(newValue: number) {
        this.__logoScale.set(newValue);
    }
    private __logoOpacity: ObservedPropertySimplePU<number>;
    get logoOpacity() {
        return this.__logoOpacity.get();
    }
    set logoOpacity(newValue: number) {
        this.__logoOpacity.set(newValue);
    }
    // 标题渐入动画状态
    private __titleOpacity: ObservedPropertySimplePU<number>;
    get titleOpacity() {
        return this.__titleOpacity.get();
    }
    set titleOpacity(newValue: number) {
        this.__titleOpacity.set(newValue);
    }
    private __titleTranslateY: ObservedPropertySimplePU<number>;
    get titleTranslateY() {
        return this.__titleTranslateY.get();
    }
    set titleTranslateY(newValue: number) {
        this.__titleTranslateY.set(newValue);
    }
    // 副标题渐入动画状态
    private __subtitleOpacity: ObservedPropertySimplePU<number>;
    get subtitleOpacity() {
        return this.__subtitleOpacity.get();
    }
    set subtitleOpacity(newValue: number) {
        this.__subtitleOpacity.set(newValue);
    }
    // 进度条动画状态
    private __progressWidth: ObservedPropertySimplePU<number>;
    get progressWidth() {
        return this.__progressWidth.get();
    }
    set progressWidth(newValue: number) {
        this.__progressWidth.set(newValue);
    }
    private __progressOpacity: ObservedPropertySimplePU<number>;
    get progressOpacity() {
        return this.__progressOpacity.get();
    }
    set progressOpacity(newValue: number) {
        this.__progressOpacity.set(newValue);
    }
    // 装饰圆圈动画状态
    private __circle1Scale: ObservedPropertySimplePU<number>;
    get circle1Scale() {
        return this.__circle1Scale.get();
    }
    set circle1Scale(newValue: number) {
        this.__circle1Scale.set(newValue);
    }
    private __circle2Scale: ObservedPropertySimplePU<number>;
    get circle2Scale() {
        return this.__circle2Scale.get();
    }
    set circle2Scale(newValue: number) {
        this.__circle2Scale.set(newValue);
    }
    private __circle3Scale: ObservedPropertySimplePU<number>;
    get circle3Scale() {
        return this.__circle3Scale.get();
    }
    set circle3Scale(newValue: number) {
        this.__circle3Scale.set(newValue);
    }
    // 背景渐变动画
    private __bgGradientOffset: ObservedPropertySimplePU<number>;
    get bgGradientOffset() {
        return this.__bgGradientOffset.get();
    }
    set bgGradientOffset(newValue: number) {
        this.__bgGradientOffset.set(newValue);
    }
    aboutToAppear(): void {
        // 启动动画序列
        this.startAnimationSequence();
    }
    // 启动动画序列
    private startAnimationSequence(): void {
        // 装饰圆圈动画 (立即开始)
        setTimeout(() => {
            this.animateCircles();
        }, 100);
        // Logo动画 (200ms后开始)
        setTimeout(() => {
            this.animateLogo();
        }, 200);
        // 标题动画 (800ms后开始)
        setTimeout(() => {
            this.animateTitle();
        }, 800);
        // 副标题动画 (1200ms后开始)
        setTimeout(() => {
            this.animateSubtitle();
        }, 1200);
        // 进度条动画 (1500ms后开始)
        setTimeout(() => {
            this.animateProgress();
        }, 1500);
        // 跳转到主页 (3000ms后)
        setTimeout(() => {
            this.navigateToMain();
        }, 3000);
    }
    // Logo动画
    private animateLogo(): void {
        Context.animateTo({
            duration: 600,
            curve: Curve.FastOutSlowIn,
            onFinish: () => {
                // Logo呼吸动画
                this.startBreathingAnimation();
            }
        }, () => {
            this.logoScale = 1.0;
            this.logoOpacity = 1.0;
        });
    }
    // Logo呼吸动画
    private startBreathingAnimation(): void {
        const breathe = () => {
            Context.animateTo({
                duration: 1500,
                curve: Curve.EaseInOut,
                iterations: -1
            }, () => {
                this.logoScale = 1.05;
            });
        };
        breathe();
    }
    // 标题动画
    private animateTitle(): void {
        Context.animateTo({
            duration: 500,
            curve: Curve.FastOutSlowIn
        }, () => {
            this.titleOpacity = 1.0;
            this.titleTranslateY = 0;
        });
    }
    // 副标题动画
    private animateSubtitle(): void {
        Context.animateTo({
            duration: 400,
            curve: Curve.FastOutSlowIn
        }, () => {
            this.subtitleOpacity = 1.0;
        });
    }
    // 进度条动画
    private animateProgress(): void {
        Context.animateTo({
            duration: 300,
            curve: Curve.FastOutSlowIn
        }, () => {
            this.progressOpacity = 1.0;
        });
        setTimeout(() => {
            Context.animateTo({
                duration: 1200,
                curve: Curve.Linear
            }, () => {
                this.progressWidth = 100;
            });
        }, 100);
    }
    // 装饰圆圈动画
    private animateCircles(): void {
        Context.animateTo({
            duration: 800,
            curve: Curve.FastOutSlowIn
        }, () => {
            this.circle1Scale = 1.0;
        });
        setTimeout(() => {
            Context.animateTo({
                duration: 800,
                curve: Curve.FastOutSlowIn
            }, () => {
                this.circle2Scale = 1.0;
            });
        }, 150);
        setTimeout(() => {
            Context.animateTo({
                duration: 800,
                curve: Curve.FastOutSlowIn
            }, () => {
                this.circle3Scale = 1.0;
            });
        }, 300);
    }
    // 导航到主页
    private navigateToMain(): void {
        router.replaceUrl({
            url: 'pages/Index'
        });
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width('100%');
            Stack.height('100%');
            Stack.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 背景渐变层
            Column.create();
            // 背景渐变层
            Column.width('100%');
            // 背景渐变层
            Column.height('100%');
            // 背景渐变层
            Column.linearGradient({
                angle: 135,
                colors: [
                    ['#667eea', 0.0],
                    ['#764ba2', 0.5],
                    ['#f093fb', 1.0]
                ]
            });
        }, Column);
        // 背景渐变层
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 装饰圆圈层
            Stack.create();
            // 装饰圆圈层
            Stack.width('100%');
            // 装饰圆圈层
            Stack.height('100%');
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 圆圈1 - 左上
            Circle.create();
            // 圆圈1 - 左上
            Circle.width(200);
            // 圆圈1 - 左上
            Circle.height(200);
            // 圆圈1 - 左上
            Circle.fill('rgba(255, 255, 255, 0.1)');
            // 圆圈1 - 左上
            Circle.position({ x: -60, y: -60 });
            // 圆圈1 - 左上
            Circle.scale({ x: this.circle1Scale, y: this.circle1Scale });
            // 圆圈1 - 左上
            Circle.blur(20);
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 圆圈2 - 右下
            Circle.create();
            // 圆圈2 - 右下
            Circle.width(280);
            // 圆圈2 - 右下
            Circle.height(280);
            // 圆圈2 - 右下
            Circle.fill('rgba(255, 255, 255, 0.08)');
            // 圆圈2 - 右下
            Circle.position({ x: '70%', y: '60%' });
            // 圆圈2 - 右下
            Circle.scale({ x: this.circle2Scale, y: this.circle2Scale });
            // 圆圈2 - 右下
            Circle.blur(30);
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 圆圈3 - 中右
            Circle.create();
            // 圆圈3 - 中右
            Circle.width(150);
            // 圆圈3 - 中右
            Circle.height(150);
            // 圆圈3 - 中右
            Circle.fill('rgba(255, 255, 255, 0.12)');
            // 圆圈3 - 中右
            Circle.position({ x: '60%', y: '10%' });
            // 圆圈3 - 中右
            Circle.scale({ x: this.circle3Scale, y: this.circle3Scale });
            // 圆圈3 - 中右
            Circle.blur(15);
        }, Circle);
        // 装饰圆圈层
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 主内容区域
            Column.create();
            // 主内容区域
            Column.width('100%');
            // 主内容区域
            Column.height('100%');
            // 主内容区域
            Column.justifyContent(FlexAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Logo区域
            Column.create();
            // Logo区域
            Column.scale({ x: this.logoScale, y: this.logoScale });
            // Logo区域
            Column.opacity(this.logoOpacity);
            // Logo区域
            Column.margin({ bottom: 30 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Logo图标 - 使用滤镜图标设计
            Stack.create();
            // Logo图标 - 使用滤镜图标设计
            Stack.width(140);
            // Logo图标 - 使用滤镜图标设计
            Stack.height(140);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 外圈光晕
            Circle.create();
            // 外圈光晕
            Circle.width(140);
            // 外圈光晕
            Circle.height(140);
            // 外圈光晕
            Circle.fill('rgba(255, 255, 255, 0.15)');
            // 外圈光晕
            Circle.blur(20);
        }, Circle);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 主Logo容器
            Column.create();
            // 主Logo容器
            Column.width(120);
            // 主Logo容器
            Column.height(120);
            // 主Logo容器
            Column.justifyContent(FlexAlign.Center);
            // 主Logo容器
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 滤镜图标 - 三层叠加效果
            Stack.create();
            // 滤镜图标 - 三层叠加效果
            Stack.width(100);
            // 滤镜图标 - 三层叠加效果
            Stack.height(100);
            // 滤镜图标 - 三层叠加效果
            Stack.alignContent(Alignment.Center);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底层 - 模拟滤镜层
            Rect.create();
            // 底层 - 模拟滤镜层
            Rect.width(70);
            // 底层 - 模拟滤镜层
            Rect.height(70);
            // 底层 - 模拟滤镜层
            Rect.radius(12);
            // 底层 - 模拟滤镜层
            Rect.fill('rgba(255, 255, 255, 0.3)');
            // 底层 - 模拟滤镜层
            Rect.rotate({ angle: -15 });
        }, Rect);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 中层
            Rect.create();
            // 中层
            Rect.width(70);
            // 中层
            Rect.height(70);
            // 中层
            Rect.radius(12);
            // 中层
            Rect.fill('rgba(255, 255, 255, 0.5)');
            // 中层
            Rect.rotate({ angle: 0 });
        }, Rect);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 顶层 - 主图标
            Rect.create();
            // 顶层 - 主图标
            Rect.width(70);
            // 顶层 - 主图标
            Rect.height(70);
            // 顶层 - 主图标
            Rect.radius(12);
            // 顶层 - 主图标
            Rect.fill('rgba(255, 255, 255, 0.95)');
            // 顶层 - 主图标
            Rect.rotate({ angle: 15 });
        }, Rect);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 滤镜符号
            Text.create('✦');
            // 滤镜符号
            Text.fontSize(40);
            // 滤镜符号
            Text.fontColor('#764ba2');
            // 滤镜符号
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        // 滤镜符号
        Text.pop();
        // 滤镜图标 - 三层叠加效果
        Stack.pop();
        // 主Logo容器
        Column.pop();
        // Logo图标 - 使用滤镜图标设计
        Stack.pop();
        // Logo区域
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 应用标题
            Column.create();
            // 应用标题
            Column.opacity(this.titleOpacity);
            // 应用标题
            Column.translate({ y: this.titleTranslateY });
            // 应用标题
            Column.margin({ bottom: 60 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Image Filter');
            Text.fontSize(38);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#ffffff');
            Text.textShadow({
                radius: 10,
                color: 'rgba(0, 0, 0, 0.3)',
                offsetX: 0,
                offsetY: 4
            });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 副标题
            Text.create('专业图像滤镜处理工具');
            // 副标题
            Text.fontSize(16);
            // 副标题
            Text.fontColor('rgba(255, 255, 255, 0.85)');
            // 副标题
            Text.margin({ top: 12 });
            // 副标题
            Text.opacity(this.subtitleOpacity);
        }, Text);
        // 副标题
        Text.pop();
        // 应用标题
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 加载进度条
            Column.create();
            // 加载进度条
            Column.opacity(this.progressOpacity);
            // 加载进度条
            Column.margin({ top: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 进度条背景
            Stack.create();
            // 进度条背景
            Stack.width(200);
            // 进度条背景
            Stack.height(4);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 背景轨道
            Row.create();
            // 背景轨道
            Row.width(200);
            // 背景轨道
            Row.height(4);
            // 背景轨道
            Row.backgroundColor('rgba(255, 255, 255, 0.2)');
            // 背景轨道
            Row.borderRadius(2);
        }, Row);
        // 背景轨道
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 进度填充
            Row.create();
            // 进度填充
            Row.width(this.progressWidth * 2);
            // 进度填充
            Row.height(4);
            // 进度填充
            Row.linearGradient({
                angle: 90,
                colors: [
                    ['rgba(255, 255, 255, 0.8)', 0.0],
                    ['rgba(255, 255, 255, 1.0)', 1.0]
                ]
            });
            // 进度填充
            Row.borderRadius(2);
        }, Row);
        // 进度填充
        Row.pop();
        // 进度条背景
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 加载文字
            Text.create('正在加载...');
            // 加载文字
            Text.fontSize(12);
            // 加载文字
            Text.fontColor('rgba(255, 255, 255, 0.7)');
            // 加载文字
            Text.margin({ top: 12 });
        }, Text);
        // 加载文字
        Text.pop();
        // 加载进度条
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 底部版权信息
            Column.create();
            // 底部版权信息
            Column.margin({ bottom: 30 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Powered by HarmonyOS');
            Text.fontSize(12);
            Text.fontColor('rgba(255, 255, 255, 0.5)');
        }, Text);
        Text.pop();
        // 底部版权信息
        Column.pop();
        // 主内容区域
        Column.pop();
        Stack.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "SplashPage";
    }
}
registerNamedRoute(() => new SplashPage(undefined, {}), "", { bundleName: "com.example.imagefilter", moduleName: "entry", pagePath: "pages/SplashPage", pageFullPath: "entry/src/main/ets/pages/SplashPage", integratedHsp: "false", moduleType: "followWithHap" });
