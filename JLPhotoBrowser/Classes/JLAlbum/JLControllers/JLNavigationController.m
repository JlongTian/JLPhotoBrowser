//
//  JLNavigationController.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLNavigationController.h"
#import "JLThumbnailViewController.h"
#import "JLALAssetGroupViewController.h"

@interface JLNavigationController ()

@end

@implementation JLNavigationController

+ (instancetype)navigationAlbumControllerWithDelegate:(id<JLReturnImageDelegate>)delegate{
    
    JLALAssetGroupViewController *assetGroupVc = [[JLALAssetGroupViewController alloc] init];
    JLThumbnailViewController *thumbnailVc = [[JLThumbnailViewController alloc] init];
    JLNavigationController *nav = [[JLNavigationController alloc] initWithRootViewController:assetGroupVc];
    thumbnailVc.delegate = nav;
    nav.returnDelegate = delegate;
    [nav pushViewController:thumbnailVc animated:NO];
    
    return nav;
    
}

- (void)returnImageDatas:(NSArray *)imageDatas{
    
    if (self.returnDelegate && [self.returnDelegate respondsToSelector:@selector(returnImageDatas:)]) {
        [self.returnDelegate returnImageDatas:imageDatas];
    }
    
}

@end
