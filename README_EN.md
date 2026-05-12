# colorFilter-based Image Filter Effect

## Overview

This sample implements an image filter app using the **Image** and **Swiper** components. It demonstrates how to use **colorFilter** to process image colors and implement an image carousel with smooth scale animation, supporting independent filter effect settings for each image.

## Effect
|                   Original                   |                    Retro                     |                    Invert                    |
| :------------------------------------------: | :------------------------------------------: | :------------------------------------------: |
| <img src='./screenshots/pic1.png' width=320> | <img src='./screenshots/pic2.png' width=320> | <img src='./screenshots/pic3.png' width=320> |

|                   Enhance                    |                    Whiten                    |
| :------------------------------------------: | :------------------------------------------: |
| <img src='./screenshots/pic4.png' width=320> | <img src='./screenshots/pic5.png' width=320> |

## How to Use

After installing and launching the app, tap **Retro**, **Invert**, **Enhance**, or **Whiten** below the image to apply the corresponding filter effect. You can also swipe between images to apply filters to different ones.

## Project Directory

```
├──entry/src/main/ets/
│  ├──constants
│  │  └──CommonConstants.ets              // Common constants
│  ├──entryability
│  │  └──EntryAbility.ets                 // Entry ability
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets           // Data backup and restoration
│  └──pages
│     └──Index.ets                        // App entry
└──entry/src/main/resources               // Static resources
```

## How to Implement

Use **colorFilter** to apply color filter effects to images in either of the following ways:

- **4 × 5 color matrix**: You can pass a 4 × 5 RGBA transformation matrix to apply a color filter to an image. For example, **RETRO_COLOR_MATRIX** adjusts the RGB weights to achieve a retro tone.
- **Color filter**: You can pass a color filter created with a specified color and blend mode. For example, **drawing.ColorFilter.createBlendModeColorFilter** brightens images by passing an ARGB color value and applying **BlendMode.PLUS** to overlay a white layer.


## Required Permissions

N/A

## Constraints

1. This sample is only supported on Huawei phones running standard systems.
2. The HarmonyOS version must be HarmonyOS 6.0.0 Release or later.
3. The DevEco Studio version must be DevEco Studio 6.0.0 Release or later.
4. The HarmonyOS SDK version must be HarmonyOS 6.0.0 Release SDK or later.