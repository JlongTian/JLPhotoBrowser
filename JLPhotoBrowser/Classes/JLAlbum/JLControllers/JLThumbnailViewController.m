//
//  JLThumbnailViewController.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLThumbnailViewController.h"
#import "JLAlbumCell.h"
#import "JLBadgeView.h"
#import "JLBrowserViewController.h"
#import "JLCommon.h"
#import "ALAsset+Associate.h"

#define kColumn 4 //列数
#define kCellMargin 1 //空隙

static NSString *reuseIdentifier = @"albumCellID";

@interface JLThumbnailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JLSelectedPhotoDelegate>

/**
 ALAsset数组
 */
@property (nonatomic,strong) NSArray *assetsArray;
/**
 选中ALAsset数组
 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,weak) UICollectionView *collectionView;
/**
 完成按钮左边的徽章
 */
@property (nonatomic,weak) JLBadgeView *badgeView;
/**
 完成按钮
 */
@property (nonatomic,weak) UIBarButtonItem *completeItem;
/**
 预览按钮
 */
@property (nonatomic,weak) UIBarButtonItem *previewItem;

@end

@implementation JLThumbnailViewController

- (NSMutableArray *)selectedAssets{
    
    if (_selectedAssets==nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.0 设置导航栏，工具条等
    [self setupSelf];
    
    //2.0 创建表格
    [self setupCollectionView];
    
    //3.0 加载Group
    [self loadGroup];
    
}

#pragma mark - 加载数据

- (void)loadGroup{
    
    if (self.group==nil) {
        
        //如果为空默认获取相机胶卷的图片
        [[JLAssetsLibrary shareAssetsLibrary] jl_getCameraRollGroup:^(ALAssetsGroup *group) {
            
            self.group = group;
            self.title = [self.group valueForProperty:kGroupPropertyName];
            [self loadAssets];
            
        } failure:^(NSError *error) {
            
            [self cancelBtnClick];
            
        }];
        
    }else{
        
        [self loadAssets];
        
    }
    
}


/**
 遍历ALAsset
 */
- (void)loadAssets{
    
    [[JLAssetsLibrary shareAssetsLibrary] jl_enumerateAssetsWithGroup:self.group callBack:^(NSArray *assets) {
        
        self.assetsArray = assets;
        [self.collectionView reloadData];
        
    }];
    
}

#pragma mark - 初始化导航栏、工具条等内容

- (void)setupSelf{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTintColor:kTintColor];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 60, 30);
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_back_withtext"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [backBtn addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn setTitleColor:kTintColor forState:UIControlStateNormal];
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[fixedItem,backItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
    self.title = [self.group valueForProperty:kGroupPropertyName];
    
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *completeItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeItemClick)];
    [completeItem setTintColor:[UIColor colorWithRed:253/255.0 green:130/255.0 blue:36/255.0 alpha:1.0]];
    completeItem.enabled = NO;
    self.completeItem = completeItem;
    UIBarButtonItem *tooFlexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *toofixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    toofixedItem.width = -5;
    JLBadgeView *badgeView = [JLBadgeView badgeView];
    UIBarButtonItem *badgeItem = [[UIBarButtonItem alloc] initWithCustomView:badgeView];
    self.badgeView = badgeView;
    
    UIBarButtonItem *previewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(previewItemClick)];
    previewItem.enabled = NO;
    [previewItem setTintColor:kTintColor];
    self.previewItem = previewItem;
    
    self.toolbarItems = @[previewItem,tooFlexibleItem,badgeItem,toofixedItem,completeItem];
    
}

#pragma mark - 预览、返回、完成按钮点击

- (void)previewItemClick{
    
    JLBrowserViewController *browserVc = [[JLBrowserViewController alloc] init];
    browserVc.currentIndex = 0;
    browserVc.assetsArray = self.selectedAssets;
    browserVc.selectedAssets = self.selectedAssets;
    [self.navigationController pushViewController:browserVc animated:YES];
    
}


/**
 返回按钮
 */
- (void)backItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 取消按钮
 */
- (void)cancelBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - 设置表格视图

/**
 *  设置表格视图
 */
-(void)setupCollectionView{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenSize.width, kMainScreenSize.height-kNavigationBarH-kTooBarH) collectionViewLayout:layout];
    collectionView.alwaysBounceVertical = YES;
    [collectionView registerClass:[JLAlbumCell class] forCellWithReuseIdentifier:reuseIdentifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.assetsArray.count;
    
}


/**
 每一个item的宽高
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHW = (kMainScreenSize.width-kCellMargin*2-kCellMargin*(kColumn-1))/kColumn;
    return CGSizeMake(cellHW, cellHW);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JLAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.asset = self.assetsArray[indexPath.row];
    cell.delegate = self;;
    
    return cell;
    
}


/**
 定义组的margin
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(kCellMargin,kCellMargin,kCellMargin, kCellMargin);

}

/**
 设置组每一行之间最小的间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellMargin;
}


/**
 组每一列最小的间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kCellMargin;
}


/**
 返回这个UICollectionView是否可以被选择
 */
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


/**
 UICollectionView被选中时调用的方法
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JLBrowserViewController *browserVc = [[JLBrowserViewController alloc] init];
    browserVc.currentIndex = indexPath.row;
    browserVc.assetsArray = self.assetsArray;
    browserVc.selectedAssets = self.selectedAssets;
    browserVc.delegate = self;
    [self.navigationController pushViewController:browserVc animated:YES];
    
    
}

#pragma mark - SelectedPhotoDelegate

- (void)refreshSelectedAssets:(BOOL)isAdd asset:(ALAsset *)asset refresh:(BOOL)refresh{
    
    if (isAdd) {
        [self.selectedAssets addObject:asset];
    }else{
        [self.selectedAssets removeObject:asset];
    }
    
    [self.badgeView setBadge:self.selectedAssets.count animated:YES];
    self.completeItem.enabled = self.badgeView.badge;
    self.previewItem.enabled = self.badgeView.badge;
    
    if (refresh) {
         [self.collectionView reloadData];
    }
    
}


- (BOOL)checkSelectedCount{
    
    if (self.selectedAssets.count>=9) {
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"你最多只能选择9张图片" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alerView show];
        
        return NO;
    }
    
    return YES;
    
}


- (void)completeItemClick{
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(returnImageDatas:)]) return;
    
    NSMutableArray *datas = [NSMutableArray array];
    
    for (ALAsset *asset in self.selectedAssets) {
    
        [datas addObject:[asset imageData]];
        
    }
    
    [self.delegate returnImageDatas:datas];
    
    [self dismissViewControllerAnimated:NO completion:NULL];
    
}



@end
