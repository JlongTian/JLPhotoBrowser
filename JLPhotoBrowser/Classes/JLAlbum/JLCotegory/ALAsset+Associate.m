//
//  ALAsset+Associate.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "ALAsset+Associate.h"
#import <objc/runtime.h>

@implementation ALAsset (Associate)

static char selectedKey;

- (void)setSelected:(BOOL)selected{
    
    objc_setAssociatedObject(self, &selectedKey, [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (BOOL)selected{
    
    return [objc_getAssociatedObject(self, &selectedKey) boolValue];
    
}

- (NSData *)imageData{
    
    ALAssetRepresentation *assetRep = [self defaultRepresentation];
    long long size = [assetRep size];
    uint8_t *buff = malloc(size);
    
    NSError *err = nil;
    NSUInteger gotByteCount = [assetRep getBytes:buff fromOffset:0 length:size error:&err];
    
    if (gotByteCount) {
        if (err) {
            free(buff);
            return nil;
        }
    }
    
    return [NSData dataWithBytesNoCopy:buff length:size freeWhenDone:YES];
}

@end
