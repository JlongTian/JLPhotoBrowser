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

@property (weak, nonatomic) IBOutlet UIView *showView;

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

#pragma mark - JLReturnImageDelegate

- (void)returnImageDatas:(NSArray *)imageDatas{
    
    [self showImage:imageDatas];
    
}

- (void)showImage:(NSArray *)imageDatas{
    
    for (UIView *subView in self.showView.subviews) [subView removeFromSuperview];
    
    CGFloat imageHW = 80;
    CGFloat imageMaegin = 5;
    
    for (int i = 0; i<imageDatas.count;  i++) {
        
        //1.创建imageView
        UIImageView *child = [[UIImageView alloc] init];
        child.userInteractionEnabled = YES;
        child.image = [UIImage imageWithData:imageDatas[i]];
        child.clipsToBounds = YES;
        child.contentMode = UIViewContentModeScaleAspectFill;
        child.tag = i;
        
        //3.设置frame
        // 3.1 列数
        int column = i%3;
        // 3.2 行数
        int row = i/3;
        // 3.3 很据列数和行数算出x、y
        int childX = column * (imageHW + imageMaegin);
        int childY = row * (imageHW + imageMaegin);
        child.frame = CGRectMake(childX, childY, imageHW, imageHW);
        
        [self.showView addSubview:child];
        
    }
    
}

@end
