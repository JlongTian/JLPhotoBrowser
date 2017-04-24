//
//  JLAlbumCell.h
//  ALAssetsLibrary
//
//  Created by 张天龙 on 17/4/18.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JLSelectedPhotoDelegate.h"

@interface JLAlbumCell : UICollectionViewCell

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,weak) id<JLSelectedPhotoDelegate> delegate;

@end
