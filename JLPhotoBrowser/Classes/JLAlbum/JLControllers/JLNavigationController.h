//
//  JLNavigationController.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLAssetsLibrary.h"
#import "JLReturnImageDelegate.h"

@interface JLNavigationController : UINavigationController

@property (nonatomic,weak) id<JLReturnImageDelegate> returnDelegate;

+ (instancetype)navigationAlbumControllerWithDelegate:(id<JLReturnImageDelegate>)delegate;

@end
