//
//  JLGroupCell.h
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLAssetGroup.h"

#define kCellHeight 64

@interface JLGroupCell : UITableViewCell

@property (nonatomic,strong) JLAssetGroup *group;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
