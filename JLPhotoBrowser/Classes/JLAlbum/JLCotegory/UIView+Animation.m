//
//  UIView+Animation.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)startKeyFramesAnimation{
    
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        /*
         * relativeDuration:动画持续时间比例
         * RelativeStartTime:动画开始时间
         */
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1/4.0 animations:^{
            
            self.transform = CGAffineTransformScale(self.transform, 1.3, 1.3);
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/4.0 relativeDuration:2/4.0 animations:^{
            
            self.transform = CGAffineTransformScale(self.transform, 0.7, 0.7);
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:3/4.0 relativeDuration:1/4.0 animations:^{
            
            self.transform = CGAffineTransformIdentity;
            
        }];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
