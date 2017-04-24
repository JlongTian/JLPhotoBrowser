//
//  JLReturnImageDelegate.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/24.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JLReturnImageDelegate <NSObject>

/**
 图片二进制数组
 */
- (void)returnImageDatas:(NSArray *)imageDatas;

@end
