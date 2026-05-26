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
import { DeviceHelper, DeviceType } from '../utils/DeviceHelper';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';

// Edit mode type
type EditMode = 'preset' | 'adjust';

// Image source type - can be Resource or file URI string
type ImageSource = Resource | string;

@Entry
@Component
struct Index {
  // Get context for image picker
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  
  // 设备适配相关
  @State deviceType: DeviceType = DeviceType.PHONE;
  @State screenWidth: number = 360;
  @State screenHeight: number = 640;
  
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
  
  // Image height constraints - 将根据设备类型动态计算
  private readonly MIN_IMAGE_HEIGHT: number = 160; // Minimum image height when sticky
  private readonly IMAGE_SHRINK_RANGE: number = 160; // Range for image to shrink (MAX - MIN)
  
  // Scroller controller
  private scroller: Scroller = new Scroller();

  // [Start aboutToAppear]
  aboutToAppear(): void {
    // 获取屏幕尺寸并设置设备类型
    this.updateScreenInfo();
    
    // Initialize with default images from resources
    this.imageList = [...CAROUSEL_DATA_SOURCE];
    // Initialize all images to 'original' filter.
    this.imageFilterTags = new Array<string>(this.imageList.length).fill('original');
    // Initialize all images with default adjustment parameters
    this.initAdjustParams();
  }
  // [End aboutToAppear]
  
  // 更新屏幕信息
  private updateScreenInfo(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      this.screenWidth = px2vp(displayInfo.width);
      this.screenHeight = px2vp(displayInfo.height);
      this.deviceType = DeviceHelper.getDeviceType(this.screenWidth);
    } catch (error) {
      // 使用默认值
      this.deviceType = DeviceType.PHONE;
    }
  }

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

  // Calculate dynamic image height based on scroll offset and device type
  private calculateImageHeight(): number {
    const maxHeight = DeviceHelper.getImageCarouselHeight(this.deviceType, this.screenHeight);
    
    if (this.scrollOffset <= 0) {
      return maxHeight;
    }
    // Calculate shrink progress (0 to 1)
    const shrinkProgress = Math.min(this.scrollOffset / this.IMAGE_SHRINK_RANGE, 1);
    // Linear interpolation between MAX and MIN
    const height = maxHeight - (maxHeight - this.MIN_IMAGE_HEIGHT) * shrinkProgress;
    return Math.max(height, this.MIN_IMAGE_HEIGHT);
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 底层：渐变背景 - 使用清爽的浅色渐变
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 180,
          colors: [
            ['#f0f4ff', 0.0],
            ['#e8eeff', 0.5],
            ['#f5f7ff', 1.0]
          ]
        })
      
      // 中层：滚动内容区域（参数调整区域）
      Scroll(this.scroller) {
        Column() {
          // 占位区域，为顶部的图片区域留出空间
          Column()
            .width('100%')
            .height(this.calculateImageHeight() + 100) // 图片高度 + 图片计数区域高度
          
          // Mode Switch Tabs - 美化的标签切换
          Row() {
            // 预设滤镜标签
            Column() {
              Text('🎨 预设滤镜')
                .fontSize(15)
                .fontWeight(this.editMode === 'preset' ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.editMode === 'preset' ? '#667eea' : '#8e9aaf')
            }
            .padding({ left: 24, right: 24, top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor(this.editMode === 'preset' ? '#ffffff' : 'transparent')
            .shadow(this.editMode === 'preset' ? {
              radius: 12,
              color: 'rgba(102, 126, 234, 0.2)',
              offsetX: 0,
              offsetY: 4
            } : { radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 })
            .onClick(() => {
              this.editMode = 'preset';
            })
            .animation({
              duration: 300,
              curve: Curve.FastOutSlowIn
            })
            
            // 参数调整标签
            Column() {
              Text('⚙️ 参数调整')
                .fontSize(15)
                .fontWeight(this.editMode === 'adjust' ? FontWeight.Bold : FontWeight.Medium)
                .fontColor(this.editMode === 'adjust' ? '#667eea' : '#8e9aaf')
            }
            .padding({ left: 24, right: 24, top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor(this.editMode === 'adjust' ? '#ffffff' : 'transparent')
            .shadow(this.editMode === 'adjust' ? {
              radius: 12,
              color: 'rgba(102, 126, 234, 0.2)',
              offsetX: 0,
              offsetY: 4
            } : { radius: 0, color: 'transparent', offsetX: 0, offsetY: 0 })
            .onClick(() => {
              this.editMode = 'adjust';
            })
            .animation({
              duration: 300,
              curve: Curve.FastOutSlowIn
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 16 })
          
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
                deviceType: this.deviceType,
                onReset: () => {
                  this.resetCurrentParams();
                }
              })
            }
          }
          .width('100%')
          .constraintSize({
            maxWidth: DeviceHelper.getContentMaxWidth(this.deviceType)
          })
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
        // Top status bar area - 渐变背景
        Row()
          .width('100%')
          .height(45)
          .linearGradient({
            angle: 90,
            colors: [
              ['rgba(102, 126, 234, 0.95)', 0.0],
              ['rgba(118, 75, 162, 0.95)', 1.0]
            ]
          })
        
        // Image Carousel Section
        Column() {
          // [Start swiperUsagePosition]
          Swiper() {
            ForEach(this.imageList, (imgSource: ImageSource, index: number) => {
              // Container needed for individual scale animation
              Column() {
                // [Start imageUsagePosition]
                Stack() {
                  // 图片背景层 - 使用浅蓝色背景，与整体背景呼应
                  Column()
                    .width('100%')
                    .height('100%')
                    .linearGradient({
                      angle: 180,
                      colors: [
                        ['rgba(240, 244, 255, 0.95)', 0.0],
                        ['rgba(232, 238, 255, 0.95)', 1.0]
                      ]
                    })
                    .blur(20)
                    .offset({ y: 10 })
                  
                  // 主图片
                  Image(imgSource)
                    .width('100%')
                    .height('100%')
                    .objectFit(ImageFit.Contain)
                    .borderRadius(20)
                    // Apply filter based on current edit mode
                    .colorFilter(this.getCurrentFilter(index))
                }
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
              .selectedColor('#667eea')
              .color('rgba(102, 126, 234, 0.3)')
          )
          .loop(false)
          .effectMode(EdgeEffect.Spring)
        }
        .width('100%')
        .height(this.calculateImageHeight())
        .justifyContent(FlexAlign.Center)
        .padding({ left: 16, right: 16, top: 8 })
        
        // Image counter and add button - 美化的按钮样式
        Row() {
          // 图片计数器 - 添加背景卡片
          Row() {
            Text(`📸 图片 ${this.currentSwiperIndex + 1} / ${this.imageList.length}`)
              .fontSize(14)
              .fontColor('#667eea')
              .fontWeight(FontWeight.Medium)
          }
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .shadow({
            radius: 8,
            color: 'rgba(0, 0, 0, 0.08)',
            offsetX: 0,
            offsetY: 2
          })
          
          Blank()
          
          // 添加图片按钮 - 渐变背景
          Button({ type: ButtonType.Normal }) {
            Row() {
              Text('+')
                .fontSize(20)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Bold)
              Text('添加图片')
                .fontSize(14)
                .fontColor('#ffffff')
                .fontWeight(FontWeight.Medium)
                .margin({ left: 6 })
            }
          }
          .linearGradient({
            angle: 90,
            colors: [
              ['#667eea', 0.0],
              ['#764ba2', 1.0]
            ]
          })
          .borderRadius(24)
          .height(40)
          .padding({ left: 20, right: 20 })
          .shadow({
            radius: 12,
            color: 'rgba(102, 126, 234, 0.4)',
            offsetX: 0,
            offsetY: 4
          })
          .onClick(() => {
            this.pickImages();
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 12, bottom: 12 })
      }
      .width('100%')
      .linearGradient({
        angle: 180,
        colors: [
          ['rgba(240, 244, 255, 0.98)', 0.0],
          ['rgba(232, 238, 255, 0.95)', 1.0]
        ]
      })
      .borderRadius({ bottomLeft: 32, bottomRight: 32 })
    }
    .height('100%')
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  // Preset Filter Panel Builder
  @Builder
  PresetFilterPanel() {
    Column() {
      // 标题栏
      Row() {
        Text('✨ 应用滤镜')
          .fontSize(20 * DeviceHelper.getFontScaleFactor(this.deviceType))
          .fontWeight(FontWeight.Bold)
          .fontColor('#2d3748')
        
        Blank()
        
        // 当前滤镜指示
        Text(this.getCurrentFilterName())
          .fontSize(12 * DeviceHelper.getFontScaleFactor(this.deviceType))
          .fontColor('#667eea')
          .fontWeight(FontWeight.Medium)
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor('rgba(102, 126, 234, 0.1)')
          .borderRadius(12)
      }
      .width('100%')
      .margin({ bottom: 20 })
      
      // [Start radioUsagePosition]
      Grid() {
        ForEach(FILTER_OPTIONS, (item: FilterOption, index: number) => {
          GridItem() {
            // 滤镜选项卡片
            Column() {
              // 图标或装饰
              Text(this.getFilterIcon(item.value))
                .fontSize(24 * DeviceHelper.getFontScaleFactor(this.deviceType))
                .margin({ bottom: 8 })
              
              // 滤镜名称
              Text(item.label)
                .fontSize(13 * DeviceHelper.getFontScaleFactor(this.deviceType))
                .fontColor(this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#667eea' : '#4a5568')
                .fontWeight(this.imageFilterTags[this.currentSwiperIndex] === item.value ? FontWeight.Bold : FontWeight.Medium)
            }
            .width('100%')
            .height(80 * DeviceHelper.getSpacingScaleFactor(this.deviceType))
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#ffffff' : 'rgba(255, 255, 255, 0.6)')
            .borderRadius(16)
            .border({
              width: this.imageFilterTags[this.currentSwiperIndex] === item.value ? 2 : 1,
              color: this.imageFilterTags[this.currentSwiperIndex] === item.value ? '#667eea' : 'rgba(102, 126, 234, 0.2)'
            })
            .shadow(this.imageFilterTags[this.currentSwiperIndex] === item.value ? {
              radius: 16,
              color: 'rgba(102, 126, 234, 0.25)',
              offsetX: 0,
              offsetY: 6
            } : {
              radius: 4,
              color: 'rgba(0, 0, 0, 0.05)',
              offsetX: 0,
              offsetY: 2
            })
            .onClick(() => {
              this.imageFilterTags[this.currentSwiperIndex] = item.value;
            })
            .animation({
              duration: 250,
              curve: Curve.FastOutSlowIn
            })
          }
        }, (item: FilterOption, index: number) => index + '_' + JSON.stringify(item))
      }
      .columnsTemplate(this.getFilterGridColumnsTemplate())
      .rowsGap(16 * DeviceHelper.getSpacingScaleFactor(this.deviceType))
      .columnsGap(12 * DeviceHelper.getSpacingScaleFactor(this.deviceType))
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      // [End radioUsagePosition]
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
  
  // 获取滤镜网格列模板
  private getFilterGridColumnsTemplate(): string {
    const columns = DeviceHelper.getFilterGridColumns(this.deviceType);
    return '1fr '.repeat(columns).trim();
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
