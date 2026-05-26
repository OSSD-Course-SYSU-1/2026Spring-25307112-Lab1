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

import { AdjustParams, DEFAULT_ADJUST_PARAMS, PARAM_SLIDERS, ParamSliderConfig } from '../constants/CommonConstants';
import { DeviceHelper, DeviceType } from '../utils/DeviceHelper';

/**
 * Parameter adjustment panel component
 * Provides sliders for adjusting image parameters like brightness, contrast, saturation, etc.
 * 支持多端适配，在不同设备上自动调整布局
 */
@Component
export struct AdjustPanel {
  // Use @Link for two-way data binding to ensure slider updates on reset
  @Link brightnessValue: number;
  @Link contrastValue: number;
  @Link saturationValue: number;
  @Link hueValue: number;
  @Link warmthValue: number;
  @Link exposureValue: number;
  @Link gammaValue: number;
  
  // 设备类型
  @Prop deviceType: DeviceType = DeviceType.PHONE;
  
  // Callback for reset
  onReset?: () => void;
  
  build() {
    Column() {
      // Header with title and reset button - 美化的标题栏
      Row() {
        Row() {
          Text('⚙️ ')
            .fontSize(20 * DeviceHelper.getFontScaleFactor(this.deviceType))
          Text("参数调整")
            .fontSize(20 * DeviceHelper.getFontScaleFactor(this.deviceType))
            .fontWeight(FontWeight.Bold)
            .fontColor('#2d3748')
        }
        
        Blank()
        
        // 重置按钮 - 渐变背景
        Button() {
          Row() {
            Text('↺')
              .fontSize(16 * DeviceHelper.getFontScaleFactor(this.deviceType))
              .fontColor('#ffffff')
            Text('重置')
              .fontSize(13 * DeviceHelper.getFontScaleFactor(this.deviceType))
              .fontColor('#ffffff')
              .fontWeight(FontWeight.Medium)
              .margin({ left: 4 })
          }
        }
        .linearGradient({
          angle: 90,
          colors: [
            ['#667eea', 0.0],
            ['#764ba2', 1.0]
          ]
        })
        .borderRadius(18)
        .height(36 * DeviceHelper.getSpacingScaleFactor(this.deviceType))
        .padding({ left: 16, right: 16 })
        .shadow({
          radius: 8,
          color: 'rgba(102, 126, 234, 0.3)',
          offsetX: 0,
          offsetY: 3
        })
        .onClick(() => {
          if (this.onReset) {
            this.onReset();
          }
        })
      }
      .width('100%')
      .margin({ bottom: 20 })
      
      // Scrollable slider list - 响应式网格布局
      Scroll() {
        // 根据设备类型选择布局方式
        if (DeviceHelper.isHorizontalLayout(this.deviceType)) {
          // 平板/大屏：网格布局
          Grid() {
            // Brightness - 亮度
            GridItem() {
              this.SliderItem(
                '💡',
                '亮度',
                this.brightnessValue,
                0,
                200,
                (newValue: number) => {
                  this.brightnessValue = Math.round(newValue);
                }
              )
            }
            
            // Contrast - 对比度
            GridItem() {
              this.SliderItem(
                '🔲',
                '对比度',
                this.contrastValue,
                0,
                200,
                (newValue: number) => {
                  this.contrastValue = Math.round(newValue);
                }
              )
            }
            
            // Saturation - 饱和度
            GridItem() {
              this.SliderItem(
                '🎨',
                '饱和度',
                this.saturationValue,
                0,
                200,
                (newValue: number) => {
                  this.saturationValue = Math.round(newValue);
                }
              )
            }
            
            // Hue - 色相
            GridItem() {
              this.SliderItem(
                '🌈',
                '色相',
                this.hueValue,
                0,
                360,
                (newValue: number) => {
                  this.hueValue = Math.round(newValue);
                },
                '°'
              )
            }
            
            // Warmth - 色温
            GridItem() {
              this.SliderItem(
                '🌡️',
                '色温',
                this.warmthValue,
                0,
                200,
                (newValue: number) => {
                  this.warmthValue = Math.round(newValue);
                }
              )
            }
            
            // Exposure - 曝光
            GridItem() {
              this.SliderItem(
                '☀️',
                '曝光',
                this.exposureValue,
                0,
                200,
                (newValue: number) => {
                  this.exposureValue = Math.round(newValue);
                }
              )
            }
            
            // Gamma - 伽马
            GridItem() {
              this.SliderItem(
                '📊',
                '伽马',
                this.gammaValue,
                0,
                200,
                (newValue: number) => {
                  this.gammaValue = Math.round(newValue);
                }
              )
            }
          }
          .columnsTemplate(this.getParamGridColumnsTemplate())
          .rowsGap(16)
          .columnsGap(16)
          .width('100%')
          .scrollBar(BarState.Off)
          .edgeEffect(EdgeEffect.Spring)
        } else {
          // 手机：单列布局
          Column() {
            // Brightness - 亮度
            this.SliderItem(
              '💡',
              '亮度',
              this.brightnessValue,
              0,
              200,
              (newValue: number) => {
                this.brightnessValue = Math.round(newValue);
              }
            )
            
            // Contrast - 对比度
            this.SliderItem(
              '🔲',
              '对比度',
              this.contrastValue,
              0,
              200,
              (newValue: number) => {
                this.contrastValue = Math.round(newValue);
              }
            )
            
            // Saturation - 饱和度
            this.SliderItem(
              '🎨',
              '饱和度',
              this.saturationValue,
              0,
              200,
              (newValue: number) => {
                this.saturationValue = Math.round(newValue);
              }
            )
            
            // Hue - 色相
            this.SliderItem(
              '🌈',
              '色相',
              this.hueValue,
              0,
              360,
              (newValue: number) => {
                this.hueValue = Math.round(newValue);
              },
              '°'
            )
            
            // Warmth - 色温
            this.SliderItem(
              '🌡️',
              '色温',
              this.warmthValue,
              0,
              200,
              (newValue: number) => {
                this.warmthValue = Math.round(newValue);
              }
            )
            
            // Exposure - 曝光
            this.SliderItem(
              '☀️',
              '曝光',
              this.exposureValue,
              0,
              200,
              (newValue: number) => {
                this.exposureValue = Math.round(newValue);
              }
            )
            
            // Gamma - 伽马
            this.SliderItem(
              '📊',
              '伽马',
              this.gammaValue,
              0,
              200,
              (newValue: number) => {
                this.gammaValue = Math.round(newValue);
              }
            )
          }
          .width('100%')
        }
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .padding(24 * DeviceHelper.getSpacingScaleFactor(this.deviceType))
    .backgroundColor('#ffffff')
    .borderRadius(24)
    .shadow({
      radius: 20,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 8
    })
  }
  
  // 获取参数网格列模板
  private getParamGridColumnsTemplate(): string {
    const columns = DeviceHelper.getParamGridColumns(this.deviceType);
    return '1fr '.repeat(columns).trim();
  }
  
  // 美化的滑块项组件
  @Builder
  SliderItem(
    icon: string,
    label: string,
    value: number,
    min: number,
    max: number,
    onChange: (value: number) => void,
    unit: string = ''
  ) {
    Column() {
      // 标签和数值显示
      Row() {
        // 图标和标签
        Row() {
          Text(icon)
            .fontSize(18 * DeviceHelper.getFontScaleFactor(this.deviceType))
          Text(label)
            .fontSize(14 * DeviceHelper.getFontScaleFactor(this.deviceType))
            .fontColor('#4a5568')
            .fontWeight(FontWeight.Medium)
            .margin({ left: 6 })
        }
        
        Blank()
        
        // 数值显示 - 带背景卡片
        Row() {
          Text(`${Math.round(value)}${unit}`)
            .fontSize(14 * DeviceHelper.getFontScaleFactor(this.deviceType))
            .fontColor('#667eea')
            .fontWeight(FontWeight.Bold)
        }
        .padding({ left: 12, right: 12, top: 4, bottom: 4 })
        .backgroundColor('rgba(102, 126, 234, 0.1)')
        .borderRadius(10)
      }
      .width('100%')
      .margin({ bottom: 10 })
      
      // 滑块轨道 - 自定义样式
      Stack() {
        // 背景轨道
        Row()
          .width('100%')
          .height(6)
          .backgroundColor('rgba(102, 126, 234, 0.15)')
          .borderRadius(3)
        
        // 进度填充
        Row()
          .width(`${((value - min) / (max - min)) * 100}%`)
          .height(6)
          .linearGradient({
            angle: 90,
            colors: [
              ['#667eea', 0.0],
              ['#764ba2', 1.0]
            ]
          })
          .borderRadius(3)
      }
      .width('100%')
      .height(6)
      
      // 实际滑块（透明，用于交互）
      Slider({
        value: value,
        min: min,
        max: max,
        step: 1,
        style: SliderStyle.OutSet
      })
        .blockColor('transparent')
        .trackColor('transparent')
        .selectedColor('transparent')
        .showSteps(false)
        .showTips(false)
        .width('100%')
        .height(20)
        .onChange(onChange)
    }
    .width('100%')
    .padding({ 
      top: 12 * DeviceHelper.getSpacingScaleFactor(this.deviceType), 
      bottom: 12 * DeviceHelper.getSpacingScaleFactor(this.deviceType) 
    })
  }
}
