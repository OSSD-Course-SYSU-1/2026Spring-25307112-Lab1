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

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';

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
    } catch (error) {
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
