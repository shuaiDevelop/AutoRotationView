//
//  ShRotationFooter.h
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShRotationFooterState) {
    /** 正常状态下的footer提示 */
    ShRotationFooterStateIdle = 0,
    
    /** 被拖至触发点的footer提示 */
    ShRotationFooterStateTrigger,
};
@interface ShRotationFooter : UICollectionReusableView

@property (nonatomic, assign) ShRotationFooterState state;

@property (nonatomic, strong) UIImageView * arrowView;
@property (nonatomic, strong) UILabel * label;

@property (nonatomic, copy) NSString * idleTitle;
@property (nonatomic, copy) NSString * triggerTitle;

@end
