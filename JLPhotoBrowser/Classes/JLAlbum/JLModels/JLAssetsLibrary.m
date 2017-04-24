//
//  JLAssetsLibrary.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLAssetsLibrary.h"
#import "JLAssetGroup.h"
#import <Photos/Photos.h>

static JLAssetsLibrary *_library;

@interface JLAssetsLibrary ()

@end

@implementation JLAssetsLibrary

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    @synchronized (self) {
        
        if (!_library) {
            _library = [super allocWithZone:zone];
        }
        
    }
    return _library;
}

+ (instancetype)shareAssetsLibrary{
    
    @synchronized (self) {
        if (!_library) {
            _library = [[self alloc] init];
        }
    }
    
    return _library;
    
}

- (id)copyWithZone:(NSZone *)zone{
    
    return _library;
    
}

- (void)jl_enumeratePhotoGroups:(void (^)(NSArray *))callBack failure:(void (^)(NSError *))failure{
    
    @synchronized (self) {
        
        NSMutableArray *groups = [NSMutableArray array];
        
        [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (!group) {
                
                callBack(groups);
                
            }else{
                
                NSInteger assetCount = [group numberOfAssets];
                
                if (assetCount) {
                    JLAssetGroup *assetGroup = [[JLAssetGroup alloc] init];
                    assetGroup.group = group;
                    assetGroup.groupName = [group valueForProperty:kGroupPropertyName];
                    assetGroup.posterImage = [UIImage imageWithCGImage:[group posterImage]];
                    assetGroup.assetsCount = [group numberOfAssets];
                    [groups addObject:assetGroup];
                }
                
            }
            
        } failureBlock:^(NSError *error) {
            failure(error);
        }];
    }
    
}

- (void)jl_getCameraRollGroup:(void (^)(ALAssetsGroup *))callBack failure:(void (^)(NSError *))failure{
    
    @synchronized (self) {
        
        [self enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (group) {
                
                NSString *groupName = [group valueForProperty:kGroupPropertyName];
                
                if ([groupName isEqualToString:kCameraRoll]) {
                    
                    callBack(group);
                    *stop = YES;
                }
            }
            
        } failureBlock:^(NSError *error) {
            failure(error);
        }];
    }
    
}

- (void)jl_enumerateAssetsWithGroup:(ALAssetsGroup *)group callBack:(void (^)(NSArray *))callBack{
    
    @synchronized (self) {
        
        NSMutableArray *assets = [NSMutableArray array];
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (!result) {
                
                callBack(assets);
                
            }else{
                [assets addObject:result];
                
            }
        }];
    }
    
}

- (void)checkAuthorizationStatus:(CheckCallBack)checkCallBack{
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 8.0) { // iOS系统版本 >= 8.0
        [self checkAuthorizationStatus_BeforeiOS8:checkCallBack];
    } else{ //iOS系统版本 < 8.0
        [self checkAuthorizationStatus_AfteriOS8:checkCallBack];
    }
    
}

- (void)checkAuthorizationStatus_AfteriOS8:(CheckCallBack)checkCallBack
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusNotDetermined:
        {
            [self requestAuthorizationStatus_AfteriOS8:checkCallBack];
            
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            if (checkCallBack) checkCallBack(NO);
            break;
        }
        case PHAuthorizationStatusAuthorized:
        {
            if (checkCallBack) checkCallBack(YES);

        }
        default:
        {
            
            break;
        }
    }
}



- (void)checkAuthorizationStatus_BeforeiOS8:(CheckCallBack)checkCallBack{
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status)
    {
        case ALAuthorizationStatusNotDetermined:
        {
            [self requestAuthorizationStatus_AfteriOS8:checkCallBack];
            break;
        }
        case ALAuthorizationStatusRestricted:
        case ALAuthorizationStatusDenied:
        {
            if (checkCallBack) checkCallBack(NO);
            break;
        }
        case ALAuthorizationStatusAuthorized:
        {
            if (checkCallBack) checkCallBack(YES);
        }
        default:
        {
            
            break;
        }
    }
}

- (void)requestAuthorizationStatus_AfteriOS8:(CheckCallBack)checkCallBack
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        
        //这个回调在其他线程，需要主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    if (checkCallBack) checkCallBack(YES);
                    break;
                }
                default:
                {
                    if (checkCallBack) checkCallBack(NO);
                    break;
                }
            }
            
        });
        
    }];
    
}



@end
