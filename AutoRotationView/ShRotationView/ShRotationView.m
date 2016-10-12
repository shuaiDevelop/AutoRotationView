//
//  ShRotationView.m
//  AutoRotationView
//
//  Created by 王帅 on 16/10/10.
//  Copyright © 2016年 YLZF Inc. All rights reserved.
//

#import "ShRotationView.h"
#import "ShRotationCell.h"

//总共的items个数
#define Sh_TOTAL_ITEMS (self.itemCount * 20000)

#define Sh_FOOTER_WIDTH 64.0
#define Sh_PAGE_CONTROL_HEIGHT 20.0
#define Sh_PAGE_CONTROL_SPACE  15.0  // 大致估计 pagecontrol小圆点直接的距离  用来计算整个pagecontrol的宽度

static NSString * rotation_item = @"rotation_item";
static NSString * rotation_footer = @"rotation_footer";

@interface ShRotationView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) ShRotationFooter * footer;
@property (nonatomic, strong, readwrite) UIPageControl * pageControl;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, weak) NSTimer * timer;

@end
@implementation ShRotationView
@synthesize scrollInterval = _scrollInterval;
@synthesize autoScroll = _autoScroll;
@synthesize shouldLoop =_shouldLoop;
@synthesize pageControl = _pageControl;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{

    _showPageControl = YES;
    _pageControlAliment = ShRotationViewPageControlAlimentCenter;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];

}
- (void)layoutSubviews{

    [super layoutSubviews];
    [self updateSubviewsFrame];

}
- (void)updateSubviewsFrame{

    //collectionView
    self.flowLayout.itemSize = self.bounds.size;
    self.flowLayout.footerReferenceSize = CGSizeMake(Sh_FOOTER_WIDTH, self.frame.size.height);
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
    
  
    if (CGRectEqualToRect(self.pageControl.frame, CGRectZero)) {
        //pageControl 默认的frame
        CGFloat w = (self.pageControl.numberOfPages+1) * Sh_PAGE_CONTROL_SPACE;
        CGFloat h = Sh_PAGE_CONTROL_HEIGHT;
        
        CGFloat x = self.frame.size.width/2 - w/2;
        if (self.pageControlAliment == ShRotationViewPageControlAlimentRight) {
            x = self.frame.size.width - w;
        }
        CGFloat y = self.frame.size.height - h;
        self.pageControl.frame = CGRectMake(x, y, w, h);
        self.pageControl.hidden = !_showPageControl;
    }

}

- (void)fixDefaultPosition{

    if (self.itemCount == 0) return;

    if (self.shouldLoop) {
        
        // 总 items数的中间
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(Sh_TOTAL_ITEMS / 2) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
            
        });
    }else {
        // 第0个item
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
            
        });
    
    }

}

#pragma mark - Reload

- (void)reloadData{

    if (!self.dataSource || self.itemCount == 0) return;

    // 设置pageControl总页数
    self.pageControl.numberOfPages = self.itemCount;
    
    // 刷新数据
    [self.collectionView reloadData];
    
    // 开启定时器
    

}

#pragma mark - NSTimer

- (void)startTimer{

    if (!self.autoScroll) return;
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;

}

// 定时器方法
- (void)autoScrollToNextItem{
    if (self.itemCount == 0 || self.itemCount == 1 || !self.autoScroll) return;
    
    NSIndexPath * currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    NSUInteger nextItem = currentItem + 1;
    
    if (nextItem >= Sh_TOTAL_ITEMS) return;

    if (self.shouldLoop) {
        // 无限滑动 翻页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
    }else{
    
        if (currentItem % self.itemCount == self.itemCount - 1) {
            // 最后一张
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }else{
            // 往下翻页
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
        }
        
    }

}

#pragma mark - UICollectionViewDataSource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.shouldLoop) {
        return Sh_TOTAL_ITEMS;
    }else{
        return self.itemCount;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ShRotationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:rotation_item forIndexPath:indexPath];
    if ([self.dataSource respondsToSelector:@selector(rotation:viewForItemAtIndex:)]) {
        cell.itemView = [self.dataSource rotation:self viewForItemAtIndex:indexPath.item % self.itemCount];
        
    }
    return  cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView * footer = nil;

    if (kind == UICollectionElementKindSectionFooter) {
        footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:rotation_footer forIndexPath:indexPath];
        self.footer = (ShRotationFooter *)footer;
        
        if ([self.dataSource respondsToSelector:@selector(rotation:titleForFooterWithState:)]) {
            self.footer.idleTitle = [self.dataSource rotation:self titleForFooterWithState:ShRotationFooterStateIdle];
            self.footer.triggerTitle = [self.dataSource rotation:self titleForFooterWithState:ShRotationFooterStateTrigger];
        }
        
    }
    if (self.showFooter) {
        self.footer.hidden = NO;
    }else{
        self.footer.hidden = YES;
    }

    return footer;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(rotation:didSelectItemAtIndex:)]) {
        [self.delegate rotation:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }


}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

    NSIndexPath * currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageControl.currentPage = currentIndexPath.item % self.itemCount;

}
#pragma mark - UISrollVIewDelegate
#pragma mark - timer相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 用户滑动的时候停止定时器
    [self stopTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 用户停止滑动的时候开启定时器
    [self startTimer];
}

#pragma mark -- footer 相关

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (!self.showFooter) return;
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));
    
    if (footerDisplayOffset > 0) {
        
        if (footerDisplayOffset > Sh_FOOTER_WIDTH) {
            if (lastOffset > 0) return;
            self.footer.state = ShRotationFooterStateTrigger;
        }else{
        
            if (lastOffset < 0) return;
            self.footer.state = ShRotationFooterStateIdle;
        }
        lastOffset = footerDisplayOffset - Sh_FOOTER_WIDTH;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (!self.showFooter) return;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));

    if (footerDisplayOffset > Sh_FOOTER_WIDTH) {
        if ([self.delegate respondsToSelector:@selector(rotationFooterDidTrigger:)]) {
            [self.delegate rotationFooterDidTrigger:self];
        }
    }
}

#pragma mark - set & get 
#pragma mark - 属性

- (void)setFrame:(CGRect)frame{

    self.pageControl.frame = CGRectZero;
    [super setFrame:frame];

}

- (void)setDataSource:(id<ShRotationViewDataSource>)dataSource{

    _dataSource = dataSource;
    //刷新数据
    [self reloadData];
    
    // 配置默认起始位置
    [self fixDefaultPosition];

}
- (NSInteger)itemCount{

    if ([self.dataSource respondsToSelector:@selector(numbersOfItemsInRotation:)]) {
        return [self.dataSource numbersOfItemsInRotation:self];
    }
    return 0;
}

- (void)setShouldLoop:(BOOL)shouldLoop{

    _shouldLoop = shouldLoop;
    [self reloadData];
    
    [self fixDefaultPosition];

}

- (BOOL)shouldLoop{
    if (self.showFooter) {
        //如果footer存在 就不应该有循环滑动
        return NO;
    }
    if (self.itemCount == 1) {
        return NO;
    }
    return _shouldLoop;
}
- (void)setShowFooter:(BOOL)showFooter{

    _showFooter = showFooter;
    [self reloadData];

}

- (void)setAutoScroll:(BOOL)autoScroll{

    _autoScroll = autoScroll;

    if (autoScroll) {
        [self startTimer];
    }else{
        [self stopTimer];
    }

}
- (BOOL)autoScroll{

    if (self.itemCount < 2) {
        return NO;
    }
    return _autoScroll;

}

- (void)setScrollInterval:(CGFloat)scrollInterval{
    if (scrollInterval <= 0) {
        [self stopTimer];
        return;
    }
    _scrollInterval = scrollInterval;
    [self startTimer];

}
- (CGFloat)scrollInterval{

    if (!_scrollInterval) {
        _scrollInterval = 3.0;
    }
    return _scrollInterval;

}
- (void)setShowPageControl:(BOOL)showPageControl{

    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;

}
#pragma mark - 懒加载 控件

- (UICollectionView *)collectionView{

    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES; // 小于或等于一页时 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ShRotationCell class] forCellWithReuseIdentifier:rotation_item];
        [_collectionView registerClass:[ShRotationFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:rotation_footer];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, -Sh_FOOTER_WIDTH);

    }

    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{

    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }


    return _flowLayout;
}

- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }

    return _pageControl;
}


- (void)dealloc{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    NSLog(@"ShRotationView  dealloc");
    
}

@end
