//
//  JLAlbumViewController.m
//  JLPhotoBrowser
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 BangGu. All rights reserved.
//

#import "JLAlbumViewController.h"
#import "JLNavigationController.h"

@interface JLAlbumViewController ()<JLReturnImageDelegate>

@end

@implementation JLAlbumViewController

- (IBAction)btnClick:(id)sender {
    
    [[JLAssetsLibrary shareAssetsLibrary] checkAuthorizationStatus:^(BOOL isAuthorized) {
        
        if (isAuthorized) {
            JLNavigationController *nav = [JLNavigationController navigationAlbumControllerWithDelegate:self];
            [self presentViewController:nav animated:YES completion:NULL];
        }else{
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"未能取得相册访问权限" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
            [alerView show];
        }
        
    }];
    
}

- (void)returnImageDatas:(NSArray *)imageDatas{
    
    
    
}

@end
