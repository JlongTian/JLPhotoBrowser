//
//  JLAlbumCell.m
//  ALAssetsLibrary
//
//  Created by 张天龙 on 17/4/18.
//  Copyright © 2017年 张天龙. All rights reserved.
//

#import "JLAlbumCell.h"
#import "UIView+Animation.h"
#import "ALAsset+Associate.h"

@interface JLAlbumCell ()
/**
 缩略图
 */
@property (nonatomic,weak) UIImageView *thumbnailView;
/**
 选择按钮
 */
@property (nonatomic,weak) UIButton *selectedBtn;

@end

@implementation JLAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *thumbnailView = [[UIImageView alloc]init];
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        
        UIButton *selectedBtn = [[UIButton alloc] init];
        [selectedBtn setImage:[UIImage imageNamed:@"compose_guide_check_box_default"] forState:UIControlStateNormal];
        [selectedBtn setImage:[UIImage imageNamed:@"compose_guide_check_box_right"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectedBtn];
        [selectedBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedBtn = selectedBtn;
        
        
        
    }
    return self;
}


- (void)selectedBtnClick:(UIButton *)btn{
    
    //btn.selected==NO的情况下说明是要添加选中图片，要检查
    if (self.delegate && !btn.selected && [self.delegate respondsToSelector:@selector(checkSelectedCount)]) {
        
        if (![self.delegate checkSelectedCount]) return;
        
    }
    
    btn.selected = !btn.selected;
    self.asset.selected = btn.selected;
    
    if (btn.selected) [btn startKeyFramesAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshSelectedAssets:asset:refresh:)]) {
        [self.delegate refreshSelectedAssets:btn.selected asset:self.asset refresh:NO];
    }
    
    
}

- (void)setAsset:(ALAsset *)asset{
    
    if (_asset!=asset) {
        _asset = asset;
        self.thumbnailView.image = [UIImage imageWithCGImage:asset.thumbnail];
        self.selectedBtn.selected = asset.selected;
        
    }
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.thumbnailView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat selectedHW = 32;
    self.selectedBtn.frame = CGRectMake(self.frame.size.width-selectedHW, 0,selectedHW , selectedHW);
    
}

@end
