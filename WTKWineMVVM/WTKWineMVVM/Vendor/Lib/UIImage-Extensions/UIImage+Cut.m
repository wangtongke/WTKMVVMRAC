//
//  UIImage+Cut.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-5-17.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "UIImage+Cut.h"
#import "UIImage+RoundedCorner.h"
@implementation UIImage (Cut)


- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize
{
    UIImage *newimage;
    UIImage *image = self;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        else{
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize roundedCornerImage:(NSInteger)roundedCornerImage borderSize:(NSInteger)borderSize
{
    UIImage *image = [self clipImageWithScaleWithsize:asize];
    return [image roundedCornerImage:roundedCornerImage borderSize:borderSize];
}

@end
