/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';

/**
 * Splash Page - 精美的启动界面
 * 展示应用品牌形象，包含动画效果和加载指示器
 */
@Entry
@Component
struct SplashPage {
  // Logo缩放动画状态
  @State logoScale: number = 0.3;
  @State logoOpacity: number = 0;
  
  // 标题渐入动画状态
  @State titleOpacity: number = 0;
  @State titleTranslateY: number = 30;
  
  // 副标题渐入动画状态
  @State subtitleOpacity: number = 0;
  
  // 进度条动画状态
  @State progressWidth: number = 0;
  @State progressOpacity: number = 0;
  
  // 装饰圆圈动画状态
  @State circle1Scale: number = 0;
  @State circle2Scale: number = 0;
  @State circle3Scale: number = 0;
  
  // 背景渐变动画
  @State bgGradientOffset: number = 0;

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
    animateTo({
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
      animateTo({
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
    animateTo({
      duration: 500,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.titleOpacity = 1.0;
      this.titleTranslateY = 0;
    });
  }

  // 副标题动画
  private animateSubtitle(): void {
    animateTo({
      duration: 400,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.subtitleOpacity = 1.0;
    });
  }

  // 进度条动画
  private animateProgress(): void {
    animateTo({
      duration: 300,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.progressOpacity = 1.0;
    });
    
    setTimeout(() => {
      animateTo({
        duration: 1200,
        curve: Curve.Linear
      }, () => {
        this.progressWidth = 100;
      });
    }, 100);
  }

  // 装饰圆圈动画
  private animateCircles(): void {
    animateTo({
      duration: 800,
      curve: Curve.FastOutSlowIn
    }, () => {
      this.circle1Scale = 1.0;
    });
    
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.FastOutSlowIn
      }, () => {
        this.circle2Scale = 1.0;
      });
    }, 150);
    
    setTimeout(() => {
      animateTo({
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

  build() {
    Stack() {
      // 背景渐变层
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [
            ['#667eea', 0.0],
            ['#764ba2', 0.5],
            ['#f093fb', 1.0]
          ]
        })
      
      // 装饰圆圈层
      Stack() {
        // 圆圈1 - 左上
        Circle()
          .width(200)
          .height(200)
          .fill('rgba(255, 255, 255, 0.1)')
          .position({ x: -60, y: -60 })
          .scale({ x: this.circle1Scale, y: this.circle1Scale })
          .blur(20)
        
        // 圆圈2 - 右下
        Circle()
          .width(280)
          .height(280)
          .fill('rgba(255, 255, 255, 0.08)')
          .position({ x: '70%', y: '60%' })
          .scale({ x: this.circle2Scale, y: this.circle2Scale })
          .blur(30)
        
        // 圆圈3 - 中右
        Circle()
          .width(150)
          .height(150)
          .fill('rgba(255, 255, 255, 0.12)')
          .position({ x: '60%', y: '10%' })
          .scale({ x: this.circle3Scale, y: this.circle3Scale })
          .blur(15)
      }
      .width('100%')
      .height('100%')
      
      // 主内容区域
      Column() {
        // Logo区域
        Column() {
          // Logo图标 - 使用滤镜图标设计
          Stack() {
            // 外圈光晕
            Circle()
              .width(140)
              .height(140)
              .fill('rgba(255, 255, 255, 0.15)')
              .blur(20)
            
            // 主Logo容器
            Column() {
              // 滤镜图标 - 三层叠加效果
              Stack() {
                // 底层 - 模拟滤镜层
                Rect()
                  .width(70)
                  .height(70)
                  .radius(12)
                  .fill('rgba(255, 255, 255, 0.3)')
                  .rotate({ angle: -15 })
                
                // 中层
                Rect()
                  .width(70)
                  .height(70)
                  .radius(12)
                  .fill('rgba(255, 255, 255, 0.5)')
                  .rotate({ angle: 0 })
                
                // 顶层 - 主图标
                Rect()
                  .width(70)
                  .height(70)
                  .radius(12)
                  .fill('rgba(255, 255, 255, 0.95)')
                  .rotate({ angle: 15 })
                
                // 滤镜符号
                Text('✦')
                  .fontSize(40)
                  .fontColor('#764ba2')
                  .fontWeight(FontWeight.Bold)
              }
              .width(100)
              .height(100)
              .alignContent(Alignment.Center)
            }
            .width(120)
            .height(120)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          }
          .width(140)
          .height(140)
        }
        .scale({ x: this.logoScale, y: this.logoScale })
        .opacity(this.logoOpacity)
        .margin({ bottom: 30 })
        
        // 应用标题
        Column() {
          Text('Image Filter')
            .fontSize(38)
            .fontWeight(FontWeight.Bold)
            .fontColor('#ffffff')
            .textShadow({
              radius: 10,
              color: 'rgba(0, 0, 0, 0.3)',
              offsetX: 0,
              offsetY: 4
            })
          
          // 副标题
          Text('专业图像滤镜处理工具')
            .fontSize(16)
            .fontColor('rgba(255, 255, 255, 0.85)')
            .margin({ top: 12 })
            .opacity(this.subtitleOpacity)
        }
        .opacity(this.titleOpacity)
        .translate({ y: this.titleTranslateY })
        .margin({ bottom: 60 })
        
        // 加载进度条
        Column() {
          // 进度条背景
          Stack() {
            // 背景轨道
            Row()
              .width(200)
              .height(4)
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .borderRadius(2)
            
            // 进度填充
            Row()
              .width(this.progressWidth * 2)
              .height(4)
              .linearGradient({
                angle: 90,
                colors: [
                  ['rgba(255, 255, 255, 0.8)', 0.0],
                  ['rgba(255, 255, 255, 1.0)', 1.0]
                ]
              })
              .borderRadius(2)
          }
          .width(200)
          .height(4)
          
          // 加载文字
          Text('正在加载...')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.7)')
            .margin({ top: 12 })
        }
        .opacity(this.progressOpacity)
        .margin({ top: 20 })
        
        Blank()
        
        // 底部版权信息
        Column() {
          Text('Powered by HarmonyOS')
            .fontSize(12)
            .fontColor('rgba(255, 255, 255, 0.5)')
        }
        .margin({ bottom: 30 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
