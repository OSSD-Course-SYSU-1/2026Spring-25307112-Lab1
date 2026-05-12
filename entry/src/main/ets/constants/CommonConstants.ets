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
import { common2D, drawing } from '@kit.ArkGraphics2D';

// [Start FilterOption]
/**
 * Interface definition for Filter Options.
 */
export interface FilterOption {
  label: string; // Display text for the UI
  value: string; // Unique identifier for logic
  filter: ColorFilter | number[]; // The actual Matrix or Drawing Object
}
// [End FilterOption]

// [Start ORIGINAL_MATRIX]
/**
 * Original color matrix
 */
export const ORIGINAL_MATRIX: number[] = [
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0
];
// [End ORIGINAL_MATRIX]

// [Start REVERSE_COLOR_MATRIX]
/**
 * Invert/Reverse color matrix (Ready to use, no adjustment needed)
 */
const REVERSE_COLOR_MATRIX: number[] = [
  -1, 0, 0, 0, 1, // R' = -1*R + 0*G + 0*B + 0*A + 1*255
  0, -1, 0, 0, 1, // G' = 0*R + -1*G + 0*B + 0*A + 1*255
  0, 0, -1, 0, 1, // B' = 0*R + 0*G + -1*B + 0*A + 1*255
  0, 0, 0, 1, 0   // A' = 0*R + 0*G + 0*B + 1*A + 0*255, Alpha unchanged
];
// [End REVERSE_COLOR_MATRIX]

// [Start WHITENING_COLOR_FILTER]
/**
 * Whitening color matrix configurations
 * (Note: This specific filter uses a BlendMode rather than a pure matrix array)
 */
const WHITENING_COLOR_CONFIG: common2D.Color = {
  alpha: 30, // Low opacity for the blend
  red: 255,
  green: 255,
  blue: 255
};

/**
 * Creates a color filter specifically for the whitening effect.
 * It uses the 'PLUS' blend mode to superimpose the configuration color onto the image, making it brighter.
 */
const WHITENING_COLOR_FILTER =
  drawing.ColorFilter.createBlendModeColorFilter(WHITENING_COLOR_CONFIG, drawing.BlendMode.PLUS);
// [End WHITENING_COLOR_FILTER]

// [Start ENHANCE_COLOR_MATRIX]
/**
 * Saturation Enhancement matrix (Approx 1.8x saturation, coefficients control intensity)
 */
const ENHANCE_COLOR_MATRIX: number[] = [
  1.63, -0.5723, -0.0577, 0, 0, // R' = High weight Red + Low weight Green/Blue
  -0.17, 1.2277, -0.0577, 0, 0, // G' = High weight Green + Low weight Red/Blue
  -0.17, -0.5723, 1.7423, 0, 0, // B' = High weight Blue + Low weight Red/Green
  0, 0, 0, 1, 0                 // Alpha unchanged
];
// [End ENHANCE_COLOR_MATRIX]

// [Start RETRO_COLOR_MATRIX]
/**
 * Retro/Vintage matrix (Adjust offsets 15/10/-5 to control warm tone intensity)
 */
const RETRO_COLOR_MATRIX: number[] = [
  0.213, 0.715, 0.072, 0, 0, // R' = Sepia calculation for Red
  0.213, 0.715, 0.072, 0, 0, // G' = Sepia calculation for Green
  0.213, 0.715, 0.072, 0, 0, // B' = Sepia calculation for Blue
  0, 0, 0, 1, 0              // Alpha unchanged
];
// [End RETRO_COLOR_MATRIX]

// [Start FILTER_OPTIONS]
/**
 * List of available filter options for the Radio Group
 */
export const FILTER_OPTIONS: FilterOption[] = [
  { label: 'Original', value: 'original', filter: ORIGINAL_MATRIX },
  { label: 'Retro', value: 'retro', filter: RETRO_COLOR_MATRIX },
  { label: 'Invert', value: 'invert', filter: REVERSE_COLOR_MATRIX },
  { label: 'Enhance', value: 'enhance', filter: ENHANCE_COLOR_MATRIX },
  { label: 'Whiten', value: 'whitening', filter: WHITENING_COLOR_FILTER }
];
// [End FILTER_OPTIONS]

/**
 * Data source for the carousel component.
 * Contains a collection of image resources to be displayed in the gallery.
 */
export const CAROUSEL_DATA_SOURCE: Resource[] = [
  $r('app.media.avatar1'),
  $r('app.media.avatar2')
];