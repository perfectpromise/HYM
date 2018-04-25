//
//  AccountViewController.m
//  DreamWallet
//
//  Created by  song on 2017/12/7.
//

#import "AccountViewController.h"
#import "AddAccountViewController.h"

#import "NavButton.h"
#import "NSString+AutoHeight.h"
#import "AccountCell.h"
#import "LKAccountModel.h"
#import "UIImage+Color.h"

#import "PGDatePicker.h"
@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate>
{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) NavButton *monthButton;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *payLabel;


@property (nonatomic, strong) MSBaseTableView *tableView;

@end

@implementation AccountViewController

- (void)setNavBackgroud{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, STATUS_HEIGHT+44+65)];
    bg.image = [UIImage imageWithColor:RGBA(0x6DD4E0, 1.0)];
    [self.view addSubview:bg];
    
    //收入
    UILabel *incomeTip = [[UILabel alloc] initWithFrame:CGRectMake(130, STATUS_HEIGHT+44, 80, 20)];
    incomeTip.text = @"收入";
    [incomeTip setTextColor:RGBA(0x666666, 1.0)];
    [incomeTip setFont:[UIFont boldSystemFontOfSize:12]];
    [incomeTip setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:incomeTip];
    
    //支出
    UILabel *payTip = [[UILabel alloc] initWithFrame:CGRectMake(250, STATUS_HEIGHT+44, 80, 20)];
    payTip.text = @"支出";
    [payTip setTextColor:RGBA(0x666666, 1.0)];
    [payTip setFont:[UIFont boldSystemFontOfSize:12]];
    [payTip setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:payTip];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, STATUS_HEIGHT+44+30, 1.0, 25)];
    line.backgroundColor = RGBA(0x999999, 1.0);
    [self.view addSubview:line];
}

- (void)setupRightMenuButton:(NSString *)titleStr{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"account_add"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(ScreenWidth-80, STATUS_HEIGHT, 80.0f, 44.0f)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);//图片左移20
    [button addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, STATUS_HEIGHT, ScreenWidth-169, 44)];
    label.text = titleStr;
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
}

- (MSBaseTableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[MSBaseTableView alloc] initWithFrame:CGRectMake(0.0, STATUS_HEIGHT+44+65, ScreenWidth, ScreenHeight - 44 - STATUS_HEIGHT - 49-65)
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

- (UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, STATUS_HEIGHT+44, 80, 20)];
        [_yearLabel setTextColor:RGBA(0x666666, 1.0)];
        [_yearLabel setFont:[UIFont systemFontOfSize:12]];
        [_yearLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _yearLabel;
}

- (NavButton *)monthButton{
    if (!_monthButton) {
        _monthButton = [NavButton buttonWithType:UIButtonTypeCustom];
        _monthButton.frame = CGRectMake(15.0, STATUS_HEIGHT+44+20, 70.0, 45.0);
        [_monthButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_monthButton setTitleColor:RGBA(0x333333, 1.0) forState:UIControlStateNormal];
        [_monthButton addTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_monthButton setImage:[UIImage imageNamed:@"accounr_triangle"]  forState:UIControlStateNormal];
    }
    return _monthButton;
}

- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, STATUS_HEIGHT+44+35, 80, 20)];
        [_incomeLabel setTextColor:RGBA(0x333333, 1.0)];
        [_incomeLabel setFont:[UIFont systemFontOfSize:18]];
        [_incomeLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _incomeLabel;
}

- (UILabel *)payLabel{
    if (!_payLabel) {
        _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, STATUS_HEIGHT+44+35, 80, 20)];
        [_payLabel setTextColor:RGBA(0x333333, 1.0)];
        [_payLabel setFont:[UIFont systemFontOfSize:18]];
        [_payLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _payLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self getDataFromDB];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBackgroud];
    [self setupRightMenuButton:@"记账"];

    dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.yearLabel];
    [self.view addSubview:self.monthButton];
    [self.view addSubview:self.incomeLabel];
    [self.view addSubview:self.payLabel];

    [self.view addSubview:self.tableView];
    
    [self getCurrentDate];

}

- (void)getCurrentDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];//当前用户的calendar
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents * components = [calendar components:NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year = components.year;
    NSInteger month = components.month;

    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",(long)year];
    
    [self setMonth:[NSString stringWithFormat:@"%ld 月",(long)month]];

    [self getDataFromDB];

}

- (void)getDataFromDB{
    
    [dataArray removeAllObjects];
    NSInteger year = [[self.yearLabel.text substringToIndex:self.yearLabel.text.length-1] integerValue];
    NSInteger month = [[self.monthButton.titleLabel.text substringToIndex:self.monthButton.titleLabel.text.length-2] integerValue];
    
    NSMutableArray *array = [LKAccountModel searchWithWhere:[NSString stringWithFormat:@"year = %ld AND month = %ld",(long)year,(long)month]];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO];//yes升序排列，no,降序排列
    //按日期降序排列的日期数组
    NSArray *myarray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
    
    __block NSMutableSet *groupSet = [NSMutableSet set];
    [myarray enumerateObjectsUsingBlock:^(LKAccountModel *obj,NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![groupSet containsObject:[NSString stringWithFormat:@"day == %ld",(long)obj.day]]) {
            [groupSet addObject:[NSString stringWithFormat:@"day == %ld",(long)obj.day]];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"day == %d",obj.day];
            NSArray *indexArray = [array filteredArrayUsingPredicate:pre];
            [dataArray addObject:indexArray];
        }
    }];
    [self statisticsTotal];
    [self.tableView reloadData];
}

- (void)statisticsTotal{
    
    float income = 0;//收入
    float pay = 0;//支出
    for (NSArray *tmpArray in dataArray) {
        for (LKAccountModel *tmp in tmpArray) {
            if ([tmp.type isEqualToString:@"支出"]) {
                pay += [tmp.money floatValue];
                
            }else{
                income += [tmp.money floatValue];
            }
        }
    }
    [self setIncome:[NSString stringWithFormat:@"%0.2f",income]];
    [self setPay:[NSString stringWithFormat:@"%0.2f",pay]];
}

- (void)rightBtnClicked:(UIButton *)btn{
    
    AddAccountViewController *addAccountCtrl = [AddAccountViewController new];
    addAccountCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAccountCtrl animated:YES];
}

- (void)selectButtonPressed{
    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePicker.delegate = self;
    datePicker.titleLabel.text = @"选择月份";
    
    NSInteger year = [[self.yearLabel.text substringToIndex:self.yearLabel.text.length-1] integerValue];
    NSInteger month = [[self.monthButton.titleLabel.text substringToIndex:self.monthButton.titleLabel.text.length-2] integerValue];

    [datePicker setDate:[NSDate setYear:year month:month]];
    [datePicker show];
}

- (void)setIncome:(NSString *)money{
    NSMutableAttributedString *tempTips = [NSString queryAttributedString:money andRange:NSMakeRange(money.length-3, 3) andNewFont:12];
    self.incomeLabel.attributedText = tempTips;
}
- (void)setPay:(NSString *)money{
    NSMutableAttributedString *tempTips = [NSString queryAttributedString:money andRange:NSMakeRange(money.length-3, 3) andNewFont:12];
    self.payLabel.attributedText = tempTips;
}

- (void)setMonth:(NSString *)month{
    NSMutableAttributedString *tempTips = [NSString queryAttributedString:month andRange:NSMakeRange(month.length-1, 1) andNewFont:12];
    [self.monthButton setAttributedTitle:tempTips forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    self.yearLabel.text = [NSString stringWithFormat:@"%ld年",(long)dateComponents.year];
    [self setMonth:[NSString stringWithFormat:@"%ld 月",(long)dateComponents.month]];
    
    [self getDataFromDB];

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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LKAccountModel *model = dataArray[section][0];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5.0, ScreenWidth/2.0, 20)];
    leftLabel.text = [NSString stringWithFormat:@"%ld月%ld日  %@",(long)model.month,(long)model.day,model.weekday];
    [leftLabel setTextColor:RGBA(0x666666, 1.0)];
    [leftLabel setFont:[UIFont systemFontOfSize:12]];
    [leftLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:leftLabel];
    
    float income = 0;//收入
    float pay = 0;//支出
    
    for (LKAccountModel *tmp in dataArray[section]) {
        if ([tmp.type isEqualToString:@"支出"]) {
            pay += [tmp.money floatValue];

        }else{
            income += [tmp.money floatValue];
        }
    }
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+ScreenWidth/2.0, 5.0, ScreenWidth/2.0-30, 20)];
    rightLabel.text = [NSString stringWithFormat:@"收入：%0.2f  支出：%0.2f",income,pay];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [rightLabel setTextColor:RGBA(0x666666, 1.0)];
    [rightLabel setFont:[UIFont systemFontOfSize:12]];
    [rightLabel setBackgroundColor:[UIColor clearColor]];
    [headerView addSubview:rightLabel];
    
    //分割线
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 29, ScreenWidth, 1.0)];
    lineImage.backgroundColor = RGBA(0xDDDDDD, 1.0);
    lineImage.tag = 101;
    [headerView addSubview:lineImage];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"AccountCellIdentifier";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        [cell awakeFromNib];
    }
    for (UIView *vw in cell.contentView.subviews) {
        
        if (101 == vw.tag) {
            [vw removeFromSuperview];
        }
    }
    
    if (indexPath.row < [dataArray[indexPath.section] count]-1) {
        //分割线
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(45.0, 49, ScreenWidth-45, 1.0)];
        lineImage.backgroundColor = RGBA(0xDDDDDD, 1.0);
        lineImage.tag = 101;
        [cell.contentView addSubview:lineImage];
    }
    
    LKAccountModel *model = dataArray[indexPath.section][indexPath.row];
    [cell setUI:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        LKAccountModel *model = dataArray[indexPath.section][indexPath.row];
        [LKAccountModel deleteWithWhere:[NSString stringWithFormat:@"uniqueid = %@",model.uniqueid]];
        [self getDataFromDB];
    }
}

@end
