//
//  ALAsset+Associate.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (Associate)

/**
 是否选中
 */
@property (nonatomic,assign) BOOL selected;

/**
 获取ALAsset的二进制数据
 */
- (NSData *)imageData;

@end
