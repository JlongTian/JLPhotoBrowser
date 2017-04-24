//
//  JLBrowserViewController.h
//  ALAssetsLibrary
//
//  Created by 张天龙 on 17/4/18.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JLSelectedPhotoDelegate.h"

@interface JLBrowserViewController : UIViewController

/**
 展示ALAsset数组
 注意：预览和大图浏览都用这个，如果不用copy，预览的时候assetsArray和selectedAssets属于同一个数组，selectedAssets删除操作会影响到assetsArray数组的展示
 */
@property (nonatomic,copy) NSArray *assetsArray;
/**
 选中ALAsset数组
 */
@property (nonatomic,strong) NSArray *selectedAssets;
/**
 当前处于哪一张图片
 */
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,weak) id<JLSelectedPhotoDelegate> delegate;

@end
