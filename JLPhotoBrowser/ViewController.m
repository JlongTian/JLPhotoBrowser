//
//  ViewController.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kCellHeight 64
#define kLineHeight 0.5
#define kTintColor [UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0]

#import "ViewController.h"
#import "JLNetworkViewController.h"
#import "JLAlbumViewController.h"

NSString *const kNetworkPhotoBrowser = @"网络图片浏览";
NSString *const kAlbumPicker = @"访问本地相册";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = kTintColor;
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //底部黑线
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        line.position = CGPointMake(10, kCellHeight-kLineHeight);
        line.anchorPoint = CGPointMake(0, 0);
        line.bounds = CGRectMake(0, 0,kScreenWidth-line.position.x, 0.5);
        [cell.layer addSublayer:line];
    }
    
    NSString *decription = nil;
    
    if (indexPath.row==0) {
        decription = kNetworkPhotoBrowser;
    }else{
        decription = kAlbumPicker;
    }
    
    NSDictionary *Attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:decription attributes:Attributes];
    
    cell.textLabel.attributedText = attStr;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            JLNetworkViewController *networkVc = [[JLNetworkViewController alloc] init];
            networkVc.title = kNetworkPhotoBrowser;
            [self.navigationController pushViewController:networkVc animated:YES];
        }
            break;
        case 1:
        {
            JLAlbumViewController *albumVc = [[JLAlbumViewController alloc] init];
            albumVc.title = kAlbumPicker;
            [self.navigationController pushViewController:albumVc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}


@end
