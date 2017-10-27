//
//  BigPictureBrowsing.m
//  JHLivePlayDemo
//
//  Created by xianjunwang on 2017/9/6.
//  Copyright © 2017年 pk. All rights reserved.
//

#import "BigPictureBrowsing.h"
#import "UIImageView+WebCache.h"



@interface BigPictureBrowsing ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView * scrollView;
//图片地址数组
@property (nonatomic,strong) NSArray * imageURLArray;
//图片数组
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) UIPageControl * pageControl;
//显示图片索引
@property (nonatomic,assign) NSUInteger selectedIndex;
@end


@implementation BigPictureBrowsing

-(instancetype)initWithImageURLArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x000000);
        self.selectedIndex = index;
        self.imageURLArray = [[NSArray alloc] initWithArray:array];
        self.scrollView.contentSize = CGSizeMake(ScreenWidth * self.imageURLArray.count, ScreenHeight);
        for (NSUInteger i = 0; i < self.imageURLArray.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
            [imageView addGestureRecognizer:tap];
            
            NSURL * url = [NSURL URLWithString:self.imageURLArray[i]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
            UIImage * image;
            if (existBool) {
                image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            }
            else{
                NSData *data = [NSData dataWithContentsOfURL:url];
                image = [UIImage imageWithData:data];
            }
            
            //根据image的比例来设置高度
            float radio = 1.00;
            if (image && image.size.width) {
                radio = image.size.height / image.size.width;
            }
            else
            {
                radio = 92.00/152.00;
            }
            
            
            if (image) {
                imageView.image = image;
            }
            else{
                //默认图
                imageView.image = [UIImage imageNamed:@"JHLivePlayBundle.bundle/haveNoEvidence.tiff"];
            }
            
            float imageViewWidth = ScreenWidth;
            float imageViewHeight = ScreenWidth * radio;
            imageView.frame = CGRectMake(i * imageViewWidth, (ScreenHeight - imageViewHeight) / 2, imageViewWidth, imageViewHeight);
            [self.scrollView addSubview:imageView];
            
            self.scrollView.contentOffset = CGPointMake(imageViewWidth * index, 0);
            
        }
    }
    return self;
}

-(instancetype)initWithImageArray:(NSArray *)array andSelectedIndex:(NSInteger)index{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        self.backgroundColor = HEX_COLOR(0x000000);
        self.selectedIndex = index;
        self.imageArray = [[NSArray alloc] initWithArray:array];
        self.scrollView.contentSize = CGSizeMake(ScreenWidth * self.imageArray.count, ScreenHeight);
        for (NSUInteger i = 0; i < self.imageArray.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
            [imageView addGestureRecognizer:tap];
            
           
            UIImage * image = self.imageArray[i];
            
            //根据image的比例来设置高度
            float radio = 1.00;
            if (image && image.size.width) {
                radio = image.size.height / image.size.width;
            }
            else
            {
                radio = 92.00/152.00;
            }
            
            
            if (image) {
                imageView.image = image;
            }
            else{
                //默认图
                imageView.image = [UIImage imageNamed:@"JHLivePlayBundle.bundle/haveNoEvidence.tiff"];
            }
            
            float imageViewWidth = ScreenWidth;
            float imageViewHeight = ScreenWidth * radio;
            imageView.frame = CGRectMake(i * imageViewWidth, (ScreenHeight - imageViewHeight) / 2, imageViewWidth, imageViewHeight);
            [self.scrollView addSubview:imageView];
            
            self.scrollView.contentOffset = CGPointMake(imageViewWidth * index, 0);
            
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.contentOffset = CGPointMake(ScreenWidth * self.selectedIndex, 0);
    self.pageControl.currentPage = self.selectedIndex;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

#pragma mark  ----  自定义函数
-(void)imageTaped{
    [self removeFromSuperview];
}


#pragma mark  ----  代理
#pragma mark  ----  UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

#pragma mark  ----  懒加载

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = HEX_COLOR(0x000000);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenHeight - 16 - 20, ScreenWidth, 20)];
        if (self.imageURLArray.count > 0) {
            
            _pageControl.numberOfPages = self.imageURLArray.count;
        }
        else if (self.imageArray.count > 0){
        
            _pageControl.numberOfPages = self.imageArray.count;
        }
        
    }
    return _pageControl;
}

@end
