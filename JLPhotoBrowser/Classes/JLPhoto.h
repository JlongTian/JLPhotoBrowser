//
//  JLPhoto.h
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//  展示放大图片的imageView

#import <UIKit/UIKit.h>

@interface JLPhoto : UIImageView
/**
 *  原始imageView
 */
@property (nonatomic,strong) UIImageView *sourceImageView;
/**
 *  大图URL
 */
@property (nonatomic,strong) NSString *bigImgUrl;

@end
