//
//  JLBrowserViewController.m
//  ALAssetsLibrary
//
//  Created by 张天龙 on 17/4/18.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JLScrollView.h"
#import "UIImage+Extend.h"
#import "JLBadgeView.h"
#import "UIView+Animation.h"
#import "ALAsset+Associate.h"

#define kMainScreenSize [UIScreen mainScreen].bounds.size
#define kNavigationBarH 64
#define kTooBarH 44

typedef enum : NSUInteger {
    JLScrollViewTypeLeft,//左边的scrollView
    JLScrollViewTypeMid,//中间的……
    JLScrollViewTypeRight,//右边的……
} JLScrollViewType;

//scrollView移动的方向
typedef enum : NSUInteger {
    JLDirectionNone,//还在原来的位置
    JLDirectionRight,//往右移动
    JLDirectionLeft,//往左移动
} JLDirection;

//图片类型
typedef enum : NSUInteger {
    JLPhtoTypeAspectRatioThumbnail,//按照比例的缩略图
    JLPhtoTypeFullResolutionImage,//原始图片
    JLPhtoTypeFullScreenImage,//全屏图
} JLPhtoType;

@interface JLBrowserViewController ()<UIScrollViewDelegate>
/**
 底部的scrollView
 */
@property (nonatomic,weak) UIScrollView *bigScrollView;
/**
 装着三个scrollView的数组
 */
@property (nonatomic,strong) NSMutableArray *scrollViews;
/**
 将复用的scrollView的delegate回调方法都放里面
 */
@property (nonatomic,strong) JLScrollViewDelegate *scrollViewDelegate;
/**
 完成按钮左边的徽章
 */
@property (nonatomic,weak) JLBadgeView *badgeView;
/**
 完成按钮
 */
@property (nonatomic,weak) UIBarButtonItem *completeItem;
/**
 选择按钮
 */
@property (nonatomic,weak) UIButton *selectedBtn;

@end

@implementation JLBrowserViewController

- (JLScrollViewDelegate *)scrollViewDelegate{
    
    if (_scrollViewDelegate==nil) {
        _scrollViewDelegate = [[JLScrollViewDelegate alloc] init];
    }
    
    return _scrollViewDelegate;
    
}

- (NSMutableArray *)scrollViews{
    
    if (_scrollViews==nil) {
        _scrollViews = [NSMutableArray array];
    }
    
    return _scrollViews;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.0 设置导航栏、工具条等
    [self setupSelf];
    
    //2.0 设置背景的ScrollView
    [self setupBigScrollView];
    
    //3.0 创建三个复用的scrollView
    [self creatScrollViews];
    
    //4.0 为scrollView设置图片等
    [self setupScrollViews];
    
}

#pragma mark - 设置导航栏、工具条相关

- (void)setupSelf{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    CGFloat selectedHW = 32;
    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, selectedHW, selectedHW)];
    [selectedBtn setImage:[UIImage imageNamed:@"compose_guide_check_box_default"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"compose_guide_check_box_right"] forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectedItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];;
    self.selectedBtn = selectedBtn;
    self.navigationItem.rightBarButtonItem = selectedItem;

    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeItemClick)];
    [completeItem setTintColor:[UIColor colorWithRed:253/255.0 green:130/255.0 blue:36/255.0 alpha:1.0]];
    completeItem.enabled = NO;
    self.completeItem = completeItem;
    UIBarButtonItem *tooFlexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *toofixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    toofixedItem.width = -5;
    JLBadgeView *badgeView = [JLBadgeView badgeView];
    UIBarButtonItem *badgeItem = [[UIBarButtonItem alloc] initWithCustomView:badgeView];
    self.badgeView = badgeView;
    [self refreshBadge:NO];
   
    self.toolbarItems = @[tooFlexibleItem,badgeItem,toofixedItem,completeItem];
    
}

- (void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)completeItemClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeItemClick)]) {
        [self.delegate completeItemClick];
    }
    
}

- (void)selectedBtnClick:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkSelectedCount)] && !btn.selected) {
        
        if (![self.delegate checkSelectedCount]) return;
        
    }
    
    btn.selected = !btn.selected;
    ALAsset *asset = self.assetsArray[self.currentIndex];
    asset.selected = btn.selected;
    
    if (btn.selected) [btn startKeyFramesAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshSelectedAssets:asset:refresh:)]) {
        [self.delegate refreshSelectedAssets:btn.selected asset:asset refresh:YES];
    }
    
    [self refreshBadge:YES];
    
}

- (void)refreshBadge:(BOOL)animated{
    
    self.badgeView.badge = self.selectedAssets.count;
    [self.badgeView setBadge:self.selectedAssets.count animated:animated];
    self.completeItem.enabled = self.badgeView.badge;
    
}

#pragma mark -  设置背景scrollView和复用的三个scrollView

/**
 设置大的滑动视图
 */
- (void)setupBigScrollView{
    
    UIScrollView *bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSize.width,kMainScreenSize.height-kNavigationBarH-kTooBarH)];
    bigScrollView.showsHorizontalScrollIndicator = NO;
    
    bigScrollView.pagingEnabled = YES;
    bigScrollView.delegate = self;
    bigScrollView.contentSize = CGSizeMake(kMainScreenSize.width*self.assetsArray.count, 0);
    bigScrollView.contentOffset = CGPointMake(kMainScreenSize.width*self.currentIndex, 0);
    [self.view addSubview:bigScrollView];
    self.bigScrollView = bigScrollView;
    
}


/**
 创建scrollView数组
 */
- (void)creatScrollViews{
    
    for (int i=0; i<3; i++) {
        
        JLScrollView *smallScrollView = [[JLScrollView alloc] initWithFrame:CGRectMake(0,0, kMainScreenSize.width,kMainScreenSize.height-kNavigationBarH-kTooBarH)];
        
        smallScrollView.delegate = self.scrollViewDelegate;
        [self.scrollViews addObject:smallScrollView];
        
    }
    
    
    
}


/**
 设置3个scrollView的尺寸和显示的图片等
 */
- (void)setupScrollViews{
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.assetsArray.count];
    ALAsset *asset = self.assetsArray[self.currentIndex];
    self.selectedBtn.selected = asset.selected;
    
    [self setupScrollViewWithIndex:self.currentIndex type:JLScrollViewTypeMid];
    
    
    
    if (self.currentIndex+2<=self.assetsArray.count) {
        
        [self setupScrollViewWithIndex:self.currentIndex+1 type:JLScrollViewTypeRight];
    }
    
    if (self.currentIndex>0) {
        [self setupScrollViewWithIndex:self.currentIndex-1 type:JLScrollViewTypeLeft];
    }
    
    
    
}

#pragma mark - 初始化图片数据

/**
 设置scrollView的图片和尺寸

 @param index 下标
 @param type scrollView类型
 */
- (void)setupScrollViewWithIndex:(NSInteger)index type:(JLScrollViewType)type{
    
    ALAsset *asset = self.assetsArray[index];
    JLScrollView *scrollView = self.scrollViews[type];
    
    [self async_setupImageForScrollView:scrollView asset:asset photoType:JLPhtoTypeAspectRatioThumbnail];

    if (type==JLScrollViewTypeMid) {
        
        [self async_setupImageForScrollView:scrollView asset:asset photoType:JLPhtoTypeFullScreenImage];
        
    }
    CGRect frame = scrollView.frame;
    frame.origin.x = kMainScreenSize.width*(index);
    scrollView.frame = frame;
    
    [self.bigScrollView addSubview:scrollView];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    JLDirection direction = [self setupDirection:*targetContentOffset];
    self.currentIndex = (*targetContentOffset).x/kMainScreenSize.width;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.assetsArray.count];
    [self reuseScrollView:*targetContentOffset direction:direction];
    
}

#pragma mark - 判断滑动方向、复用scrollView、刷新图片数据等


- (JLDirection)setupDirection:(CGPoint)targetContentOffset{
    
    CGFloat difference = targetContentOffset.x-kMainScreenSize.width*self.currentIndex;
    
    JLDirection direction = JLDirectionNone;
    if (difference>0) {
        direction = JLDirectionRight;
    }else if (difference<0){
        direction = JLDirectionLeft;
    }
    
    return direction;
    
}


/**
 根据滑动方向复用scrollView，重新设置图片等数据

 @param targetContentOffset 目标ContentOffset
 @param direction 方向
 */
- (void)reuseScrollView:(CGPoint)targetContentOffset direction:(JLDirection)direction{
    
    //没有真正滑动不需要刷新
    if (direction==JLDirectionNone) return;
    
    //更新选择按钮状态
    ALAsset *asset = self.assetsArray[self.currentIndex];
    self.selectedBtn.selected = asset.selected;
    
    JLScrollView *reuseScrollView = nil;
    
    
    /*
     * 1.如果滑动的方向是右边，那么就取出数组首个元素，重新设置位置，图片等信息，并将复用的元素插入到数组最后；同理，如果滑动的方向是左边，那么取出数组最后一个元素，重新设置位置，图片等信息，并将复用的元素插入到数组最前面。
     * 2.如果当前的位置是第一张或者最后一张，数组仍然要改动，但是不用重新设置位置和图片信息，因为第一张左边没有图片，最后一张右边没有图片。如果滑到第一张，没有更新数组，那么当前显示出来的scrollView就是数组首个元素，当用户向左滑动的时候，第一张图的scrollview拿去复用了，还没退出屏幕就被拿到后面复用了，会发现第一张图突然消失，最后一张图也是如此。
     */
    if (direction==JLDirectionRight) {
        reuseScrollView = self.scrollViews[JLScrollViewTypeLeft];
        [self.scrollViews removeObject:reuseScrollView];
        [self.scrollViews insertObject:reuseScrollView atIndex:JLScrollViewTypeRight];
    }else if(direction==JLDirectionLeft){
        reuseScrollView = self.scrollViews[JLScrollViewTypeRight];
        [self.scrollViews removeObject:reuseScrollView];
        [self.scrollViews insertObject:reuseScrollView atIndex:JLScrollViewTypeLeft];
    }
    
    //刷新中间的高清大图
    [self async_setupImageForScrollView:self.scrollViews[JLScrollViewTypeMid] asset:self.assetsArray[self.currentIndex] photoType:JLPhtoTypeFullScreenImage];
    
    //刚刚退出屏幕的那张图每次滑动都要缩放比例都要置为1.0
    UIScrollView *pastScrollView = nil;
    if (direction==JLDirectionRight) {
        pastScrollView = self.scrollViews[JLScrollViewTypeLeft];
    }else{
        pastScrollView = self.scrollViews[JLScrollViewTypeRight];
    }
    pastScrollView.zoomScale = 1.0;
    
    //如果发现是第一张或者是最后一张不用刷新frame
    if (self.currentIndex==0 || self.currentIndex==self.assetsArray.count-1) return;
    
    CGRect frame = reuseScrollView.frame;
    
    if (direction==JLDirectionRight) {
        
        //修改frame
        frame.origin.x = kMainScreenSize.width*(self.currentIndex+1);
        
        //异步刷新图片
        [self async_setupImageForScrollView:reuseScrollView asset:self.assetsArray[self.currentIndex+1] photoType:JLPhtoTypeAspectRatioThumbnail];
        /*
         * 如果往右移动的话，原来处于mid的图片移动到屏幕左边去了，成了数组第一个元素，但是此时图片还没有释放，所以需要重新将缩略图给它，不然内存里面会有两张大图，除了中间那张
         * 右滑动就将第一个元素置为小图，左滑动就将最后一个元素置为小图
         */
        [self async_setupImageForScrollView:self.scrollViews[JLScrollViewTypeLeft] asset:self.assetsArray[self.currentIndex-1] photoType:JLPhtoTypeAspectRatioThumbnail];
        
        
    }else if (direction==JLDirectionLeft){
        
        frame.origin.x = kMainScreenSize.width*(self.currentIndex-1);
        [self async_setupImageForScrollView:reuseScrollView asset:self.assetsArray[self.currentIndex-1] photoType:JLPhtoTypeAspectRatioThumbnail];
        [self async_setupImageForScrollView:self.scrollViews[JLScrollViewTypeRight] asset:self.assetsArray[self.currentIndex+1] photoType:JLPhtoTypeAspectRatioThumbnail];
        
    }
    
    reuseScrollView.frame = frame;
    //添加多少次都没问题
    [self.bigScrollView addSubview:reuseScrollView];
    
}


/**
 开启线程设置scrollView的图片
 
 @param scrollView scrollView description
 @param asset asset description
 @param photoType 获取图片的类型
 */
- (void)async_setupImageForScrollView:(JLScrollView *)scrollView asset:(ALAsset *)asset photoType:(JLPhtoType)photoType{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self setupImageForScrollView:scrollView asset:asset photoType:photoType];
        
    });
    
}

/**
 设置scrollView的图片
 
 @param scrollView scrollView description
 @param asset asset description
 */
- (void)setupImageForScrollView:(JLScrollView *)scrollView asset:(ALAsset *)asset photoType:(JLPhtoType)photoType{
    
    UIImage *image = nil;
    switch (photoType) {
        case JLPhtoTypeAspectRatioThumbnail://缩略图
        {
            image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        }
            break;
        case JLPhtoTypeFullScreenImage://全屏图
        {
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }
            break;
        case JLPhtoTypeFullResolutionImage://原始图片
        {
            
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            
            
        }
            break;
            
        default:
            break;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
        scrollView.image = image;
       
    });
    
}

@end
