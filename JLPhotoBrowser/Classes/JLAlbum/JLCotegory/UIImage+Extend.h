//
//  UIImage+Extend.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/22.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 通过颜色获取一张图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 修正图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage ;
- (UIImage *)rotateImageToOrientationUp;
- (UIImage *)rotate90CounterClockwise;

@end
