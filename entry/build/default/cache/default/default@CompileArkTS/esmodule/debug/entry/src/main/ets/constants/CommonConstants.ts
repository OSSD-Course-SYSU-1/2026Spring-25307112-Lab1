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
    { "id": 16777225, "type": 20000, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" },
    { "id": 16777226, "type": 20000, params: [], "bundleName": "com.example.imagefilter", "moduleName": "entry" }
];
