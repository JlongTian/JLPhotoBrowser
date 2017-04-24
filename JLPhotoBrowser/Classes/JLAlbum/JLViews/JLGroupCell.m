//
//  JLGroupCell.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLGroupCell.h"
#import "JLCommon.h"
#define kLineHeight 0.5

@implementation JLGroupCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *reuseIdentifier = @"groupcell";
    
    JLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        
        cell = [[JLGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //底部黑线
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
        line.position = CGPointMake(90, kCellHeight-kLineHeight);
        line.anchorPoint = CGPointMake(0, 0);
        line.bounds = CGRectMake(0, 0, kMainScreenSize.width-line.position.x, 0.5);
        [cell.layer addSublayer:line];
        
    }
    
    return cell;
    
}

- (void)setGroup:(JLAssetGroup *)group{
    
    _group = group;
    
    self.imageView.image = group.posterImage;
    
    NSString *description = [NSString stringWithFormat:@"%@   (%ld)",group.groupName,group.assetsCount];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:description attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [attStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]} range:NSMakeRange(0, group.groupName.length)];
    self.textLabel.attributedText = attStr;
    
}

@end
