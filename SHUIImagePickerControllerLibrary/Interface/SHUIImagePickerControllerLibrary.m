//
//  SHUIImagePickerControllerLibrary.m
//  SHUIImagePickerControllerLibrary
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerControllerLibrary.h"
#import "SHUIImagePickerViewController.h"
#import "SHUIImagePickerController.h"



@implementation SHUIImagePickerControllerLibrary

+(void)goToSHUIImagePickerViewControllerWithMaxImageSelectCount:(NSUInteger)maxCount anResultBlock:(void (^)(NSMutableArray<SHAssetModel *> *))result{
    
    if (maxCount == 0) {
        
        return;
    }
    
    [SHUIImagePickerController sharedManager].canSelectImageCount = maxCount;
    //权限判断
    if ([[SHUIImagePickerController sharedManager] getAlbumAuthority] == AlbumStatusAuthorized) {
        
        //有权限
        SHUIImagePickerViewController * imagePickerViewController = [[SHUIImagePickerViewController alloc] init];
        imagePickerViewController.block = result;
        [[self currentViewController] presentViewController:imagePickerViewController animated:YES completion:nil];
    }
    else if([[SHUIImagePickerController sharedManager] getAlbumAuthority] == AlbumStatusDenied || [[SHUIImagePickerController sharedManager] getAlbumAuthority] == AlbumStatusRestricted){
        
        NSDictionary * inforDic = [NSBundle mainBundle].infoDictionary;
        NSString * message = [[NSString alloc] initWithFormat:@"请进入iPhone的“设置-隐私-照片”选项，允许%@访问您的手机相册。",inforDic[@"CFBundleDisplayName"]];
        //无权限
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        
        [topController presentViewController:alert animated:YES completion:nil];
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





@end
