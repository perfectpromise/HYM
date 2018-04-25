//
//  ListViewCell.h
//  OneKeySearch
//
//  Created by WS on 2017/11/13.
//  Copyright © 2017年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  代理，用来传递点击的是第几行,当触CollectionView的时候
 */
@protocol  ListItemCellDelegate <NSObject>

-(void)clickSelectedItem:(NSInteger)tag;

@end

@interface ListViewCell : UITableViewCell

/**
 *  数据源数组用来接受controller传过来的数据
 */
@property (strong, nonatomic) NSArray *selectedArray;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id <ListItemCellDelegate> delegate;

@end
