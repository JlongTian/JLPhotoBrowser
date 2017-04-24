//
//  JLBadgeView.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBadgeView : UIView

/**
 选中了多少张图片
 */
@property (nonatomic,assign) NSInteger badge;

/**
 设置选中数字

 @param badge 选中多少张
 @param animated 是否需要动画
 */
- (void)setBadge:(NSInteger)badge animated:(BOOL)animated;

+ (instancetype)badgeView;
@end
