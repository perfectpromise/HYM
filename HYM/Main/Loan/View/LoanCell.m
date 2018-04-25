//
//  LoanCell.m
//  HYM
//
//  Created by  song on 2018/1/11.
//  Copyright © 2018年  song. All rights reserved.
//

#import "LoanCell.h"
#import "UIImageView+AddCorner.h"

@interface LoanCell (){
    UILabel *dateLabel;    //名称
    UILabel *quatoLabel;    //金额
}

@end

@implementation LoanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //图标
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 10.0, 30.0, 30.0)];
    iconImage.image = [UIImage imageNamed:@"account_icon"];
    [iconImage addCorner:15];
    [self.contentView addSubview:iconImage];
    
    //名称
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 15.0, 150, 20.0)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = RGBA(0x333333, 1.0);
    dateLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:dateLabel];
    
    //额度
    quatoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-115, 15.0, 100.0, 20.0)];
    quatoLabel.backgroundColor = [UIColor clearColor];
    quatoLabel.textAlignment = NSTextAlignmentRight;
    quatoLabel.textColor = RGBA(0x333333, 1.0);
    quatoLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:quatoLabel];
}

- (void)setUI:(LKLoanModel *)model{
    
    dateLabel.text = model.date;
    quatoLabel.text = model.money;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
