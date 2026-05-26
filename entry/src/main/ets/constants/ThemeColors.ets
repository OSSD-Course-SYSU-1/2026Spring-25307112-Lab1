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

/**
 * 应用主题颜色配置
 * 统一应用的视觉风格，包含渐变色、品牌色、功能色等
 */

// 品牌主色 - 紫蓝渐变系
export const PRIMARY_COLOR = '#667eea';
export const SECONDARY_COLOR = '#764ba2';
export const ACCENT_COLOR = '#f093fb';

// 渐变配置
export const PRIMARY_GRADIENT = {
  angle: 90,
  colors: [
    ['#667eea', 0.0],
    ['#764ba2', 1.0]
  ] as [string, number][]
};

export const SPLASH_GRADIENT = {
  angle: 135,
  colors: [
    ['#667eea', 0.0],
    ['#764ba2', 0.5],
    ['#f093fb', 1.0]
  ] as [string, number][]
};

// 文本颜色
export const TEXT_PRIMARY = '#2d3748';
export const TEXT_SECONDARY = '#4a5568';
export const TEXT_TERTIARY = '#8e9aaf';
export const TEXT_ON_PRIMARY = '#ffffff';

// 背景颜色
export const BG_PRIMARY = '#ffffff';
export const BG_SECONDARY = '#f8f9fa';
export const BG_TERTIARY = '#e9ecef';
export const BG_OVERLAY = 'rgba(0, 0, 0, 0.5)';

// 功能色
export const SUCCESS_COLOR = '#48bb78';
export const WARNING_COLOR = '#ed8936';
export const ERROR_COLOR = '#f56565';
export const INFO_COLOR = '#4299e1';

// 阴影配置
export const SHADOW_SMALL = {
  radius: 4,
  color: 'rgba(0, 0, 0, 0.05)',
  offsetX: 0,
  offsetY: 2
};

export const SHADOW_MEDIUM = {
  radius: 12,
  color: 'rgba(0, 0, 0, 0.08)',
  offsetX: 0,
  offsetY: 4
};

export const SHADOW_LARGE = {
  radius: 20,
  color: 'rgba(0, 0, 0, 0.12)',
  offsetX: 0,
  offsetY: 8
};

export const SHADOW_PRIMARY = {
  radius: 12,
  color: 'rgba(102, 126, 234, 0.4)',
  offsetX: 0,
  offsetY: 4
};

// 圆角配置
export const RADIUS_SMALL = 8;
export const RADIUS_MEDIUM = 16;
export const RADIUS_LARGE = 24;
export const RADIUS_ROUND = 999;

// 间距配置
export const SPACING_XS = 4;
export const SPACING_SM = 8;
export const SPACING_MD = 16;
export const SPACING_LG = 24;
export const SPACING_XL = 32;

// 动画时长配置
export const DURATION_FAST = 200;
export const DURATION_NORMAL = 300;
export const DURATION_SLOW = 500;

// 滤镜图标映射
export const FILTER_ICONS: Record<string, string> = {
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

// 参数图标映射
export const PARAM_ICONS: Record<string, string> = {
  'brightness': '💡',
  'contrast': '🔲',
  'saturation': '🎨',
  'hue': '🌈',
  'warmth': '🌡️',
  'exposure': '☀️',
  'gamma': '📊'
};
