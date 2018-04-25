//
//  SearchWKWebView.h
//  OneKeySearch
//
//  Created by WS on 2017/11/7.
//  Copyright © 2017年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol SearchWKWebViewDelegate <NSObject>
- (void)searchMore:(id)webView;
@end

@interface SearchWKWebView : UIView<WKNavigationDelegate>

@property id<SearchWKWebViewDelegate>delegate;

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIButton *moreButton;

- (id)initWithFrame:(CGRect)frame withUrl:(NSString *)url;

@end
