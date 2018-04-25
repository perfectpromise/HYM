//
//  BWButon.h
//  BeadWallet
//
//  Created by LWF on 17/7/21.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWButon : UIView

typedef enum {
    BWButtonAlignmentLeft = 0,
    BWButtonAlignmentCenter,
    BWButtonAlignmentRight,
}BWButtonAlignmentType;

@property (nonatomic, strong) UIButton              *button;
@property (nonatomic, strong) UILabel               *label;
@property (nonatomic, assign) BWButtonAlignmentType alignmentType;

- (void)setLabelText:(NSString*)text;
- (void)setTextColor:(UIColor*)textColor;
- (void)setButtonText:(NSString *)text;

- (void)addButtonTarget:(id)target
                 action:(SEL)action
       forControlEvents:(UIControlEvents)controlEvents;

@end
