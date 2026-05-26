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

/**
 * Parameter adjustment panel component
 * Provides sliders for adjusting image parameters like brightness, contrast, saturation, etc.
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
  
  // Callback for reset
  onReset?: () => void;
  
  build() {
    Column() {
      // Header with title and reset button
      Row() {
        Text("参数调整")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
        
        Blank()
        
        Button("重置")
          .fontSize(14)
          .fontColor($r('sys.color.font_emphasize'))
          .backgroundColor($r('sys.color.background_primary'))
          .borderRadius(8)
          .height(32)
          .padding({ left: 12, right: 12 })
          .onClick(() => {
            if (this.onReset) {
              this.onReset();
            }
          })
      }
      .width('100%')
      .margin({ bottom: 16 })
      
      // Scrollable slider list
      Scroll() {
        Column() {
          // Brightness
          Column() {
            Row() {
              Text('亮度')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.brightnessValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.brightnessValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.brightnessValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Contrast
          Column() {
            Row() {
              Text('对比度')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.contrastValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.contrastValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.contrastValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Saturation
          Column() {
            Row() {
              Text('饱和度')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.saturationValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.saturationValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.saturationValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Hue
          Column() {
            Row() {
              Text('色相')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.hueValue)}°`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.hueValue,
                min: 0,
                max: 360,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.hueValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Warmth
          Column() {
            Row() {
              Text('色温')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.warmthValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.warmthValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.warmthValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Exposure
          Column() {
            Row() {
              Text('曝光')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.exposureValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.exposureValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.exposureValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          
          // Gamma
          Column() {
            Row() {
              Text('伽马')
                .fontSize(14)
                .fontColor($r('sys.color.font_primary'))
                .width(60)
              Blank()
              Text(`${Math.round(this.gammaValue)}`)
                .fontSize(14)
                .fontColor($r('sys.color.font_secondary'))
                .width(60)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              Slider({
                value: this.gammaValue,
                min: 0,
                max: 200,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor($r('sys.color.font_emphasize'))
                .trackColor($r('sys.color.background_secondary'))
                .selectedColor($r('sys.color.font_emphasize'))
                .showSteps(false)
                .showTips(true)
                .width('100%')
                .onChange((newValue: number) => {
                  this.gammaValue = Math.round(newValue);
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
  }
}
