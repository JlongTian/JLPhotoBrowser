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
        
        // 加载plist中的字典数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Picture.plist" ofType:nil];
        NSArray *tempUrls = [NSArray arrayWithContentsOfFile:path];
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
        // 3.1 列数
        int column = i%3;
        // 3.2 行数
        int row = i/3;
        // 3.3 很据列数和行数算出x、y
        int childX = column * (kStatusImageWidth + kStatusImageMargin);
        int childY = row * (kStatusImageHeight + kStatusImageMargin);
        child.frame = CGRectMake(childX, childY, kStatusImageWidth, kStatusImageHeight);
        
        [self addSubview:child];
        
        [self.imageViews addObject:child];
        
    }
    
}

#pragma mark 图片点击

-(void)imageTap:(UITapGestureRecognizer *)tap{
    
    //1.创建JLPhoto数组
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<self.imageViews.count; i++) {
        
        UIImageView *child = self.imageViews[i];
        JLPhoto *photo = [[JLPhoto alloc] init];
        //1.1设置原始imageView
        photo.sourceImageView = child;
        //1.2设置大图URL
        photo.bigImgUrl = self.bigImgUrls[i];
        //1.3设置图片tag
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    //2. 创建图片浏览器
    JLPhotoBrowser *photoBrowser = [JLPhotoBrowser photoBrowser];
    //2.1 设置JLPhoto数组
    photoBrowser.photos = photos;
    //2.2 设置当前要显示图片的tag
    photoBrowser.currentIndex = (int)tap.view.tag;
    //2.3 显示图片浏览器
    [photoBrowser show];
}


@end
