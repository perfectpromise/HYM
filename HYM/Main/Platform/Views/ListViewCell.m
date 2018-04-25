//
//  ListViewCell.m
//  OneKeySearch
//
//  Created by WS on 2017/11/13.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "ListViewCell.h"
#import "SelectedCollectionViewCell.h"
#import "RespSearchItem.h"

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UINib *nib = [UINib nibWithNibName:@"SelectedCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"SelectedCollectionViewCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageArray = @[@"search_dongman",@"search_movie",@"search_zhongzi",
                            @"recommend_book",@"recommend_tuili",@"recommend_ufo",
                            @"joke_cool",@"joke_fuli",@"joke_happy",
                            @"joke_neihan",@"joke_sister",@"joke_youyisi"];
    
    ImageItem *item = self.selectedArray[indexPath.row];
    SelectedCollectionViewCell *collcell = [collectionView
                                            dequeueReusableCellWithReuseIdentifier:@"SelectedCollectionViewCell"
                                            forIndexPath:indexPath];
    collcell.tag = indexPath.row;
    collcell.iconImg.image = [UIImage imageNamed:imageArray[indexPath.row%imageArray.count]];
    collcell.titleLbl.text = item.name;
    return collcell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80.0, 90.0);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5.0, 3, 5.0, 3);
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if([self.delegate respondsToSelector:@selector(clickSelectedItem:)])
    {
        [self.delegate clickSelectedItem:cell.tag];
    }
    
}

@end
