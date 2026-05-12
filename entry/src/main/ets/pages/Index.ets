/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CAROUSEL_DATA_SOURCE, FILTER_OPTIONS, FilterOption, ORIGINAL_MATRIX } from '../constants/CommonConstants';

@Entry
@Component
struct Index {
  // Tracks the current index of the Swiper
  @State currentSwiperIndex: number = 0;
  // Stores the filter "tag" (value) for EACH image independently.
  @State imageFilterTags: Array<string> = [];

  // [Start aboutToAppear]
  aboutToAppear(): void {
    // Initialize all images to 'original' filter.
    this.imageFilterTags = new Array<string>(CAROUSEL_DATA_SOURCE.length).fill('original');
  }
  // [End aboutToAppear]

  build() {
    Column() {
      // Top Section: Image Carousel (Swiper)
      Column() {
        // [Start swiperUsagePosition]
        Swiper() {
          ForEach(CAROUSEL_DATA_SOURCE, (imgRes: Resource, index: number) => {
            // Container needed for individual scale animation
            Column() {
              // [Start imageUsagePosition]
              Image(imgRes)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Contain)
                .borderRadius(16)
                // Apply the filter corresponding to THIS specific image index
                .colorFilter(this.getFilterByTag(this.imageFilterTags[index]))
              // [End imageUsagePosition]
            }
            .justifyContent(FlexAlign.Center)
            // Animation: Scale down inactive images for a "Carousel" effect
            .scale({
              x: this.currentSwiperIndex === index ? 1.0 : 0.9,
              y: this.currentSwiperIndex === index ? 1.0 : 0.9
            })
            .animation({
              duration: 300,
              curve: Curve.FastOutSlowIn // Smooth physics curve
            })
          }, (item: Resource, index: number) => index + '_' + JSON.stringify(item))
        }
        .onChange((index: number) => {
          // Update global index state when user swipes
          this.currentSwiperIndex = index;
        })
        // [End swiperUsagePosition]
        .width('100%')
        .height('100%')
        .itemSpace(20)
        .indicator(
          Indicator.dot()
            .selectedColor($r('sys.color.font_primary'))
            .color($r('sys.color.font_secondary'))
        )
        .loop(false)
        .effectMode(EdgeEffect.Spring)
      }
      .width('100%')
      .height('65%')
      .justifyContent(FlexAlign.Center)
      .padding({ left: 16, right: 16, top: 8 })
      .margin({ top: 45 })

      // Bottom Section: Control Panel (Radios)
      Column() {
        Text("Apply Filter")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .margin({ bottom: 16 })
          .fontColor($r('sys.color.font_primary'))
        // [Start radioUsagePosition]
        Grid() {
          ForEach(FILTER_OPTIONS, (item: FilterOption) => {
            GridItem() {
              Row() {
                Radio({ value: item.value, group: 'filterGroup' })
                  .checked(this.imageFilterTags[this.currentSwiperIndex] === item.value)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.imageFilterTags[this.currentSwiperIndex] = item.value;
                    }
                  })
                Text(item.label)
                  .fontSize(14)
                  .fontColor($r('sys.color.font_primary'))
                  .margin({ left: 4 })
                  .onClick(() => {
                    this.imageFilterTags[this.currentSwiperIndex] = item.value;
                  })
              }
              .width('100%')
            }
          }, (item: FilterOption, index: number) => index + '_' + JSON.stringify(item))
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(16)
        .columnsGap(10)
        .width('100%')
        // [End radioUsagePosition]
      }
      .layoutWeight(1)
      .padding(24)
      .backgroundColor($r('sys.color.background_primary'))
      .borderRadius(16)
      .margin({
        left: 16,
        right: 16,
        top: 36,
        bottom: 16
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // [Start getFilterByTagFunc]
  // Helper: Retrieves the actual filter object based on the tag string
  private getFilterByTag(tag: string): ColorFilter | number[] {
    const option = FILTER_OPTIONS.find(opt => opt.value === tag);
    return option ? option.filter : ORIGINAL_MATRIX;
  }
  // [End getFilterByTagFunc]
}