//
//  NavButton.m
//  TogetherAPP
//
//  Created by WS on 2017/11/14.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton

- (void)layoutSubviews{

    [super layoutSubviews];

    CGFloat bx = (self.frame.size.width - self.imageView.frame.size.width - self.titleLabel.frame.size.width)/2;
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = 0;
    titleRect.origin.y = (self.frame.size.height - titleRect.size.height)/2.0f;

    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(10, 7);
    imageRect.origin.x = (bx + self.titleLabel.frame.size.width + 3.f) ;
    imageRect.origin.y = (self.frame.size.height  - 7)/2.0f;
    
    self.imageView.frame = imageRect;
    
    self.titleLabel.frame = titleRect;

}

@end
