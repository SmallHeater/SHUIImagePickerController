//
//  SHUIImagePickerController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerController.h"
#import "SHAssetModel.h"




@interface SHUIImagePickerController ()
//当前相册中的所有图片
@property (nonatomic,strong) NSMutableArray<SHAssetModel *> * shAssetModelArray;

//相机模型
@property (nonatomic,strong) SHAssetModel * cameraModel;


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
    
    //添加去相机模型
    [self.shAssetModelArray addObject:self.cameraModel];
    
    __weak __typeof(self)weakSelf = self;
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //按照时间倒叙排列
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    
    if (allPhotosResult.count > 0) {
     
        [allPhotosResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {

            SHAssetModel * mAsset = [[SHAssetModel alloc] initWithAsset:asset];
            [weakSelf.shAssetModelArray addObject:mAsset];
            if (idx ==  allPhotosResult.count - 1) {
                
                result(weakSelf.shAssetModelArray);
                [weakSelf.shAssetModelArray removeAllObjects];
            }
        }];
    }
    else{
        
        result(weakSelf.shAssetModelArray);
        [weakSelf.shAssetModelArray removeAllObjects];
    }
}

//判断有无使用相册权限
-(AlbumState)getAlbumAuthority{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        //有访问相册权限
        return AlbumStatusAuthorized;
    }
    else if (status == PHAuthorizationStatusNotDetermined){
        
        [self requestAuthorizationStatus_AfteriOS8];
        return AlbumStatusNotDetermined;
    }
    else if (status == PHAuthorizationStatusRestricted){
        
        return AlbumStatusRestricted;
    }
    else{
        
        return AlbumStatusDenied;
    }
}

//判断有无照相机使用权限
-(CameraState)getCameraAuthority{

    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusAuthorized){
        
        return CameraStatusAuthorized;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            
        }];
        return CameraStatusNotDetermined;
    }
    else if (authStatus == AVAuthorizationStatusRestricted){
        
        return CameraStatusRestricted;
    }
    else{
    
        return CameraStatusDenied;
    }
}

//请求相册权限
- (void)requestAuthorizationStatus_AfteriOS8
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                {
                    
                    break;
                }
                default:
                {
                    break;
                }
            }
        });
    }];
}

//清理内存(本模块生命周期结束时调用)
-(void)clearMemary{

    [self.shAssetModelArray removeAllObjects];
}

#pragma mark  ----  懒加载
-(NSMutableArray<SHAssetModel *> *)shAssetModelArray{

    if (!_shAssetModelArray) {
        
        _shAssetModelArray = [[NSMutableArray alloc] init];
    }
    return _shAssetModelArray;
}

-(SHAssetModel *)cameraModel{

    if (!_cameraModel) {
        
        _cameraModel = [[SHAssetModel alloc] init];
        _cameraModel.thumbnails = [UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/camera.tiff"];
    }
    return _cameraModel;
}


@end
