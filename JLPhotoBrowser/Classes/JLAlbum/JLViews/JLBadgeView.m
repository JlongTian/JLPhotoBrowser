//
//  JLBadgeView.m
//  JLPhotoAlbum
//
//  Created by 张天龙 on 17/4/21.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLBadgeView.h"
#import "UIView+Animation.h"

@interface JLBadgeView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation JLBadgeView

+(instancetype)badgeView{
    
    JLBadgeView *badgeView = [[[NSBundle mainBundle] loadNibNamed:@"JLBadgeView" owner:nil options:nil] lastObject];
    return badgeView;
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.imageView.image = [UIImage imageNamed:@"camera_image_capture_badge"];
    
}

- (void)setBadge:(NSInteger)badge{
    
    _badge = badge;
    
    self.hidden = !_badge;
    
    self.label.text = [NSString stringWithFormat:@"%ld",_badge];
    
}

- (void)setBadge:(NSInteger)badge animated:(BOOL)animated{
    
    self.badge = badge;
    
    if (animated) {
        [self.imageView startKeyFramesAnimation];
    }
    
}



@end
