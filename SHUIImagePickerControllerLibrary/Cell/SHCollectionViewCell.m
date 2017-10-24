//
//  SHCollectionViewCell.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHCollectionViewCell.h"

@implementation SHCollectionViewCell

#pragma mark  ----  生命周期函数

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
     
        [self.contentView addSubview:self.imageView];
        //[self.contentView addSubview:self.checkButton];
    }
    return self;
}

#pragma mark  ----  懒加载
-(UIImageView *)imageView{

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIButton *)checkButton{

    if (!_checkButton) {
        
        _checkButton = [[UIButton alloc] init];
    }
    return _checkButton;
}

@end
