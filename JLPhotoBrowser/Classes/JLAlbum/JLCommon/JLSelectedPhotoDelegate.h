//
//  CommonProtocol.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JLSelectedPhotoDelegate <NSObject>

/**
 检查选中的图片是否超过了9

 @return 是否可以继续添加图片
 */
- (BOOL)checkSelectedCount;

/**
 刷新按钮状态

 @param isAdd 是否是添加照片
 @param asset asset description
 @param refresh 是否需要刷新CollectionView
 */
- (void)refreshSelectedAssets:(BOOL)isAdd asset:(ALAsset *)asset refresh:(BOOL)refresh;

/**
 完成按钮点击
 */
- (void)completeItemClick;


@end
