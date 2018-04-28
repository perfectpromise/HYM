
#import "MSTabBarController.h"
#import "MSNavigationController.h"

@interface MSTabBarController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MSTabBarController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [self.selectedViewController viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //TarBar初始化,数据初始化
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"首页",@"记账",@"借款",nil];

    NSMutableArray *controllerArr = [NSMutableArray arrayWithObjects:@"HomeViewController",@"AccountViewController",@"LoanViewController",@"RegisterViewController",nil];
    NSMutableArray *imgNormalArr = [NSMutableArray arrayWithObjects:@"tabBar_home",@"tabBar_find",@"tabBar_loan",@"tabBar_home",nil];
    NSMutableArray *imgSelectedArr = [NSMutableArray arrayWithObjects:@"tabBar_home_s",@"tabBar_find_s",@"tabBar_loan_s",@"tabBar_home_s",nil];

    //控制器初始化
    NSMutableArray *tabbarArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        
        UIViewController *viewCtrl = [NSClassFromString(controllerArr[i]) new];
        
        MSNavigationController *navCtrl = [[MSNavigationController alloc] initWithRootViewController:viewCtrl];
        navCtrl.tabBarItem.title = titleArr[i];
        navCtrl.delegate = self;
        navCtrl.tabBarItem.image = [UIImage imageNamed:imgNormalArr[i]];
        navCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:imgSelectedArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [tabbarArr addObject:navCtrl];
    }
    
    // 分栏条的背景颜色
    [self.tabBar setValue:[UIColor whiteColor] forKey:@"barTintColor"];
    self.tabBar.tintColor = RGBA(0x55D1DA, 1.0);
    self.viewControllers = tabbarArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIDeviceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}

#pragma mark -UINavigationControllerDelegate
/*解决根视图滑动导致卡顿问题*/
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count <= 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
@end
