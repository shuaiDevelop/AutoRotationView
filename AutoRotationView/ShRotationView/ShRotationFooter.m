//
//  ShRotationFooter.m
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import "ShRotationFooter.h"

#define Sh_ARROW_SIDE 15.0f

@implementation ShRotationFooter

@synthesize idleTitle = _idleTitle;
@synthesize triggerTitle = _triggerTitle;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrowView];
        [self addSubview:self.label];
        self.arrowView.image = [UIImage imageNamed:@"ShRotationView.bundle/rotation_arrow.png"];
        self.state = ShRotationFooterStateIdle;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat arrowX = self.bounds.size.width / 2 - Sh_ARROW_SIDE - 2;
    CGFloat arrowY = self.bounds.size.height / 2 - Sh_ARROW_SIDE / 2;
    CGFloat arrowW = Sh_ARROW_SIDE;
    CGFloat arrowH = Sh_ARROW_SIDE;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat labelX = self.bounds.size.width / 2 + 2;
    CGFloat labelY = 0;
    CGFloat labelW = Sh_ARROW_SIDE;
    CGFloat labelH = self.bounds.size.height;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);

}


- (void)setState:(ShRotationFooterState)state{

    _state = state;
    
    switch (state) {
        case ShRotationFooterStateIdle:{
            self.label.text = self.idleTitle;
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0);
            }];
        }
            break;
        case ShRotationFooterStateTrigger:{
        
            self.label.text = self.triggerTitle;
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        
        }
            break;
        default:
            break;
    }


}

- (UIImageView *)arrowView{

    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
    }
    return _arrowView;
}
- (UILabel *)label{

    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:13.0f];
        _label.textColor = [UIColor darkGrayColor];
        _label.numberOfLines = 0;
    }
    return  _label;
}

- (void)setIdleTitle:(NSString *)idleTitle{

    _idleTitle = idleTitle;
    if (self.state == ShRotationFooterStateIdle) {
        self.label.text = idleTitle;
    }

}
- (NSString *)idleTitle{

    if (!_idleTitle) {
        _idleTitle = @"拖动查看详情";
    }
    return  _idleTitle;
}

- (void)setTriggerTitle:(NSString *)triggerTitle{

    _triggerTitle = triggerTitle;
    
    if (self.state == ShRotationFooterStateTrigger) {
        self.label.text = triggerTitle;
    }

}

- (NSString *)triggerTitle{

    if (!_triggerTitle) {
        _triggerTitle = @"释放查看详情";
    }
    return _triggerTitle;
}


@end
