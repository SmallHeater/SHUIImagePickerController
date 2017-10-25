//
//  SHUIImagePickerControllerLibrary.m
//  SHUIImagePickerControllerLibrary
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerControllerLibrary.h"
#import "SHUIImagePickerViewController.h"
#import <Photos/Photos.h>

@implementation SHUIImagePickerControllerLibrary

+(void)goToSHUIImagePickerViewController:(void (^)(NSMutableArray<SHAssetModel *> *))result{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        //有访问相册权限
        SHUIImagePickerViewController * imagePickerViewController = [[SHUIImagePickerViewController alloc] init];
        imagePickerViewController.block = result;
        [[self currentViewController] presentViewController:imagePickerViewController animated:YES completion:nil];
    }
    else{
        
        [self requestAuthorizationStatus_AfteriOS8];
    }
    
    
}

+ (UIViewController *)currentViewController
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


+ (void)requestAuthorizationStatus_AfteriOS8
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


@end
