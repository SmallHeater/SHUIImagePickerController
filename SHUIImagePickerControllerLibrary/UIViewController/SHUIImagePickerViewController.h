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

@interface SHUIImagePickerViewController : UIViewController

@property (nonatomic,strong) resultBlock block;

@end
