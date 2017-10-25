//
//  ViewController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "ViewController.h"
#import "SHUIImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface ViewController ()
@property (nonatomic,strong) UIButton * gotoImagePickerBnt;
@end

@implementation ViewController


#pragma mark  ----  生命周期函数


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.gotoImagePickerBnt];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  ----  自定义函数
-(void)gotoImagePickerBntClicked:(UIButton *)btn{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        SHUIImagePickerViewController * imagePicker = [[SHUIImagePickerViewController alloc] init];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
    
        NSLog(@"无权限");
        [self requestAuthorizationStatus_AfteriOS8];
    }
}

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

#pragma mark  ----  懒加载

-(UIButton *)gotoImagePickerBnt{

    if (!_gotoImagePickerBnt) {
        
        _gotoImagePickerBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _gotoImagePickerBnt.frame = CGRectMake(20, 200, 60, 40);
        [_gotoImagePickerBnt setTitle:@"去相册" forState:UIControlStateNormal];
        [_gotoImagePickerBnt setBackgroundColor:[UIColor grayColor]];
        [_gotoImagePickerBnt addTarget:self action:@selector(gotoImagePickerBntClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoImagePickerBnt;
}

@end
