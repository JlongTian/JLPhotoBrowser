//
//  JLNetworkViewController.m
//  JLPhotoBrowser
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 BangGu. All rights reserved.
//

#import "JLNetworkViewController.h"
#import "JLImageListView.h"
//屏幕宽
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface JLNetworkViewController ()

@end

@implementation JLNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JLImageListView *imageListView = [[JLImageListView alloc] initWithFrame:CGRectMake((kScreenWidth-250)/2, 64+50, 250, kScreenHeight)];
    [self.view addSubview:imageListView];
}




@end
