//
//  KBCollectionViewCell.m
//  scroview
//
//  Created by kangbing on 17/6/20.
//  Copyright © 2017年 kangbing. All rights reserved.
//

#import "KBCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface KBCollectionViewCell ()

@property (nonatomic, strong) UIImageView *cycleImageView;

@end

@implementation KBCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.cycleImageView];
        
        
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.cycleImageView.frame = self.bounds;


}

- (void)setUrlString:(NSString *)urlString{
    
    _urlString = urlString;

    [_cycleImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.placeHolderImage];
}


- (UIImageView *)cycleImageView{
    
    if (_cycleImageView == nil) {
        _cycleImageView =[[UIImageView alloc]init];
//        _cycleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleImageView;
    
}

@end
