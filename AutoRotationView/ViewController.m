//
//  ViewController.m
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import "ViewController.h"
#import "ShRotationView.h"
#import "NextViewController.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight  64.0
#define kRotationViewHeight 192.0
@interface ViewController () <ShRotationViewDelegate,ShRotationViewDataSource>

@property (nonatomic, strong) ShRotationView * rotationView;
@property (nonatomic, strong) NSArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupRotationView];
    
    
}

- (void)setupRotationView{

    self.rotationView = [[ShRotationView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kRotationViewHeight)];
    self.rotationView.delegate = self;
    self.rotationView.dataSource = self;
    // 允许轮播滑动
    self.rotationView.shouldLoop = YES;
    // 自动滑动
    self.rotationView.autoScroll = YES;
    // 时间
    self.rotationView.scrollInterval = 3;
//    self.rotationView.pageControl.frame = CGRectMake(kScreenWidth-60, kRotationViewHeight-40, 60, 20);
    self.rotationView.pageControlAliment = ShRotationViewPageControlAlimentCenter;
    
//    self.rotationView.showFooter = YES; // 设置这个为yes  shouldLoop 将被置为NO

    [self.view addSubview:self.rotationView];

}

- (NSInteger)numbersOfItemsInRotation:(ShRotationView *)rotation{

    return self.dataArray.count;
}
- (UIView *)rotation:(ShRotationView *)rotation viewForItemAtIndex:(NSInteger)index{

    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:self.dataArray[index]];    
//    UIView * view = [UIView new];
//    view.alpha = 0.4;
//    view.backgroundColor = [UIColor orangeColor];
//    view.frame = CGRectMake(0, kRotationViewHeight-20, kScreenWidth, 20);
//    [imageView addSubview:view];
//    
//    UILabel * label = [[UILabel alloc] init];
//    label.text = [NSString stringWithFormat:@"第%ld个图片",index];
//    label.frame = view.frame;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [imageView addSubview:label];
    return imageView;


}
- (void)rotation:(ShRotationView *)rotation didSelectItemAtIndex:(NSInteger)index{

    NSLog(@"点击了第%ld个图片",index);

}
- (void)rotationFooterDidTrigger:(ShRotationView *)rotation{
    NSLog(@"触发了footer 进入详情页");
    
    [self.navigationController pushViewController:[NextViewController new] animated:YES];

}
- (NSString *)rotation:(ShRotationView *)rotation titleForFooterWithState:(ShRotationFooterState)footerState{

    if (footerState == ShRotationFooterStateIdle) {
        return @"拖动进入下一页";
    }else if (footerState == ShRotationFooterStateTrigger){
    
        return @"释放进入下一页";
    }else{
        return nil;
    }


}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"image_01.jpg", @"image_02.jpg", @"image_03.png"];
    }
    return _dataArray;
}
- (void)dealloc{
    [self.rotationView stopTimer];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
