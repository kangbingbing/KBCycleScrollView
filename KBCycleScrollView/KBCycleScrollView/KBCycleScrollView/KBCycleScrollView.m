//
//  KBCycleScrollView.m
//  scroview
//
//  Created by kangbing on 17/6/20.
//  Copyright © 2017年 kangbing. All rights reserved.
//

#import "KBCycleScrollView.h"
#import "KBCollectionViewCell.h"

@interface KBCycleScrollView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

NSString *const ID = @"KBCollectionViewCell";

@implementation KBCycleScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.autoTimeInterval = 3.0;
        
        [self prepareCollectionView];
        
    }
    return self;
}

- (void)setImageUrlStringGroup:(NSArray *)imageUrlStringGroup{
    
    _imageUrlStringGroup = imageUrlStringGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    
    
    [imageUrlStringGroup enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger index, BOOL * stop) {
        NSString *urlString;
        
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.dataArray = [temp copy];
    
}

- (void)setAutoTimeInterval:(CGFloat)autoTimeInterval{
    
    _autoTimeInterval = autoTimeInterval;
    
    [self setAutoScroll:YES];


}

- (void)setDataArray:(NSArray *)dataArray{
    
    _dataArray = dataArray;
    
    
    if (dataArray.count > 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:YES];
    }else{
        self.collectionView.scrollEnabled = NO;
        [self setAutoScroll:NO];
    }
   

    // 有数据开始添加 pagecontrol
    [self praparePageControl];
    
    [self.collectionView reloadData];
    

}

- (void)praparePageControl{
    
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据
    
    if (self.dataArray.count == 0 || self.hiddenPageControl || self.dataArray.count == 1) return;
    
    NSInteger currentPage = [self currentIndex] % self.dataArray.count;
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    _pageControl = pageControl;
    pageControl.numberOfPages = self.dataArray.count;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = currentPage;
    pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    pageControl.pageIndicatorTintColor = self.otherPageColor;
    [self addSubview:pageControl];
    


}

- (void)setCurrentPageColor:(UIColor *)currentPageColor{

    _currentPageColor = currentPageColor;
    _pageControl.currentPageIndicatorTintColor = currentPageColor;
  
}

- (void)setOtherPageColor:(UIColor *)otherPageColor{

    _otherPageColor = otherPageColor;
    _pageControl.pageIndicatorTintColor = otherPageColor;
}

#pragma mark 滚动的方法
- (void)automaticScrollView{

    if (self.dataArray.count == 0) return;
    
    NSInteger currentIndex = [self currentIndex];
    
    NSInteger targetIndex = currentIndex + 1;
//    NSLog(@"%zd",targetIndex);
    
    
    
    if (targetIndex >= _dataArray.count * 100) {
        // 无限轮播, 如果大于最大值, 就让其索引减半, 无动画方式回滚
        targetIndex = _dataArray.count * 100 * 0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}



- (NSInteger)currentIndex{
    
    if (_collectionView.frame.size.width == 0 || _collectionView.frame.size.height == 0) {
        return 0;
    }
    
    NSInteger index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

- (void)setAutoScroll:(BOOL)autoScroll{
    
    [self invalidateTimer];
    
    if (autoScroll) {
        [self setupTimer];
    }
    
    
}

- (void)setupTimer{
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoTimeInterval target:self selector:@selector(automaticScrollView) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)invalidateTimer{
    
    [_timer invalidate];
    _timer = nil;
}

//父View释放时，被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}


- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _collectionView.frame = self.bounds;
    
    if (_collectionView.contentOffset.x == 0 &&  self.dataArray.count) {
        int targetIndex = _dataArray.count * 100 * 0.5;
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    
    // pageControl frame, 宽是高的1.5倍
    CGSize size = CGSizeMake(self.dataArray.count * 20 * 1.5, 20);
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    CGFloat y = self.bounds.size.height - size.height - 10;
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);


}
- (void)prepareCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[KBCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count * 100;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    KBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.placeHolderImage = self.placeHolderImage;
    cell.urlString = self.dataArray[indexPath.item % self.dataArray.count];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.dataArray.count];
    }


}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.dataArray.count) return;
    NSInteger currentIndex = [self currentIndex] % self.dataArray.count;
    _pageControl.currentPage = currentIndex;

}

#pragma mark 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self invalidateTimer];
}

#pragma mark 结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self setupTimer];
    
}



@end
