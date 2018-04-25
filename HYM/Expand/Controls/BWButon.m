//
//  BWButon.m
//  BeadWallet
//
//  Created by LWF on 17/7/21.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "BWButon.h"

#define FONT_SIZE_DEFAULT 14.0f
#define BACKGROUND_COLOR [UIColor clearColor]
#define TEXT_COLOR RGBA(0x333333, 1.0)
#define BUTTON_COLOR RGBA(0x55D1DA, 1.0)

@implementation BWButon

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_label setTextColor:TEXT_COLOR];
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_label setFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT]];
        [_label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _button.backgroundColor = [UIColor clearColor];
        [_button setTitleColor:BUTTON_COLOR forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT]];
        [_button setFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_button];
        
        self.alignmentType = BWButtonAlignmentCenter;
    }
    return self;
}

- (void)setLabelText:(NSString*)text{
    
    [_label setText:text];
}

- (void)setTextColor:(UIColor *)textColor{
    
    [_label setTextColor:textColor];
}

- (void)setButtonText:(NSString *)text{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:BUTTON_COLOR range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT] range:strRange];
    [_button setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)addButtonTarget:(id)target
                 action:(SEL)action
       forControlEvents:(UIControlEvents)controlEvents
{
    
    [_button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)drawRect:(CGRect)rect{
    
    CGRect labelRect = [_label.text boundingRectWithSize:CGSizeMake(ScreenWidth,20)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT]}
                                                              context:nil];
    
    CGRect buttonRect = [_button.titleLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth,20)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT]}
                                              context:nil];
    float totalWidth = labelRect.size.width + buttonRect.size.width;
    
    if (self.alignmentType == BWButtonAlignmentLeft) {
        
        [_label setTextAlignment:NSTextAlignmentLeft];
        _label.frame = CGRectMake(0.0, 0.0, labelRect.size.width+2, self.bounds.size.height);
        _button.frame = CGRectMake(labelRect.size.width+2, 0.0, buttonRect.size.width+5, self.bounds.size.height);
        
    }else if (self.alignmentType == BWButtonAlignmentCenter){
        
        [_label setTextAlignment:NSTextAlignmentRight];
        _label.frame = CGRectMake((self.bounds.size.width-totalWidth)/2-5, 0.0, labelRect.size.width+5, self.bounds.size.height);
        _button.frame = CGRectMake((self.bounds.size.width-totalWidth)/2+labelRect.size.width, 0.0, buttonRect.size.width+5, self.bounds.size.height);
        
    }else if (self.alignmentType == BWButtonAlignmentRight){
        
        [_label setTextAlignment:NSTextAlignmentRight];
        _label.frame = CGRectMake(self.bounds.size.width-totalWidth-7, 0.0, labelRect.size.width+7, self.bounds.size.height);
        _button.frame = CGRectMake(self.bounds.size.width-buttonRect.size.width-5, 0.0, buttonRect.size.width+5, self.bounds.size.height);
    }
    
    [_label layoutIfNeeded];
}

@end
