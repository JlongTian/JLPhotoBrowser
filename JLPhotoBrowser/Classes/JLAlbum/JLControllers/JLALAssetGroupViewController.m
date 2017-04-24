//
//  JLALAssetGroupViewController.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLALAssetGroupViewController.h"
#import "JLThumbnailViewController.h"
#import "JLAssetGroup.h"
#import "JLAssetsLibrary.h"
#import "JLGroupCell.h"
#import "JLCommon.h"

@interface JLALAssetGroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
/**
 相册模型数组
 */
@property (nonatomic,copy) NSArray *groups;
@end

@implementation JLALAssetGroupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.0 初始化导航栏等……
    [self setupSelf];
    
    //2.0 创建tableView
    [self setupTableView];
    
    //3.0 获取相册数组
    [self loadGroups];
    
}

- (void)setupSelf{
    
    self.navigationController.toolbarHidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.title = @"照片";
    
}

- (void)setupTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSize.width, kMainScreenSize.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)loadGroups{
    
    [[JLAssetsLibrary shareAssetsLibrary] jl_enumeratePhotoGroups:^(NSArray *groups) {
        
        self.groups = groups;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self cancelBtnClick];
        
    }];
    
}

- (void)cancelBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kCellHeight;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.groups.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JLGroupCell *cell = [JLGroupCell cellWithTableView:tableView];
    cell.group = self.groups[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JLAssetGroup *group = self.groups[indexPath.row];
    JLThumbnailViewController *thumbnailVc = [[JLThumbnailViewController alloc] init];
    thumbnailVc.group = group.group;
    [self.navigationController pushViewController:thumbnailVc animated:YES];
    
}



@end
