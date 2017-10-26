//
//  SHAssetModel.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHAssetModel.h"



@implementation SHAssetModel

#pragma mark  ----  生命周期函数

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        _asset = asset;
    }
    
    return self;
}

- (UIImage *)originalImage {
    if (_originalImage) {
        return _originalImage;
    }
    __block UIImage *resultImage = nil;
    
    PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.synchronous = YES;
    //原图
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];

    _originalImage = resultImage;
    
    return _originalImage;
}

- (UIImage *)thumbnails {
    if (_thumbnails) {
        return _thumbnails;
    }
    __block UIImage *resultImage;
    
    PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
    //尽快地提供接近或稍微大于要求的尺寸
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    requestOptions.synchronous = YES;
    //以最快速度提供好的质量，这个属性只有在 synchronous 为 true 时有效
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    //缩略图
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(87, 87) contentMode:PHImageContentModeDefault options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        resultImage = result;
    }];
    _thumbnails = resultImage;
    
    return _thumbnails;
}

/*
- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    }
    __block UIImage *resultImage;
    
    [[FMAlbumHelper shareManager] fetchImageWithAsset:self targetSize:kPreviewTargetSize completion:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
        resultImage = image;
    }];
    _previewImage = resultImage;
    
    return _previewImage;
}
*/
- (NSString *)identifier {
    return self.asset.localIdentifier;
}
@end
