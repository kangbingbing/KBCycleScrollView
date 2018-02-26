//
//  KBCycleScrollView.h
//  scroview
//
//  Created by kangbing on 17/6/20.
//  Copyright © 2017年 kangbing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KBCycleScrollView;

@protocol KBCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(KBCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end


@interface KBCycleScrollView : UIView

@property (nonatomic, strong) NSArray *imageUrlStringGroup;
/** 自动滚动间隔时间,默认3s */
@property (nonatomic, assign) CGFloat autoTimeInterval;
/** 占位图 */
 @property (nonatomic, strong) UIImage *placeHolderImage;
/** 是否隐藏 pageControl 默认显示*/
@property (nonatomic, assign) BOOL hiddenPageControl;
/** 当前分页控件颜色 */
@property (nonatomic, strong) UIColor *currentPageColor;
/** 其他分页控件颜色 */
@property (nonatomic, strong) UIColor *otherPageColor;

@property (nonatomic, weak) id<KBCycleScrollViewDelegate> delegate;

@end
