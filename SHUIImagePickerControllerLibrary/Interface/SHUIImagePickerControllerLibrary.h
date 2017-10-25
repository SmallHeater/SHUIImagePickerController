//
//  SHUIImagePickerControllerLibrary.h
//  SHUIImagePickerControllerLibrary
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  接口类

#import <Foundation/Foundation.h>
#import "SHAssetModel.h"

@interface SHUIImagePickerControllerLibrary : NSObject
+(void)goToSHUIImagePickerViewController:(void(^)(NSMutableArray<SHAssetModel *> * arr))result;
@end
