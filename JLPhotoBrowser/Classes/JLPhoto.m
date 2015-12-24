//
//  JLPhoto.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

#import "JLPhoto.h"

@implementation JLPhoto

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.userInteractionEnabled  = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return self;
}

@end
