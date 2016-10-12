//
//  ShRotationCell.m
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import "ShRotationCell.h"

@implementation ShRotationCell
@synthesize itemView = _itemView;
- (void)layoutSubviews{
    [super layoutSubviews];
    self.itemView.frame = self.bounds;

}


- (void)setItemView:(UIView *)itemView{

    if (_itemView) {
        [_itemView removeFromSuperview];
    }
    _itemView = itemView;
    [self addSubview:_itemView];
}

- (UIView *)itemView{

    if (!_itemView) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}
@end
