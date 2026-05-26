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
// [Start AdjustParams]
/**
 * Interface for image adjustment parameters
 * Each parameter ranges from 0 to 200, where 100 is the default/neutral value
 */
export interface AdjustParams {
    brightness: number; // 亮度: 0-200, 100=正常
    contrast: number; // 对比度: 0-200, 100=正常
    saturation: number; // 饱和度: 0-200, 100=正常
    hue: number; // 色相旋转: 0-360度
    warmth: number; // 色温: 0-200, 100=正常(冷<100<暖)
    exposure: number; // 曝光: 0-200, 100=正常
    gamma: number; // 伽马: 0-200, 100=正常(1.0)
}
/**
 * Default adjustment parameters (all neutral values)
 */
export const DEFAULT_ADJUST_PARAMS: AdjustParams = {
    brightness: 100,
    contrast: 100,
    saturation: 100,
    hue: 0,
    warmth: 100,
    exposure: 100,
    gamma: 100
};
/**
 * Clamp value to a range
 */
function clamp(value: number, min: number, max: number): number {
    if (isNaN(value) || !isFinite(value)) {
        return (min + max) / 2;
    }
    return Math.max(min, Math.min(max, value));
}
/**
 * Generate a color matrix from adjustment parameters
 * @param params Adjustment parameters
 * @returns 5x4 color matrix array
 */
export function generateAdjustMatrix(params: AdjustParams): number[] {
    // 安全获取参数值，确保在有效范围内
    const brightnessVal = clamp(params.brightness, 0, 200);
    const contrastVal = clamp(params.contrast, 1, 200); // 避免为0
    const saturationVal = clamp(params.saturation, 0, 200);
    const hueVal = clamp(params.hue, 0, 360);
    const warmthVal = clamp(params.warmth, 0, 200);
    const exposureVal = clamp(params.exposure, 0, 200);
    const gammaVal = clamp(params.gamma, 1, 200); // 避免为0
    // 亮度调整 (brightness: 0-200, 100=正常)
    const brightness = (brightnessVal - 100) / 100; // -1 to 1
    // 对比度调整 (contrast: 0-200, 100=正常)
    const contrast = contrastVal / 100; // 0.01 to 2
    // 饱和度调整 (saturation: 0-200, 100=正常)
    const saturation = saturationVal / 100; // 0 to 2
    // 色相旋转角度 (hue: 0-360)
    const hueRad = hueVal * Math.PI / 180;
    const hueCos = Math.cos(hueRad);
    const hueSin = Math.sin(hueRad);
    // 色温调整 (warmth: 0-200, 100=正常)
    const warmthOffset = (warmthVal - 100) / 500; // -0.2 to 0.2
    // 曝光调整 (exposure: 0-200, 100=正常)
    const exposureFactor = (exposureVal - 100) / 50;
    const exposure = Math.pow(2, clamp(exposureFactor, -2, 2)); // 限制在合理范围
    // 伽马调整 (gamma: 0-200, 100=正常, gamma=1.0)
    const gamma = gammaVal / 100; // 0.01 to 2
    // 构建组合矩阵 - 使用更简单安全的方式
    // 基础矩阵：亮度 + 对比度
    const baseMatrix: number[] = [
        contrast, 0, 0, 0, brightness,
        0, contrast, 0, 0, brightness,
        0, 0, contrast, 0, brightness,
        0, 0, 0, 1, 0
    ];
    // 饱和度矩阵
    const satMatrix: number[] = [
        0.213 + 0.787 * saturation, 0.715 - 0.715 * saturation, 0.072 - 0.072 * saturation, 0, 0,
        0.213 - 0.213 * saturation, 0.715 + 0.285 * saturation, 0.072 - 0.072 * saturation, 0, 0,
        0.213 - 0.213 * saturation, 0.715 - 0.715 * saturation, 0.072 + 0.928 * saturation, 0, 0,
        0, 0, 0, 1, 0
    ];
    // 色相旋转矩阵
    const hueMatrix: number[] = [
        0.213 + hueCos * 0.787 - hueSin * 0.213, 0.715 - hueCos * 0.715 - hueSin * 0.715, 0.072 - hueCos * 0.072 + hueSin * 0.928, 0, 0,
        0.213 - hueCos * 0.213 + hueSin * 0.143, 0.715 + hueCos * 0.285 + hueSin * 0.140, 0.072 - hueCos * 0.072 - hueSin * 0.283, 0, 0,
        0.213 - hueCos * 0.213 - hueSin * 0.787, 0.715 - hueCos * 0.715 + hueSin * 0.715, 0.072 + hueCos * 0.928 + hueSin * 0.072, 0, 0,
        0, 0, 0, 1, 0
    ];
    // 色温矩阵
    const warmthMatrix: number[] = [
        1, 0, 0, 0, warmthOffset,
        0, 1, 0, 0, 0,
        0, 0, 1, 0, -warmthOffset,
        0, 0, 0, 1, 0
    ];
    // 曝光矩阵
    const exposureMatrix: number[] = [
        exposure, 0, 0, 0, 0,
        0, exposure, 0, 0, 0,
        0, 0, exposure, 0, 0,
        0, 0, 0, 1, 0
    ];
    // 伽马矩阵 (使用对比度调整来近似伽马校正效果)
    // gamma: 0.01 to 2, 1.0 = 正常
    // gamma < 1.0: 提亮中间调, gamma > 1.0: 压暗中间调
    const gammaContrast = Math.pow(gamma, 0.5); // 使用平方根来平滑效果
    const gammaOffset = (1 - gammaContrast) * 0.5; // 补偿亮度偏移
    const gammaMatrix: number[] = [
        gammaContrast, 0, 0, 0, gammaOffset,
        0, gammaContrast, 0, 0, gammaOffset,
        0, 0, gammaContrast, 0, gammaOffset,
        0, 0, 0, 1, 0
    ];
    // 组合所有矩阵 (乘法顺序很重要)
    let result = multiplyMatrices(exposureMatrix, baseMatrix);
    result = multiplyMatrices(result, satMatrix);
    result = multiplyMatrices(result, hueMatrix);
    result = multiplyMatrices(result, warmthMatrix);
    result = multiplyMatrices(result, gammaMatrix);
    // 确保所有值都是有效的数字
    for (let i = 0; i < result.length; i++) {
        if (isNaN(result[i]) || !isFinite(result[i])) {
            result[i] = ORIGINAL_MATRIX[i];
        }
        // 限制在合理范围内
        result[i] = clamp(result[i], -10, 10);
    }
    return result;
}
/**
 * Multiply two 5x4 color matrices
 */
function multiplyMatrices(a: number[], b: number[]): number[] {
    const result: number[] = new Array(20).fill(0);
    // 5x4 matrix multiplication
    // Each row of a times each column of b
    for (let row = 0; row < 4; row++) {
        for (let col = 0; col < 5; col++) {
            if (col < 4) {
                // 4x4 part
                for (let k = 0; k < 4; k++) {
                    result[row * 5 + col] += a[row * 5 + k] * b[k * 5 + col];
                }
            }
            else {
                // Translation part (last column)
                for (let k = 0; k < 4; k++) {
                    result[row * 5 + 4] += a[row * 5 + k] * b[k * 5 + 4];
                }
                result[row * 5 + 4] += a[row * 5 + 4];
            }
        }
    }
    // Last row (alpha) stays unchanged
    result[16] = 0;
    result[17] = 0;
    result[18] = 0;
    result[19] = 1;
    return result;
}
/**
 * Parameter slider configuration
 */
export interface ParamSliderConfig {
    key: keyof AdjustParams;
    label: string;
    min: number;
    max: number;
    step: number;
    unit: string;
}
/**
 * All parameter slider configurations
 */
export const PARAM_SLIDERS: ParamSliderConfig[] = [
    { key: 'brightness', label: '亮度', min: 0, max: 200, step: 1, unit: '' },
    { key: 'contrast', label: '对比度', min: 0, max: 200, step: 1, unit: '' },
    { key: 'saturation', label: '饱和度', min: 0, max: 200, step: 1, unit: '' },
    { key: 'hue', label: '色相', min: 0, max: 360, step: 1, unit: '°' },
    { key: 'warmth', label: '色温', min: 0, max: 200, step: 1, unit: '' },
    { key: 'exposure', label: '曝光', min: 0, max: 200, step: 1, unit: '' },
    { key: 'gamma', label: '伽马', min: 0, max: 200, step: 1, unit: '' }
];
// [End AdjustParams]
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
