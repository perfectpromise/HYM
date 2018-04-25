//
//  UIImageView+AddCorner.m
//  BeadWallet
//
//  Created by WS on 2017/10/26.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "UIImageView+AddCorner.h"

@implementation UIImageView (AddCorner)

- (void)addCorner:(float)radius{
    if (self.image) {
        self.image = [self drawRectWithRoundedCorner:radius];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    layer.path = aPath.CGPath;
    self.layer.mask = layer;
}

- (UIImage *)drawRectWithRoundedCorner:(float)radius{
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerAllCorners
                                                     cornerRadii:CGSizeMake(radius,radius)];
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawRect:self.bounds];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}
@end
