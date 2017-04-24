//
//  JLAssetGroup.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JLAssetGroup : NSObject
/**
 *  组名
 */
@property (nonatomic,copy) NSString *groupName;
/**
 *  封面图
 */
@property (nonatomic,strong) UIImage *posterImage;;
/**
 *  组里面的图片个数
 */
@property (nonatomic , assign) NSInteger  assetsCount;
/**
 *  类型
 */
@property (nonatomic,copy) NSString  *type;
/**
 * 组
 */
@property (nonatomic , strong) ALAssetsGroup *group;
@end
