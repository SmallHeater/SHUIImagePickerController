//
//  SHUIImagePickerController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerController.h"
#import <Photos/Photos.h>
#import "SHAssetModel.h"


@interface SHUIImagePickerController ()
//当前相册中的所有图片
@property (nonatomic,strong) NSMutableArray<SHAssetModel *> * shAssetModelArray;
@end


@implementation SHUIImagePickerController

#pragma mark  ----  生命周期函数
+(SHUIImagePickerController *)sharedManager{

    static SHUIImagePickerController * controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[SHUIImagePickerController alloc] init];
    });
    return controller;
}


#pragma mark  ----  自定义函数

- (void)loadAllPhoto:(void(^)(NSMutableArray<SHAssetModel *> *arr))result
{
    [self.shAssetModelArray removeAllObjects];
    __weak __typeof(self)weakSelf = self;
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //按照时间倒叙排列
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    
    [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        
        SHAssetModel * mAsset = [[SHAssetModel alloc] initWithAsset:asset];
        [weakSelf.shAssetModelArray addObject:mAsset];
        if (allPhotosResult.count == weakSelf.shAssetModelArray.count) {
            
            result(weakSelf.shAssetModelArray);
            [weakSelf.shAssetModelArray removeAllObjects];
        }
    }];
    
}


#pragma mark  ----  懒加载
-(NSMutableArray<SHAssetModel *> *)shAssetModelArray{

    if (!_shAssetModelArray) {
        
        _shAssetModelArray = [[NSMutableArray alloc] init];
    }
    return _shAssetModelArray;
}

@end
