//
//  SearchWKWebView.m
//  OneKeySearch
//
//  Created by WS on 2017/11/7.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "SearchWKWebView.h"

@implementation SearchWKWebView

#define ButtonWidth     (self.frame.size.width - 80)/4
#pragma mark - lazy
- (WKWebView *)webView
{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50)];
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
        self.progressView.tintColor = [UIColor orangeColor];
        self.progressView.trackTintColor = [UIColor whiteColor];
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (UIButton *)backButton{
    
    if (!_backButton) {
        //添加按钮
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(40, self.frame.size.height-50, ButtonWidth, 50.0);
        [_backButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"btn_back_disable"] forState:UIControlStateDisabled];
        _backButton.enabled = NO;
        _backButton.tag = 100;
        [_backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)forwardButton{
    
    if (!_forwardButton) {
        //添加按钮
        _forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwardButton.frame = CGRectMake(40 + ButtonWidth, self.frame.size.height-50, ButtonWidth, 50.0);
        [_forwardButton setImage:[UIImage imageNamed:@"btn_forward_normal"] forState:UIControlStateNormal];
        [_forwardButton setImage:[UIImage imageNamed:@"btn_forward_disable"] forState:UIControlStateDisabled];
        _forwardButton.enabled = NO;
        _forwardButton.tag = 101;
        [_forwardButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forwardButton;
}

- (UIButton *)reloadButton{
    
    if (!_reloadButton) {
        //添加按钮
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(40 + 2 * ButtonWidth, self.frame.size.height-50, ButtonWidth, 50.0);
        [_reloadButton setImage:[UIImage imageNamed:@"btn_refresh"] forState:UIControlStateNormal];
        _reloadButton.tag = 102;
        [_reloadButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (UIButton *)moreButton{
    
    if (!_moreButton) {
        //添加按钮
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(40 + 3 * ButtonWidth, self.frame.size.height-50, ButtonWidth, 50.0);
        [_moreButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
        _moreButton.tag = 103;
        [_moreButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (id)initWithFrame:(CGRect)frame withUrl:(NSString *)url{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0xF5F5F5, 1.0);
        [self addSubview:self.progressView];
        [self addSubview:self.webView];
        [self insertSubview:self.webView belowSubview:self.progressView];
        
        [self addSubview:self.backButton];
        [self addSubview:self.forwardButton];
        [self addSubview:self.reloadButton];
        [self addSubview:self.moreButton];
        
        //
        NSString *customUserAgent = @"mobile";
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:30.f];
        [self.webView loadRequest:request];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)btn{
    
    if (btn.tag == 100) { //返回
        [self.webView goBack];
    }else if (btn.tag == 101){ //下一页
        [self.webView goForward];
        
    }else if (btn.tag == 102){ //刷新
        [self.webView reload];
        
    }else if (btn.tag == 103){ //更多
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchMore:)]) {
            [self.delegate searchMore:self];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else if ([keyPath isEqualToString:@"canGoBack"]) {
        BWLog(@"canGoBack:%d",self.webView.canGoBack);
        self.backButton.enabled = self.webView.canGoBack;
    }else if ([keyPath isEqualToString:@"canGoForward"]){
        BWLog(@"canGoForward:%d",self.webView.canGoForward);
        self.forwardButton.enabled = self.webView.canGoForward;
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败:%@",error);
    //加载失败同样需要隐藏progressView
    //self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    BWLog(@"didReceiveServerRedirectForProvisionalNavigation");
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    BWLog(@"didCommitNavigation");
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    BWLog(@"didFailNavigation");
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    BWLog(@"webViewWebContentProcessDidTerminate");
    
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType==UIWebViewNavigationTypeBackForward) {
        
        NSLog(@"");
    }
    return YES;
}

@end

