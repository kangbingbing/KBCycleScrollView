//
//  ViewController.m
//  KBCycleScrollView
//
//  Created by kangbing on 17/6/20.
//  Copyright © 2017年 kangbing. All rights reserved.
//

#import "ViewController.h"
#import "KBCycleScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *array = @[@"https://f10.baidu.com/it/u=2465775762,1509670197&fm=72",@"https://f10.baidu.com/it/u=3087422712,1174175413&fm=72",@"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=61a4c45364061d95624630384bf50a5d/c8ea15ce36d3d5397ea5b2a83087e950342ab0c5.jpg"];
    KBCycleScrollView *cycleView = [[KBCycleScrollView alloc]init];
    cycleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:cycleView];
    cycleView.placeHolderImage = nil;
    cycleView.autoTimeInterval = 3;
    cycleView.currentPageColor = [UIColor purpleColor];
    cycleView.otherPageColor = [UIColor brownColor];
    cycleView.imageUrlStringGroup = array;
    
    
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
