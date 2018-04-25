//
//  UserListCell.h
//  WaterWallet
//
//  Created by LWF on 17/7/18.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

- (void)setUI:(NSString *)iconImg
        title:(NSString *)titleStr;

@end
