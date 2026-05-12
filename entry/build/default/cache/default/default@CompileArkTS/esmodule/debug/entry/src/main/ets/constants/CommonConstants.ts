import type common2D from "@ohos:graphics.common2D";
import drawing from "@ohos:graphics.drawing";
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
    -1, 0, 0, 0, 1,
    0, -1, 0, 0, 1,
    0, 0, -1, 0, 1,
    0, 0, 0, 1, 0 // A' = 0*R + 0*G + 0*B + 1*A + 0*255, Alpha unchanged
];
// [End REVERSE_COLOR_MATRIX]
// [Start WHITENING_COLOR_FILTER]
/**
 * Whitening color matrix configurations
 * (Note: This specific filter uses a BlendMode rather than a pure matrix array)
 */
const WHITENING_COLOR_CONFIG: common2D.Color = {
    alpha: 30,
    red: 255,
    green: 255,
    blue: 255
};
/**
 * Creates a color filter specifically for the whitening effect.
 * It uses the 'PLUS' blend mode to superimpose the configuration color onto the image, making it brighter.
 */
const WHITENING_COLOR_FILTER = drawing.ColorFilter.createBlendModeColorFilter(WHITENING_COLOR_CONFIG, drawing.BlendMode.PLUS);
// [End WHITENING_COLOR_FILTER]
// [Start ENHANCE_COLOR_MATRIX]
/**
 * Saturation Enhancement matrix (Approx 1.8x saturation, coefficients control intensity)
 */
const ENHANCE_COLOR_MATRIX: number[] = [
    1.63, -0.5723, -0.0577, 0, 0,
    -0.17, 1.2277, -0.0577, 0, 0,
    -0.17, -0.5723, 1.7423, 0, 0,
    0, 0, 0, 1, 0 // Alpha unchanged
];
// [End ENHANCE_COLOR_MATRIX]
// [Start RETRO_COLOR_MATRIX]
/**
 * Retro/Vintage matrix (Adjust offsets 15/10/-5 to control warm tone intensity)
 */
const RETRO_COLOR_MATRIX: number[] = [
    0.213, 0.715, 0.072, 0, 0,
    0.213, 0.715, 0.072, 0, 0,
    0.213, 0.715, 0.072, 0, 0,
    0, 0, 0, 1, 0 // Alpha unchanged
];
// [End RETRO_COLOR_MATRIX]
// [Start SEPIA_COLOR_MATRIX]
/**
 * Sepia/怀旧效果矩阵 (深褐色调，比Retro更浓郁)
 */
const SEPIA_COLOR_MATRIX: number[] = [
    0.393, 0.769, 0.189, 0, 0,
    0.349, 0.686, 0.168, 0, 0,
    0.272, 0.534, 0.131, 0, 0,
    0, 0, 0, 1, 0
];
// [End SEPIA_COLOR_MATRIX]
// [Start COOL_COLOR_MATRIX]
/**
 * Cool/冷色调效果矩阵 (偏蓝色调，适合风景照)
 */
const COOL_COLOR_MATRIX: number[] = [
    0.9, 0, 0, 0, 0,
    0, 0.9, 0, 0, 0,
    0, 0, 1.2, 0, 0,
    0, 0, 0, 1, 0
];
// [End COOL_COLOR_MATRIX]
// [Start WARM_COLOR_MATRIX]
/**
 * Warm/暖色调效果矩阵 (偏橙黄色调，温馨感)
 */
const WARM_COLOR_MATRIX: number[] = [
    1.2, 0, 0, 0, 0,
    0, 1.1, 0, 0, 0,
    0, 0, 0.8, 0, 0,
    0, 0, 0, 1, 0
];
// [End WARM_COLOR_MATRIX]
// [Start CONTRAST_COLOR_MATRIX]
/**
 * High Contrast/高对比度效果矩阵 (明暗对比更强烈)
 */
const CONTRAST_COLOR_MATRIX: number[] = [
    1.5, 0, 0, 0, -0.125,
    0, 1.5, 0, 0, -0.125,
    0, 0, 1.5, 0, -0.125,
    0, 0, 0, 1, 0
];
// [End CONTRAST_COLOR_MATRIX]
// [Start CHANNEL_SWAP_MATRIX]
/**
 * Channel Swap/通道交换效果 (RGB→BRG， psychedelic迷幻效果)
 */
const CHANNEL_SWAP_MATRIX: number[] = [
    0, 0, 1, 0, 0,
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 0, 1, 0
];
// [End CHANNEL_SWAP_MATRIX]
// [Start POSTERIZE_MATRIX]
/**
 * Posterize/色调分离效果 (减少颜色层次，海报风格)
 * 通过降低系数实现颜色分层效果
 */
const POSTERIZE_MATRIX: number[] = [
    0.5, 0, 0, 0, 0.1,
    0, 0.5, 0, 0, 0.1,
    0, 0, 0.5, 0, 0.1,
    0, 0, 0, 1, 0
];
// [End POSTERIZE_MATRIX]
// [Start NIGHT_VISION_MATRIX]
/**
 * Night Vision/夜视仪效果 (模拟绿色夜视镜头)
 */
const NIGHT_VISION_MATRIX: number[] = [
    0, 0, 0, 0, 0,
    0.3, 0.6, 0.1, 0, 0.05,
    0, 0, 0, 0, 0,
    0, 0, 0, 1, 0
];
// [End NIGHT_VISION_MATRIX]
// [Start VINTAGE_MATRIX]
/**
 * Vintage/老照片效果 (偏黄褐色 + 降低对比度)
 */
const VINTAGE_MATRIX: number[] = [
    0.6, 0.3, 0.1, 0, 0.05,
    0.2, 0.5, 0.1, 0, 0.02,
    0.1, 0.2, 0.3, 0, 0,
    0, 0, 0, 1, 0
];
// [End VINTAGE_MATRIX]
// [Start FILTER_OPTIONS]
/**
 * List of available filter options for the Radio Group
 */
export const FILTER_OPTIONS: FilterOption[] = [
    { label: 'Original', value: 'original', filter: ORIGINAL_MATRIX },
    { label: 'Retro', value: 'retro', filter: RETRO_COLOR_MATRIX },
    { label: 'Invert', value: 'invert', filter: REVERSE_COLOR_MATRIX },
    { label: 'Enhance', value: 'enhance', filter: ENHANCE_COLOR_MATRIX },
    { label: 'Whiten', value: 'whitening', filter: WHITENING_COLOR_FILTER },
    { label: 'Sepia', value: 'sepia', filter: SEPIA_COLOR_MATRIX },
    { label: 'Cool', value: 'cool', filter: COOL_COLOR_MATRIX },
    { label: 'Warm', value: 'warm', filter: WARM_COLOR_MATRIX },
    { label: 'Contrast', value: 'contrast', filter: CONTRAST_COLOR_MATRIX },
    { label: 'RGB Swap', value: 'swap', filter: CHANNEL_SWAP_MATRIX },
    { label: 'Posterize', value: 'posterize', filter: POSTERIZE_MATRIX },
    { label: 'Night Vision', value: 'nightvision', filter: NIGHT_VISION_MATRIX },
    { label: 'Vintage', value: 'vintage', filter: VINTAGE_MATRIX }
];
// [End FILTER_OPTIONS]
/**
 * Data source for the carousel component.
 * Contains a collection of image resources to be displayed in the gallery.
 */
export const CAROUSEL_DATA_SOURCE: Resource[] = [
    { "id": 16777225, "type": 20000, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" },
    { "id": 16777226, "type": 20000, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" }
];
