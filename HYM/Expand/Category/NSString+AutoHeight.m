//
//  NSString+AutoHeight.m
//  BeadWallet
//
//  Created by LWF on 2017/8/28.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "NSString+AutoHeight.h"

@implementation NSString (AutoHeight)

- (float) getHeight:(UIFont *)font withWidth:(float)width{
    
    CGRect labelRect = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:font}
                                                        context:nil];
    
    return MAX(labelRect.size.height, 20);
}

+(NSMutableAttributedString *)queryAttributedString:(NSString *)NormalString andRange:(NSRange)makeRange andNewFont:(CGFloat)newFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",NormalString]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:newFont] range:makeRange];
    return str;
}
@end
