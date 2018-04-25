//
//  HomeViewController.m
//  HYM
//
//  Created by  song on 2018/4/16.
//  Copyright © 2018年  song. All rights reserved.
//

#import "HomeViewController.h"
#import "PlatformViewController.h"

#import "HomeListCell.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) MSBaseTableView *tableView;

@end

@implementation HomeViewController

- (MSBaseTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[MSBaseTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight-49)
                                                      style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delaysContentTouches = NO;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = RGBA(0xEDEAF2, 1.0);

    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 60)];
    vw.backgroundColor = [UIColor clearColor];
    return vw;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"HomeListCellIdentifier";
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HomeListCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSArray *iconArr = [NSArray arrayWithObjects:@"home_sell",@"home_mark",@"home_auth",
                        @"home_unsure",@"home_end",nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"交易",@"签到",@"认证",
                         @"待定",@"结束",nil];
    
    [cell setUI:iconArr[indexPath.row] title:titleArr[indexPath.row]];
    
    for (UIView *vw in cell.contentView.subviews) {
        
        if (100 == vw.tag) {
            [vw removeFromSuperview];
        }
    }
    
    if (indexPath.row < titleArr.count-1) {
        //分割线
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(47.0, 54, ScreenWidth-47, 0.5)];
        lineImg.backgroundColor = RGBA(0xDDDDDD, 1.0);
        lineImg.tag = 100;
        [cell.contentView addSubview:lineImg];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"交易",@"签到",@"认证",
                         @"待定",@"结束",nil];
    
    NSString *platformUrl = [NSString stringWithFormat:@"PlatUrl_%ld",(long)(indexPath.row+1)];
    PlatformViewController *platformCtrl = [PlatformViewController new];
    platformCtrl.platformUrl = platformUrl;
    platformCtrl.hidesBottomBarWhenPushed = YES;
    platformCtrl.title = titleArr[indexPath.row];
    [self.navigationController pushViewController:platformCtrl animated:YES];
}
@end
