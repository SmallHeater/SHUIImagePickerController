//
//  SHUIImagePickerViewController.m
//  SHUIImagePickerController
//
//  Created by xianjunwang on 2017/10/24.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "SHUIImagePickerViewController.h"
#import "SHCollectionViewCell.h"
#import "SHUIImagePickerController.h"
#import "SHCollectionViewCell.h"
#import "SHAssetModel.h"
#import "MBProgressHUD.h"


#define CELLSELECTBTNBASETAG  1010


@interface SHUIImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//自定义导航条
@property (nonatomic,strong) UIView * shNavigationBar;
//返回按钮
@property (nonatomic,strong) UIButton * backBtn;
//标题label
@property (nonatomic,strong) UILabel * titleLabel;
//完成按钮
@property (nonatomic,strong) UIButton * finishBtn;
@property (nonatomic,retain) UICollectionView *collectionView;
//存储模型的数组
@property (nonatomic,strong) NSMutableArray<SHAssetModel *> * dataArray;
//存储选中的模型的数组
@property (nonatomic,strong) NSMutableArray<SHAssetModel *> * selectedModelArray;
@end

@implementation SHUIImagePickerViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.shNavigationBar];
    [self.view addSubview:self.collectionView];
    
    [[SHUIImagePickerController sharedManager] loadAllPhoto:^(NSMutableArray<SHAssetModel *> *arr) {
        
        [self.dataArray addObjectsFromArray:arr];
        [self.collectionView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //使用自定义导航条
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    NSLog(@"SHUIImagePickerViewController被销毁");
}

#pragma mark  ----  代理

#pragma mark  ----  UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        //权限判断
        if ([[SHUIImagePickerController sharedManager] getCameraAuthority] == CameraStatusAuthorized) {
            
                //去拍照
                UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
                if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                }
                UIImagePickerController *picker=[[UIImagePickerController alloc]init];
                picker.delegate=self;
                picker.sourceType=sourceType;
                picker.allowsEditing= NO;
                [self  presentViewController:picker animated:YES completion:nil];
            
        }
        else if([[SHUIImagePickerController sharedManager] getCameraAuthority] == CameraStatusRestricted || [[SHUIImagePickerController sharedManager] getCameraAuthority] == CameraStatusDenied){
            
            NSDictionary * inforDic = [NSBundle mainBundle].infoDictionary;
            NSString * message = [[NSString alloc] initWithFormat:@"请进入iPhone的“设置-隐私-相机”选项，允许%@访问您的手机相册。",inforDic[@"CFBundleDisplayName"]];
            //无权限
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
#pragma mark  ----  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SHCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SHCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        SHAssetModel * model = [self.dataArray objectAtIndex:indexPath.row];
        cell.imageView.image = model.thumbnails;
        cell.selectBtn.hidden = YES;
    }
    else{
    
        SHAssetModel * model = [self.dataArray objectAtIndex:indexPath.row];
        cell.imageView.image = model.thumbnails;
        cell.selectBtn.hidden = NO;
        [cell.selectBtn setSelected:model.selected];
        cell.selectBtn.tag = CELLSELECTBTNBASETAG + indexPath.row;
        [cell.selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark  ----  UICollectionViewDelegateFlowLayout

//返回每个item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (SCREENWIDTH - 10.0 * 4)/4.0;
    return CGSizeMake(width, width);
}

//返回上左下右四边的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

//返回cell之间的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

//cell之间的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

#pragma mark  ----  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image) {
        
        NSMutableArray * selectedImageArray = [[NSMutableArray alloc] init];
        
        __weak typeof(self) wkself = self;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
             [PHAssetCreationRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
            
                [[SHUIImagePickerController sharedManager] loadAllPhoto:^(NSMutableArray<SHAssetModel *> *arr) {
    
                    //第一个是默认的照相机项
                    SHAssetModel * model = arr[1];
                    [selectedImageArray addObject:model];
                    [wkself backBtnClicked:nil];
                    if (wkself.block) {
                        
                        wkself.block(selectedImageArray);
                    }
                    else if (wkself.delegate){
                        
                        [self.delegate finishSelectedWithArray:selectedImageArray];
                    }
                }];
            }
            else{
            
                NSLog(@"image转PHAsset失败，%@",error);
            }
        }];
    }
}


#pragma mark  ----  自定义函数

//返回按钮的响应
-(void)backBtnClicked:(UIButton *)backBtn{

    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

//完成按钮的响应
-(void)finishBtnClicked:(UIButton *)finishBtn{

    NSMutableArray * selectedImageArray = [[NSMutableArray alloc] initWithArray:self.selectedModelArray];
    [self.selectedModelArray removeAllObjects];
    [self backBtnClicked:nil];
    if (self.block) {
        
        self.block(selectedImageArray);
    }else if (self.delegate){
        
        [self.delegate finishSelectedWithArray:selectedImageArray];
    }
}

//cell的选择按钮被点击
-(void)selectBtnClicked:(UIButton *)btn{
    
    if (!btn.selected) {
        
        if ([SHUIImagePickerController sharedManager].canSelectImageCount > 0) {
         
            btn.selected = !btn.selected;
            SHAssetModel * model = self.dataArray[btn.tag - CELLSELECTBTNBASETAG];
            model.selected = btn.selected;
            [SHUIImagePickerController sharedManager].canSelectImageCount--;
            [self.selectedModelArray addObject:model];
        }
        else{
        
            [MBProgressHUD displayHudError:@"已达到最大照片选择数"];
        }
    }
    else{
    
        btn.selected = !btn.selected;
        SHAssetModel * model = self.dataArray[btn.tag - CELLSELECTBTNBASETAG];
        model.selected = btn.selected;
        [SHUIImagePickerController sharedManager].canSelectImageCount++;
        [self.selectedModelArray removeObject:model];
    }
    
   
}


#pragma mark  ----  懒加载

-(UIView *)shNavigationBar{

    if (!_shNavigationBar) {
        
        _shNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        _shNavigationBar.backgroundColor = Color_87BA4B;
        [_shNavigationBar addSubview:self.backBtn];
        [_shNavigationBar addSubview:self.titleLabel];
        [_shNavigationBar addSubview:self.finishBtn];
    }
    return _shNavigationBar;
}

-(UIButton *)backBtn{
    
    if (!_backBtn) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(0, 20, 44, 44)];
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
        [_backBtn setImage:[UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/fanhui_w.tiff"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backBtn.frame), 20, SCREENWIDTH - CGRectGetMaxX(self.backBtn.frame) * 2, 44)];
        _titleLabel.textColor = Color_FFFFFF;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"照片";
    }
    return _titleLabel;
}

-(UIButton *)finishBtn{

    if (!_finishBtn) {
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setFrame:CGRectMake(SCREENWIDTH -44, 20, 44, 44)];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(finishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

-(UICollectionView *)collectionView{

    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 4.0;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView registerClass:[SHCollectionViewCell class] forCellWithReuseIdentifier:@"SHCollectionViewCell"];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray<SHAssetModel *> *)selectedModelArray{

    if (!_selectedModelArray) {
        
        _selectedModelArray = [[NSMutableArray alloc] init];
    }
    return _selectedModelArray;
}

@end
