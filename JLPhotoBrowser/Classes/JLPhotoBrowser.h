//
//  JLScrollView.h
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//  展示放大图片的滑动视图

#import <UIKit/UIKit.h>
#import "JLPhoto.h"

@interface JLPhotoBrowser : UIView
/**
 *  存放图片的数组
 */
@property (nonatomic,strong) NSArray *photos;
/**
 *  当前的index
 */
@property (nonatomic,assign) int currentIndex;
/**
 *  显示图片浏览器
 */
-(void)show;

@end
