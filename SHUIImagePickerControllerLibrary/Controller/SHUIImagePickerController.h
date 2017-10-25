//
//  SHUIImagePickerController.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  控制器

#import <Foundation/Foundation.h>

@class SHAssetModel;

@interface SHUIImagePickerController : NSObject
+(SHUIImagePickerController *)sharedManager;


//返回包含所有模型的数组
- (void)loadAllPhoto:(void(^)(NSMutableArray<SHAssetModel *> *arr))result;


@end
