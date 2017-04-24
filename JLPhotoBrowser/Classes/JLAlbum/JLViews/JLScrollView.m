//
//  JLScrollView.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/22.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLScrollView.h"
#import "JLCommon.h"
#define kMaxH kMainScreenSize.height-kNavigationBarH-kTooBarH

@interface JLScrollView ()

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation JLScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.maximumZoomScale=3.0;
        self.minimumZoomScale=1;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        UITapGestureRecognizer *zonmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zonmTap:)];
        zonmTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:zonmTap];
        self.imageView = imageView;
        
        
        
    }
    return self;
}


/**
 点击两次放大图片
 */
-(void)zonmTap:(UITapGestureRecognizer *)zonmTap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (self.zoomScale==1.0) {
            self.zoomScale = 3.0;
        }else{
            self.zoomScale = 1.0;
        }
        
    }];
    
}

- (UIView *)getZoomView{
    
    return self.imageView;
    
}

- (void)setImage:(UIImage *)image{
    
    self.imageView.image = image;
    
    CGFloat radio = image.size.height/image.size.width;
    CGFloat imageH = kMainScreenSize.width*radio;
    
    if (imageH<kMaxH) {//图片小于scrollView高度的，那么居中处理
        self.imageView.frame = CGRectMake(0, 0, kMainScreenSize.width, kMainScreenSize.width*radio);
        self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
    }else{//图片高度超出scrollView高度的,不做居中处理
        self.imageView.frame = CGRectMake(0, 0, kMainScreenSize.width, kMainScreenSize.width*radio);
    }
    
    //复用的时候要重新设置，这个数据长图和普通图是不一样的
    self.contentSize = CGSizeMake(kMainScreenSize.width, imageH);
    
}

- (void)dealloc{
    
    //scrollView将要销毁的时候要将image置为nil,因为如果是图片类型是JLPhtoTypeFullResolutionImage的话，会开启位图，即使imageView被销毁了，还会过一段时间才会释放，最好手动释放，否则内存暴增
    self.imageView.image = nil;
    
}

@end

@implementation JLScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    JLScrollView *zoomScrollView = (JLScrollView *)scrollView;
    
    return [zoomScrollView getZoomView];
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    JLScrollView *jlScrollView = (JLScrollView *)scrollView;
    UIImageView *photo = (UIImageView *)[jlScrollView getZoomView];
    
    CGFloat photoY = (CGRectGetHeight(scrollView.frame)-photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
}



@end
