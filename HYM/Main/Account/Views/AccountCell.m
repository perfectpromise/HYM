//
//  AccountCell.m
//  DreamWallet
//
//  Created by  song on 2017/12/7.
//

#import "AccountCell.h"
#import "UIImageView+AddCorner.h"

@interface AccountCell (){
    UILabel *titleLabel;    //名称
    UILabel *quatoLabel;    //金额
}

@end

@implementation AccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //图标
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 10.0, 30.0, 30.0)];
    iconImage.image = [UIImage imageNamed:@"account_icon"];
    [iconImage addCorner:15];
    [self.contentView addSubview:iconImage];
    
    //名称
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 15.0, 120, 20.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = RGBA(0x333333, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    
    //额度
    quatoLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-115, 15.0, 100.0, 20.0)];
    quatoLabel.backgroundColor = [UIColor clearColor];
    quatoLabel.textAlignment = NSTextAlignmentRight;
    quatoLabel.textColor = RGBA(0x333333, 1.0);
    quatoLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:quatoLabel];
}

- (void)setUI:(LKAccountModel *)model{
    titleLabel.text = model.mark;
    
    if ([model.type isEqualToString:@"支出"]) {
        quatoLabel.text = [NSString stringWithFormat:@"-%@",model.money];

    }else{
        quatoLabel.text = model.money;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
