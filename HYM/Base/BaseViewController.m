
#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //[SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = RGBA(0xF5F5F5, 1.0);
    self.view.userInteractionEnabled = YES;
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)setupRightMenuButton:(NSString *)imgName
                       title:(NSString *)titleStr{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setFrame:CGRectMake(5.0f, 5.0f, 80.0f, 46.0f)];
    [button addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *barSpace = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                 target:nil action:nil];
    barSpace.width = -10;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0){
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barSpace, barButton, nil];
}

- (void)rightButtonPressed:(UIButton *)button{
    //子类重写该方法
}

- (void)reloadButtonPressed{
    //子类重写该方法,重新加载数据按钮
}

#pragma mark -弹框
- (void)alertWithTitle:(NSString *)title
               message:(NSString *)msg
          cancelButton:(NSString *)cancelButton
              okButton:(NSString *)okButton
  clickedButtonAtIndex:(void(^)(NSInteger index))block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelButton) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButton
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (block) {
                                                                     block(0);
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
    }
    
    if (okButton) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButton
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (block) {
                                                                 block(1);
                                                             }
                                                         }];
        [alertController addAction:okAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -竖屏
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

#pragma mark -触摸关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (![self isMemberOfClass:[UIScrollView class]]) {
        [self.view resignFirstResponder];
        [self.view endEditing:YES];
    } else {
        [[self nextResponder] touchesBegan:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)])
        {
            [super touchesBegan:touches withEvent:event];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UIScrollView class]]) {
    } else {
        [[self nextResponder] touchesMoved:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)])
        {
            [super touchesMoved:touches withEvent:event];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isMemberOfClass:[UIScrollView class]]) {
    } else {
        [[self nextResponder] touchesEnded:touches withEvent:event];
        if ([super respondsToSelector:@selector(touchesBegan:withEvent:)]) {
            [super touchesEnded:touches withEvent:event];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

