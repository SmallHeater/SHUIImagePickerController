//
//  SHUIImagePickerViewController.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  照片选择页面

#import <UIKit/UIKit.h>

@class SHAssetModel;

typedef void(^resultBlock)(NSMutableArray<SHAssetModel *> * selectModelArray);


@protocol SHUIImagePickerProtocol <NSObject>

-(void)finishSelectedWithArray:(NSMutableArray *)array;

@end

@interface SHUIImagePickerViewController : UIViewController

//代理和Block两种回调二选一
@property (nonatomic,strong) resultBlock block;


@property (nonatomic,weak) id<SHUIImagePickerProtocol>delegate;
@end
