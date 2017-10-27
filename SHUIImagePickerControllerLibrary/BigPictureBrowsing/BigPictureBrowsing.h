//
//  BigPictureBrowsing.h
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/6.
//  Copyright © 2017年 pk. All rights reserved.
//  大图浏览

#import <UIKit/UIKit.h>

@interface BigPictureBrowsing : UIView
-(instancetype)initWithImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index;
-(instancetype)initWithImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index;
@end
