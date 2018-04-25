//
//  UIWebView+TXInputView.m
//  HYM
//
//  Created by song on 2018/4/9.
//  Copyright © 2018年  song. All rights reserved.
//

#import "UIWebView+TXInputView.h"
#import <objc/runtime.h>

@implementation UIWebView (TXInputView)

static const char * const hackishFixClassName = "UIWebBrowserViewMinusView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
            
        }
        
    }
    return browserView;
    
}

- (id)methodReturnKeyboard {
    return nil;
    
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturnKeyboard)];
        class_addMethod(newClass, @selector(inputView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        hackishFixClass = newClass;    }
    
}

- (BOOL) hackishlyHidesInputView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
    
}

- (void) setHackishlyHidesInputView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
        
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    if (value) {
        object_setClass(browserView, hackishFixClass);
        
    }else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
        
    }
    [browserView reloadInputViews];
    
}
@end
