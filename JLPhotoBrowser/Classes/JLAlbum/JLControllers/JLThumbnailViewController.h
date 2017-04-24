//
//  JLThumbnailViewController.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/20.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLAssetsLibrary.h"
#import "JLAssetGroup.h"
#import "JLReturnImageDelegate.h"

@interface JLThumbnailViewController : UIViewController
@property (nonatomic,strong) ALAssetsGroup *group;
@property (nonatomic,weak) id<JLReturnImageDelegate> delegate;
@end
