//
//  JLImageListView.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

#define kStatusImageWidth 80
#define kStatusImageHeight 80
#define kStatusImageMargin 5

#import "JLImageListView.h"
#import "JLPhotoBrowser.h"

@interface JLImageListView()
/**
 *  imageViews
 */
@property (nonatomic,strong) NSMutableArray *imageViews;
/**
 *  URL数组
 */
@property (nonatomic,strong) NSMutableArray *bigImgUrls;

@end

@implementation JLImageListView

-(NSMutableArray *)imageViews{
    
    if (_imageViews==nil) {
        
        _imageViews = [NSMutableArray array];
        
    }
    
    return _imageViews;
    
}

-(NSMutableArray *)bigImgUrls{
    
    if (_bigImgUrls==nil) {
        
        NSArray *tempUrls = @[
                              @"http://imgsrc.baidu.com/forum/w%3D580/sign=fd6c6565c1cec3fd8b3ea77de689d4b6/3eb24034970a304e61613853d3c8a786c8175c01.jpg",
                              @"http://pic37.nipic.com/20140105/17567471_172229176130_2.jpg",
                              @"http://images.17173.com/2012/news/2012/11/28/2012cpb1128hy33s.jpg",
                              @"http://c.hiphotos.baidu.com/zhidao/pic/item/5ab5c9ea15ce36d3dfdcf9a93af33a87e850b14a.jpg",
                              @"http://pic25.nipic.com/20121126/668573_135748395192_2.jpg",
                              @"http://pic.5442.com/2013/0106/01/09.jpg",
                              @"http://www.bz55.com/uploads/allimg/150709/139-150F9164330-50.jpg",
                              @"http://ww2.sinaimg.cn/large/59a9b7eagw1f0xmliodnkj20u01hcaot.jpg",
                              @"http://5.66825.com/download/pic/000/327/b9fa7606a12d5cd5aa08665e4900eee3.jpg"];
        
        _bigImgUrls = [NSMutableArray arrayWithArray:tempUrls];
        
    }
    
    return _bigImgUrls;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.创建子视图
        [self setupImageViews];
        
    }
    return self;
}

#pragma mark 创建子视图

-(void)setupImageViews{
    
    for (int i = 0; i<9;  i++) {
        
        //1.创建imageView
        UIImageView *child = [[UIImageView alloc] init];
        child.userInteractionEnabled = YES;
        child.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        child.clipsToBounds = YES;
        child.contentMode = UIViewContentModeScaleAspectFill;
        child.tag = i;
        
        //2.添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [child addGestureRecognizer:tap];
        
        //3.设置frame
        // 列数
        int column = i%3;
        // 行数
        int row = i/3;
        // 很据列数和行数算出x、y
        int childX = column * (kStatusImageWidth + kStatusImageMargin);
        int childY = row * (kStatusImageHeight + kStatusImageMargin);
        child.frame = CGRectMake(childX, childY, kStatusImageWidth, kStatusImageHeight);
        
        [self addSubview:child];
        
        [self.imageViews addObject:child];
        
    }
    
}

#pragma mark 图片点击

-(void)imageTap:(UITapGestureRecognizer *)tap{
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<self.imageViews.count; i++) {
        
        UIImageView *child = self.imageViews[i];
        JLPhoto *photo = [[JLPhoto alloc] init];
        photo.sourceImageView = child;
        photo.bigImgUrl = self.bigImgUrls[i];
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    JLPhotoBrowser *photoBrowser = [[JLPhotoBrowser alloc] init];
    photoBrowser.photos = photos;
    photoBrowser.currentIndex = (int)tap.view.tag;
    [photoBrowser show];
}


@end
