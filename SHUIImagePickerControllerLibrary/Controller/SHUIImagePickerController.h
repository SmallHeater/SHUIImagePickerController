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
//剩余选择照片数
@property (nonatomic,assign) NSUInteger canSelectImageCount;

+(SHUIImagePickerController *)sharedManager;


//返回包含所有模型的数组
- (void)loadAllPhoto:(void(^)(NSMutableArray<SHAssetModel *> *arr))result;


//判断有无使用相册权限
-(BOOL)getAlbumAuthority;
//判断有无照相机使用权限
-(BOOL)getCameraAuthority;
//清理内存(本模块生命周期结束时调用)
-(void)clearMemary;
@end
