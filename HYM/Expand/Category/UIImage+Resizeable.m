//
//  UIImage+Resizeable.m
//
//
//  
//
//

#import "UIImage+Resizeable.h"

@implementation UIImage (Resizeable)

-(UIImage *)resizableButton
{
    UIEdgeInsets insert = {self.size.height*0.5, self.size.width*0.5, self.size.height*0.5, self.size.width*0.5};
    return [self resizableImageWithCapInsets:insert];
}

-(UIImage *)resizableBg
{
    UIEdgeInsets insert = {self.size.height*0.5-0.5, self.size.width*0.5-0.5, self.size.height*0.5-0.5, self.size.width*0.5-0.5};
    return [self resizableImageWithCapInsets:insert];
}

- (UIImage *)circleImage {
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

@end
