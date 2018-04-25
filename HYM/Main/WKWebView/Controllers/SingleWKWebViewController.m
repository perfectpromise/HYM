//
//  SingleWKWebViewController.m
//  TogetherAPP
//
//  Created by WS on 2017/11/13.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "SingleWKWebViewController.h"
#import "SearchWKWebView.h"

@interface SingleWKWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate,SearchWKWebViewDelegate>

@end

@implementation SingleWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SearchWKWebView *searchView = [[SearchWKWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-64) withUrl:self.searchUrl];
    searchView.delegate = self;

    [self.view addSubview:searchView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchWKWebViewDelegate
- (void)searchMore:(id)webView{
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"拷贝网址到剪贴板"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                           pasteboard.string = self.searchUrl;
                                                       }];
    
    UIAlertAction *openSafariAction = [UIAlertAction actionWithTitle:@"在浏览器中打开中打开"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 //解决延时问题
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     
                                                                     UIApplication *application = [UIApplication sharedApplication];
                                                                     if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                                                         [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ucbrowser://%@",self.searchUrl]] options:@{}
                                                                            completionHandler:nil];
                                                                     } else {
                                                                         [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"ucbrowser://%@",self.searchUrl]]];
                                                                     }
                                                                 });
                                                             }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                           }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:copyAction];
    [actionSheetController addAction:openSafariAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}
@end
