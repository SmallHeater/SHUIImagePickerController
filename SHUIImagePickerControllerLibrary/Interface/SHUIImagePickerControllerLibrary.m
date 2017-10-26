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

+(void)goToSHUIImagePickerViewControllerWithMaxImageSelectCount:(NSUInteger)maxCount anResultBlock:(void (^)(NSMutableArray<UIImage *> *))result{
    
    if (maxCount == 0) {
        
        return;
    }
    [SHUIImagePickerController sharedManager].canSelectImageCount = maxCount;
    if ([[SHUIImagePickerController sharedManager] getAlbumAuthority]) {
        
        //有权限
        SHUIImagePickerViewController * imagePickerViewController = [[SHUIImagePickerViewController alloc] init];
        imagePickerViewController.block = result;
        [[self currentViewController] presentViewController:imagePickerViewController animated:YES completion:nil];
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
