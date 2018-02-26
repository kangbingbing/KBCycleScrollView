# KBCycleScrollView

图片轮播器

	use
	
	pod 'KBCycleScrollView'
	
	pod install


使用方法

	NSArray *array = @[@"https://f10.baidu.com/it/u=2465775762,1509670197&fm=72",@"https://f10.baidu.com/it/u=3087422712,1174175413&fm=72",@"https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=61a4c45364061d95624630384bf50a5d/c8ea15ce36d3d5397ea5b2a83087e950342ab0c5.jpg"];
	    KBCycleScrollView *cycleView = [[KBCycleScrollView alloc]init];
	    cycleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
	    [self.view addSubview:cycleView];
	    cycleView.placeHolderImage = nil;
	    cycleView.autoTimeInterval = 3;
	    cycleView.imageUrlStringGroup = array;
	    
	    
具体可参考demo