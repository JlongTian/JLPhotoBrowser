//
//  JLPieProgressView.m
//  ProgressViewTest
//
//  Created by 张天龙 on 17/3/28.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "JLPieProgressView.h"

#define kInnerCircleRadius 10
#define kOuterCircleRadius kInnerCircleRadius*2+2
#define kStartAngle -M_PI/2
#define kEndAngle(progress)  kStartAngle+M_PI*2*progress
#define JLColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation JLPieProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgressValue:(CGFloat)progressValue{
    
    _progressValue = progressValue;
    if (self.tag==1) {
        NSLog(@"%f",progressValue);
    }
    if (progressValue==1.0) {
        self.hidden = YES;
    }else{
        //重绘
        [self setNeedsDisplay];
    }
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画外圆
    [JLColor(255.0, 255.0, 255.0, 0.8) set];
    
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2,kOuterCircleRadius,0 , M_PI*2, 0);
    CGContextStrokePath(ctx);
    ;
    //画内圆
    CGContextSetLineWidth(ctx, kInnerCircleRadius*2);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, kInnerCircleRadius,kStartAngle , kEndAngle(_progressValue), 0);
    CGContextStrokePath(ctx);
    
}

@end
