//
//  UIImage+WTK.h
//  WTKWineMVVM
//
//  Created by 王同科 on 16/9/12.
//  Copyright © 2016年 王同科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WTK)
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize;
//返回一张自由拉伸的图片
+(UIImage *)resizedImageWithName:(NSString *)name;
//返回一张自由调整大小的图片
+(UIImage *)newImageWithNamed:(NSString *)name
                         size:(CGSize)size;
///改变一张图片的大小
+ (UIImage *)changeImageSize:(UIImage *)icon AndSize:(CGSize)size;
//根据颜色值生成纯色图片
+ (UIImage *)createImageWithColor:(UIColor *)color
                            frame:(CGRect)frame;
//生成图片
- (UIImage*)transformWidth:(CGFloat)width
                    height:(CGFloat)height;
+ (UIImage *)imageFromColor:(UIColor *)color;
//原图输出
+ (UIImage *)imageWithName:(NSString *)name size:(CGSize)size;
+ (UIImage *)resizedImage:(NSString *)name;
+ (UIImage *)imageWithOriginal:(NSString *)imageName;
//毛玻璃
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
/**
 *  获取当前window的毛玻璃
 */
+ (UIImage *)getApplyImageViewInView:(UIView *)view;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

///修正图片方向（从照片，相机获取的）
+(UIImage *)fixOrientation:(UIImage *)aImage;

@end
