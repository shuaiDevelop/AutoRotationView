//
//  ShRotationView.h
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShRotationFooter.h"
typedef enum {
    ShRotationViewPageControlAlimentCenter,
    ShRotationViewPageControlAlimentRight

}ShRotationViewPageControlAliment;


@class ShRotationView;
@protocol ShRotationViewDataSource <NSObject>
@required

/** 返回轮播图片的个数 */
- (NSInteger)numbersOfItemsInRotation:(ShRotationView *)rotation;

/** 返回轮播的视图  界面需要自定义*/
- (UIView *)rotation:(ShRotationView *)rotation viewForItemAtIndex:(NSInteger)index;

@optional

/** 进入详情 文字提示的代理方法  默认为 拖动查看详情 、 释放查看详情*/
- (NSString *)rotation:(ShRotationView *)rotation titleForFooterWithState:(ShRotationFooterState)footerState;

@end

@protocol ShRotationViewDelegate <NSObject>
@optional

/** 轮播器的点击事件 */
- (void)rotation:(ShRotationView *)rotation didSelectItemAtIndex:(NSInteger)index;

/** 滑动查看详情的事件   PS:push进入下一页*/
- (void)rotationFooterDidTrigger:(ShRotationView *)rotation;

@end
@interface ShRotationView : UIView


/** 是否需要循环滚动, 默认为NO */
@property (nonatomic, assign) BOOL shouldLoop;

/** 是否显示footer, 默认为NO (此属性为YES时, shouldLoop被置为NO) */
@property (nonatomic, assign) BOOL showFooter;

/** 是否自动滚动, 默认为NO */
@property (nonatomic, assign) BOOL autoScroll;

/** 自动滚动的时间间隔(s), 默认3s */
@property (nonatomic, assign) CGFloat scrollInterval;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否显示分页控件 */
@property (nonatomic, assign) ShRotationViewPageControlAliment pageControlAliment;

/** 外部可以设置 pagecontrol的frame  设置了之后 ShRotationViewPageControlAliment 将失效 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, weak) id<ShRotationViewDataSource> dataSource;
@property (nonatomic, weak) id<ShRotationViewDelegate> delegate;

- (void)reloadData;
- (void)startTimer;
- (void)stopTimer;
@end
