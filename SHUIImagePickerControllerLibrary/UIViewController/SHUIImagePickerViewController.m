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

@interface SHUIImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
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

#pragma mark  ----  代理

#pragma mark  ----  UICollectionViewDelegate

#pragma mark  ----  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SHCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SHCollectionViewCell" forIndexPath:indexPath];
    
    SHAssetModel * model = nil;
    if (indexPath.row < self.dataArray.count) {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    cell.imageView.image = model.thumbnails;
    [cell.selectBtn setSelected:model.selected];
    
    return cell;
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

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREENWIDTH - 10.0 * 5)/4.0;
    return CGSizeMake(width, width);
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
        UIImage * image = [UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/fanhui_w.tiff"];
        [_backBtn setImage:[UIImage imageNamed:@"SHUIImagePickerControllerLibrarySource.bundle/fanhui_w.tiff"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backBtn.frame), 20, SCREENWIDTH - CGRectGetMaxX(self.backBtn.frame) * 2, 44)];
        _titleLabel.textColor = Color_FFFFFF;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"照片";
    }
    return _titleLabel;
}

-(UIButton *)finishBtn{

    if (!_finishBtn) {
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setFrame:CGRectMake(SCREENWIDTH -44, 20, 44, 44)];
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

@end
