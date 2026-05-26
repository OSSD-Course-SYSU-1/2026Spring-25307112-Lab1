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

import { 
  CAROUSEL_DATA_SOURCE, 
  FILTER_OPTIONS, 
  FilterOption, 
  ORIGINAL_MATRIX,
  AdjustParams,
  DEFAULT_ADJUST_PARAMS,
  generateAdjustMatrix
} from '../constants/CommonConstants';
import { AdjustPanel } from '../components/AdjustPanel';
import { ImagePickerUtil } from '../utils/ImagePickerUtil';
import { common } from '@kit.AbilityKit';

// Edit mode type
type EditMode = 'preset' | 'adjust';

// Image source type - can be Resource or file URI string
type ImageSource = Resource | string;

@Entry
@Component
struct Index {
  // Get context for image picker
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  
  // Tracks the current index of the Swiper
  @State currentSwiperIndex: number = 0;
  // Dynamic image list - supports both Resource and URI
  @State imageList: Array<ImageSource> = [];
  // Stores the filter "tag" (value) for EACH image independently (preset mode)
  @State imageFilterTags: Array<string> = [];
  // Stores the adjustment parameters for EACH image independently (adjust mode)
  @State imageAdjustParams: Array<AdjustParams> = [];
  // Current edit mode: preset filters or parameter adjustment
  @State editMode: EditMode = 'preset';
  
  // Current image adjustment parameters (for @Link binding with AdjustPanel)
  @State currentBrightness: number = DEFAULT_ADJUST_PARAMS.brightness;
  @State currentContrast: number = DEFAULT_ADJUST_PARAMS.contrast;
  @State currentSaturation: number = DEFAULT_ADJUST_PARAMS.saturation;
  @State currentHue: number = DEFAULT_ADJUST_PARAMS.hue;
  @State currentWarmth: number = DEFAULT_ADJUST_PARAMS.warmth;
  @State currentExposure: number = DEFAULT_ADJUST_PARAMS.exposure;
  @State currentGamma: number = DEFAULT_ADJUST_PARAMS.gamma;
  
  // Scroll related states for sticky image effect
  @State scrollOffset: number = 0;
  
  // Image height constraints
  private readonly MAX_IMAGE_HEIGHT: number = 320; // Maximum image height
  private readonly MIN_IMAGE_HEIGHT: number = 160; // Minimum image height when sticky
  private readonly IMAGE_SHRINK_RANGE: number = 160; // Range for image to shrink (MAX - MIN)
  
  // Scroller controller
  private scroller: Scroller = new Scroller();

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

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 底层：滚动内容区域（参数调整区域）
      Scroll(this.scroller) {
        Column() {
          // 占位区域，为顶部的图片区域留出空间
          Column()
            .width('100%')
            .height(this.calculateImageHeight() + 100) // 图片高度 + 图片计数区域高度
          
          // Mode Switch Tabs
          Row() {
            Text('预设滤镜')
              .fontSize(16)
              .fontWeight(this.editMode === 'preset' ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.editMode === 'preset' 
                ? $r('sys.color.font_emphasize') 
                : $r('sys.color.font_secondary'))
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(20)
              .backgroundColor(this.editMode === 'preset' 
                ? $r('sys.color.background_primary') 
                : 'transparent')
              .onClick(() => {
                this.editMode = 'preset';
              })
            
            Text('参数调整')
              .fontSize(16)
              .fontWeight(this.editMode === 'adjust' ? FontWeight.Bold : FontWeight.Normal)
              .fontColor(this.editMode === 'adjust' 
                ? $r('sys.color.font_emphasize') 
                : $r('sys.color.font_secondary'))
              .padding({ left: 20, right: 20, top: 8, bottom: 8 })
              .borderRadius(20)
              .backgroundColor(this.editMode === 'adjust' 
                ? $r('sys.color.background_primary') 
                : 'transparent')
              .onClick(() => {
                this.editMode = 'adjust';
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 8 })
          
          // Bottom Section: Control Panel
          Column() {
            if (this.editMode === 'preset') {
              // Preset Filter Panel
              this.PresetFilterPanel()
            } else {
              // Parameter Adjustment Panel - use @Link for two-way binding
              AdjustPanel({
                brightnessValue: $currentBrightness,
                contrastValue: $currentContrast,
                saturationValue: $currentSaturation,
                hueValue: $currentHue,
                warmthValue: $currentWarmth,
                exposureValue: $currentExposure,
                gammaValue: $currentGamma,
                onReset: () => {
                  this.resetCurrentParams();
                }
              })
            }
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 16 })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .onScroll(() => {
        // Update scroll offset
        this.scrollOffset = this.scroller.currentOffset().yOffset;
      })
      .onScrollEdge((side: Edge) => {
        // Reset scroll offset when reaching top edge
        if (side === Edge.Top) {
          this.scrollOffset = 0;
        }
      })
      
      // 顶层：固定的图片区域（吸顶效果）
      Column() {
        // Top status bar area
        Row()
          .width('100%')
          .height(45)
          .backgroundColor($r('sys.color.background_secondary'))
        
        // Image Carousel Section
        Column() {
          // [Start swiperUsagePosition]
          Swiper() {
            ForEach(this.imageList, (imgSource: ImageSource, index: number) => {
              // Container needed for individual scale animation
              Column() {
                // [Start imageUsagePosition]
                Image(imgSource)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Contain)
                  .borderRadius(16)
                  // Apply filter based on current edit mode
                  .colorFilter(this.getCurrentFilter(index))
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
            }, (item: ImageSource, index: number) => index + '_' + (typeof item === 'string' ? item : 'resource'))
          }
          .onChange((index: number) => {
            // Save current params before switching
            this.saveCurrentParams();
            // Update global index state when user swipes
            this.currentSwiperIndex = index;
            // Sync params from new image
            this.syncCurrentParams();
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
        .height(this.calculateImageHeight())
        .justifyContent(FlexAlign.Center)
        .padding({ left: 16, right: 16, top: 8 })
        
        // Image counter and add button
        Row() {
          Text(`图片 ${this.currentSwiperIndex + 1} / ${this.imageList.length}`)
            .fontSize(14)
            .fontColor($r('sys.color.font_secondary'))
          
          Blank()
          
          Button({ type: ButtonType.Normal }) {
            Row() {
              Text('+')
                .fontSize(18)
                .fontColor($r('sys.color.font_emphasize'))
              Text('添加图片')
                .fontSize(14)
                .fontColor($r('sys.color.font_emphasize'))
                .margin({ left: 4 })
            }
          }
          .backgroundColor($r('sys.color.background_primary'))
          .borderRadius(20)
          .height(36)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            this.pickImages();
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8, bottom: 8 })
      }
      .width('100%')
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.background_secondary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // Preset Filter Panel Builder
  @Builder
  PresetFilterPanel() {
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
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      // [End radioUsagePosition]
    }
    .width('100%')
    .height('100%')
    .padding(24)
    .backgroundColor($r('sys.color.background_primary'))
    .borderRadius(16)
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
    } else {
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
      } else {
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
  // [End getFilterByTagFunc]
}
