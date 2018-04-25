//
//  LoanViewController.m
//  HYM
//
//  Created by  song on 2018/1/11.
//  Copyright © 2018年  song. All rights reserved.
//

#import "LoanViewController.h"
#import "AddLoanViewController.h"
#import "LKLoanModel.h"
#import "LoanCell.h"

@interface LoanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) MSBaseTableView *tableView;

@end

@implementation LoanViewController

- (MSBaseTableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[MSBaseTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight - 44 - STATUS_HEIGHT - 49)
                                                      style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"借款";
    [self setupRightMenuButton:@"account_add" title:@""];
    
    dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDataFromDB];
}

- (void)getDataFromDB{
    
    [dataArray removeAllObjects];
    
    NSMutableArray *array = [LKLoanModel searchWithWhere:nil];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];//yes升序排列，no,降序排列
    //按日期降序排列的日期数组
    NSArray *myarray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    
    __block NSMutableSet *groupSet = [NSMutableSet set];
    [myarray enumerateObjectsUsingBlock:^(LKLoanModel *obj,NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![groupSet containsObject:[NSString stringWithFormat:@"name == %@",obj.name]]) {
            [groupSet addObject:[NSString stringWithFormat:@"name == %@",obj.name]];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"name == %@",obj.name];
            NSArray *indexArray = [array filteredArrayUsingPredicate:pre];
            [dataArray addObject:indexArray];
        }
    }];
    
    [self.tableView reloadData];
}


- (void)rightButtonPressed:(UIButton *)button{
    //子类重写该方法
    AddLoanViewController *addLoanCtrl = [AddLoanViewController new];
    addLoanCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addLoanCtrl animated:YES];
}

#pragma mark -UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LKLoanModel *model = dataArray[section][0];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, ScreenWidth/2.0, 20)];
    leftLabel.text = [NSString stringWithFormat:@"%@",model.name];
    [leftLabel setTextColor:RGBA(0x666666, 1.0)];
    [leftLabel setFont:[UIFont systemFontOfSize:12]];
    [leftLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:leftLabel];
    //分割线
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 29, ScreenWidth, 1.0)];
    lineImage.backgroundColor = RGBA(0xDDDDDD, 1.0);
    lineImage.tag = 101;
    [headerView addSubview:lineImage];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"LoanCellIdentifier";
    LoanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[LoanCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        [cell awakeFromNib];
    }
    for (UIView *vw in cell.contentView.subviews) {
        
        if (101 == vw.tag) {
            [vw removeFromSuperview];
        }
    }
    
    //分割线
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(45.0, 49, ScreenWidth-45, 1.0)];
    lineImage.backgroundColor = RGBA(0xDDDDDD, 1.0);
    lineImage.tag = 101;
    [cell.contentView addSubview:lineImage];
    
    LKLoanModel *model = dataArray[indexPath.section][indexPath.row];
    [cell setUI:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        LKLoanModel *model = dataArray[indexPath.section][indexPath.row];
        [LKLoanModel deleteWithWhere:[NSString stringWithFormat:@"uniqueid = %@",model.uniqueid]];
        [self getDataFromDB];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
