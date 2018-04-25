
#import "MSNavigationController.h"
#import "UIView+ExtendRegion.h"
#import "BMNavigationBarHeader.h"
#import "UIImage+Color.h"

@interface MSNavigationController ()

@end

@implementation MSNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBA(0x6DD4E0, 1.0)]
                                 forBarMetrics:UIBarMetricsDefault];
        
        UIColor * color = [UIColor whiteColor];
        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        self.navigationBar.titleTextAttributes = dict;
        self.navigationBar.translucent = NO;
        self.interactivePopGestureRecognizer.enabled = NO;//根视图禁止滑动，否则容易造成卡死
        /*POP到根视图，仍然需要禁止，在delegate中实现*/
    }
    
    return self;
}

//返回上层界面
-(void)popself
{
    [self popViewControllerAnimated:YES];
}

//自定义返回按钮
-(UIBarButtonItem*) createBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return leftitem;
}

//push进入下一层界面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else{
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {

        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[self createBackButton], nil];

//        UIView *navigationBarView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, ScreenWidth - NavigationBarTitleViewMargin * 2, 44)];
//        navigationBarView.backgroundColor = [UIColor clearColor];
//        navigationBarView.extendRegionType = ClickExtendRegion;
//        viewController.navigationItem.titleView = navigationBarView;
//
//        [navigationBarView addSubview: [self createBackButton]];
    }
    
    if (![viewController isKindOfClass:[UITabBarController class]]) {
        //开启iOS7的滑动返回效果
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

@end


@implementation UINavigationController (Rotation)


- (BOOL)shouldAutorotate
{
    UIViewController *vCtrl = [self.viewControllers lastObject];
    if ([vCtrl isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarCtrl = (UITabBarController *)vCtrl;
        
        return [[tabbarCtrl.viewControllers lastObject] shouldAutorotate];
    }
    
    return [[self.viewControllers lastObject] shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *vCtrl = [self.viewControllers lastObject];
    if ([vCtrl isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarCtrl = (UITabBarController *)vCtrl;
        
        return [[tabbarCtrl.viewControllers lastObject] shouldAutorotate];
    }
    
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIViewController *vCtrl = [self.viewControllers lastObject];
    if ([vCtrl isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarCtrl = (UITabBarController *)vCtrl;
        
        return [[tabbarCtrl.viewControllers lastObject] shouldAutorotate];
    }
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end
