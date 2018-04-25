//
//  HomeListCell.m
//  WaterWallet
//
//  Created by LWF on 17/7/18.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "HomeListCell.h"

@implementation HomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUI:(NSString *)iconImg
        title:(NSString *)titleStr
{
    self.iconImg.image = [UIImage imageNamed:iconImg];
    self.nameLbl.text = titleStr;
}
@end
