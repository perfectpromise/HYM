//
//  NSString+AutoHeight.h
//  BeadWallet
//
//  Created by LWF on 2017/8/28.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AutoHeight)

- (float) getHeight:(UIFont *)font withWidth:(float)width;
+(NSMutableAttributedString *)queryAttributedString:(NSString *)NormalString andRange:(NSRange)makeRange andNewFont:(CGFloat)newFont;
@end
