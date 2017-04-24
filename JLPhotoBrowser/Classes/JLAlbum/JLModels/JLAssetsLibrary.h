//
//  JLAssetsLibrary.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *const kCameraRoll = @"Camera Roll";
static NSString *const kGroupPropertyName = @"ALAssetsGroupPropertyName";

typedef void(^CheckCallBack)(BOOL isAuthorized);

@interface JLAssetsLibrary : ALAssetsLibrary

+ (instancetype)shareAssetsLibrary;


/**
 获取所有的图片ALAssetsGroup

 @param callBack 成功回调
 @param failure 失败回调
 */
- (void)jl_enumeratePhotoGroups:(void (^)(NSArray *groups))callBack failure:(void (^)(NSError *error))failure;

/**
 通过名字为“Camera Roll”的ALAssetsGroup

 @param callBack callBack description
 @param failure 失败回调
 */
- (void)jl_getCameraRollGroup:(void (^)(ALAssetsGroup *group))callBack failure:(void (^)(NSError *error))failure;

/**
 通过ALAssetsGroup获取ALAssets

 @param group group description
 @param callBack callBack description
 */
- (void)jl_enumerateAssetsWithGroup:(ALAssetsGroup *)group callBack:(void (^)(NSArray *assets))callBack;

/**
 检查相册授权

 @param checkCallBack checkCallBack description
 */
- (void)checkAuthorizationStatus:(CheckCallBack)checkCallBack;


@end
