//
//  SHUIImagePickerController.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//  控制器

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CamareType) {
    CamareTypeSystem = 1 << 0,
    CamareTypeSmartLicense = 1 << 1,
    CamareTypeSmartIDCard = 2 << 2
};

//相机权限
typedef NS_ENUM(NSUInteger,CameraState){
    
    CameraStatusNotDetermined = 0,  //用户尚未做出有关此应用程序的选择
    CameraStatusRestricted,        //此应用程序未被授权访问照片数据,用户无法更改此应用程序的状态，可能是由于主动限制,正在实施家长控制等。
    CameraStatusDenied,            //用户已明确拒绝此应用程序访问照片数据。
    CameraStatusAuthorized         //用户已授权此应用程序访问照片数据。
};

//相册权限
typedef NS_ENUM(NSUInteger,AlbumState){
    
    AlbumStatusNotDetermined = 0,  //用户尚未做出有关此应用程序的选择
    AlbumStatusRestricted,        //此应用程序未被授权访问照片数据,用户无法更改此应用程序的状态，可能是由于主动限制,正在实施家长控制等。
    AlbumStatusDenied,            //用户已明确拒绝此应用程序访问照片数据。
    AlbumStatusAuthorized         //用户已授权此应用程序访问照片数据。
};

@class SHAssetModel;

@interface SHUIImagePickerController : NSObject

@property (nonatomic,assign) CamareType tkCamareType;
//剩余选择照片数
@property (nonatomic,assign) NSUInteger canSelectImageCount;

+(SHUIImagePickerController *)sharedManager;


//返回包含所有模型的数组
- (void)loadAllPhoto:(void(^)(NSMutableArray<SHAssetModel *> *arr))result;


//判断有无使用相册权限
-(AlbumState)getAlbumAuthority;
//判断有无照相机使用权限
-(CameraState)getCameraAuthority;
//清理内存(本模块生命周期结束时调用)
-(void)clearMemary;
@end
