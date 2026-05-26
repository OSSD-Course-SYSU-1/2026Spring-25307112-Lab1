import photoAccessHelper from "@ohos:file.photoAccessHelper";
import type common from "@ohos:app.ability.common";
/**
 * Image picker utility class
 * Provides methods to select images from local storage
 */
export class ImagePickerUtil {
    /**
     * Open photo picker to select images
     * @param context UI ability context
     * @param maxCount Maximum number of images to select (default: 10)
     * @returns Promise with array of selected image URIs
     */
    static async pickImages(context: common.UIAbilityContext, maxCount: number = 10): Promise<string[]> {
        try {
            // Create photo picker options
            const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
            photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
            photoSelectOptions.maxSelectNumber = maxCount;
            // Create photo picker
            const photoPicker = new photoAccessHelper.PhotoViewPicker();
            // Select photos
            const photoSelectResult = await photoPicker.select(photoSelectOptions);
            // Return selected URIs
            if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
                return photoSelectResult.photoUris;
            }
            return [];
        }
        catch (error) {
            console.error('ImagePickerUtil: Failed to pick images', error);
            return [];
        }
    }
    /**
     * Open photo picker to select a single image
     * @param context UI ability context
     * @returns Promise with selected image URI or null
     */
    static async pickSingleImage(context: common.UIAbilityContext): Promise<string | null> {
        const uris = await ImagePickerUtil.pickImages(context, 1);
        return uris.length > 0 ? uris[0] : null;
    }
}
