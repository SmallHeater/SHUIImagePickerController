//
//  SHAssetModel.h
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;

@interface SHAssetModel : NSObject

/**
 *  PHAsset
 */
@property (nonatomic, strong,nonnull) PHAsset *asset;

/**
 *  原图 (默认尺寸kOriginTargetSize)
 */
@property (nonatomic, strong,nonnull) UIImage * originalImage;

/**
 *  预览图（默认尺寸kPreviewTargetSize）
 */
@property (nonatomic, strong, readonly, nonnull) UIImage * previewImage;

/**
 *  缩略图（默认尺寸kThumbnailTargetSize)
 */
@property (nonatomic, strong,nonnull) UIImage * thumbnails;
/**
 *  是否选中
 */
@property (nonatomic) BOOL selected;
/**
 *  唯一标识符
 */
@property (nonatomic, strong, readonly, nonnull) NSString *identifier;

/**
 *  初始化相片model
 *
 *  @param asset PHAsset/ALAsset
 *
 *  @return SYAsset
 */
- (instancetype _Nonnull)initWithAsset:(PHAsset * _Nonnull)asset;


@end
