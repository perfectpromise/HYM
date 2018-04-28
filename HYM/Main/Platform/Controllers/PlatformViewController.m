//
//  ListViewController.m
//  TogetherAPP
//
//  Created by song on 2017/11/12.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "PlatformViewController.h"
#import "ListViewCell.h"

#import "SingleWKWebViewController.h"
#import "RespItem.h"

@interface PlatformViewController ()<UITableViewDelegate,UITableViewDataSource,ListItemCellDelegate>
{
}
@property(nonatomic,strong) MSBaseTableView *tableView;
@property(nonatomic,strong) RespSearchURLItem *itemModel;

@end

@implementation PlatformViewController

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
    self.view.backgroundColor = RGBA(0xEDEAF2, 1.0);

    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.platformUrl ofType:@"geojson"]];

    self.itemModel = [RespSearchURLItem yy_modelWithJSON:JSONData];

    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchViewCellDelegate
-(void)clickSelectedItem:(NSInteger)tag{
    ImageItem *imageItem = self.itemModel.result[tag];
    
    SingleWKWebViewController *webCtrl = [SingleWKWebViewController new];
    webCtrl.hidesBottomBarWhenPushed = YES;
    webCtrl.title = imageItem.name;
    webCtrl.searchUrl = imageItem.url;
    [self.navigationController pushViewController:webCtrl animated:YES];
}

#pragma mark -UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger rowCount = (ScreenWidth - 6) / 80;
    
    NSInteger flag = 0;

    if (self.itemModel.result.count%rowCount != 0) {
        flag = 1;
    }
    if (self.itemModel.result.count > 0) {
        return (self.itemModel.result.count/rowCount + flag) * 100 + 30;
    }
    return 0.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger rowCount = (ScreenWidth - 6) / 80;
    
    NSInteger flag = 0;
    
    if (self.itemModel.result.count%rowCount != 0) {
        flag = 1;
    }
    if (self.itemModel.result.count > 0) {
        return (self.itemModel.result.count/rowCount + flag) * 100 + 30;
    }
    return 0.0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ListItemCellIdentifier";
    
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ListViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        [cell awakeFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.textLabel.text = nil;

    //数据渲染
    cell.selectedArray = self.itemModel.result;
    [cell.collectionView reloadData];
    return cell;

}

@end
