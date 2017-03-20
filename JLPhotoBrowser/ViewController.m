//
//  ViewController.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "JLImageListView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    JLImageListView *imageListView = [[JLImageListView alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2, 50, 250, ScreenHeight)];
    [self.view addSubview:imageListView];
    
    
}

-(void)setupImageViews{
    
    
    
}

@end
