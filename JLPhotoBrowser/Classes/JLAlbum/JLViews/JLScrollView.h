//
//  JLScrollView.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/22.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLScrollView : UIScrollView

/**
 设置图片数据
 */
@property (nonatomic,strong) UIImage *image;
/**
 获取需要放大的控件
 */
- (UIView *)getZoomView;

@end

@interface JLScrollViewDelegate : NSObject <UIScrollViewDelegate>

@end
