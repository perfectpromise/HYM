//
//  AddAccountViewController.m
//  DreamWallet
//
//  Created by  song on 2017/12/7.
//

#import "AddAccountViewController.h"
#import "PGDatePicker.h"
#import "XZPickView.h"
#import "LKAccountModel.h"
#import "UIImage+Color.h"

@interface AddAccountViewController ()<PGDatePickerDelegate,XZPickViewDelegate, XZPickViewDataSource>
{
    UIButton *typeButton;
    UITextField *moneyTxtField;

    UIButton *dateButton;
    UITextField *markTxtField;

}
@end

@implementation AddAccountViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)setupLeftMenuButton:(NSString *)titleStr{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, STATUS_HEIGHT+44)];
    bg.image = [UIImage imageWithColor:RGBA(0x6DD4E0, 1.0)];
    [self.view addSubview:bg];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0f, STATUS_HEIGHT, 80.0f, 44.0f)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, 20);//图片左移20
    [button addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)initUI{
    NSArray *typeArray = @[@"类型",@"金额",@"日期",@"备注"];
    float yPos = STATUS_HEIGHT+44;
    
    for (int i = 0; i < typeArray.count; i++) {
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, yPos + 50.0 * (i) + 15, 80, 20.0)];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textColor = RGBA(0x666666, 1.0);
        typeLabel.font = [UIFont systemFontOfSize:15];
        typeLabel.text = typeArray[i];
        [self.view addSubview:typeLabel];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0,  yPos + 50.0 * (i + 1) - 1, ScreenWidth - 15, 1.0)];
        lineImage.backgroundColor = RGBA(0xE5E5E5, 1.0);
        [self.view addSubview:lineImage];
    }
    
    //选择类型
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton.backgroundColor = [UIColor clearColor];
    typeButton.frame = CGRectMake(100.0,  yPos + 5.0, ScreenWidth-100, 40.0);
    [typeButton addTarget:self action:@selector(selectTypeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [typeButton setTitle:@"支出" forState:UIControlStateNormal];
    [typeButton setTitleColor:RGBA(0x333333, 1.0) forState:UIControlStateNormal];
    typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [typeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:typeButton];
    
    //金额
    moneyTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100.0,  yPos + 55.0, ScreenWidth-100, 40.0)];
    moneyTxtField.backgroundColor = [UIColor clearColor];
    moneyTxtField.borderStyle = UITextBorderStyleNone;
    moneyTxtField.font = [UIFont systemFontOfSize:14];
    moneyTxtField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTxtField.placeholder = @"请输入金额";
    moneyTxtField.textColor = RGBA(0x333333, 1.0);
    [self.view addSubview:moneyTxtField];
    
    //选择日期
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.backgroundColor = [UIColor clearColor];
    dateButton.frame = CGRectMake(100.0,  yPos + 105.0, ScreenWidth-100, 40.0);
    [dateButton addTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setTitle:[self getCurrentDate] forState:UIControlStateNormal];
    [dateButton setTitleColor:RGBA(0x333333, 1.0) forState:UIControlStateNormal];
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [dateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:dateButton];
    
    //备注
    markTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100.0,  yPos + 155.0, ScreenWidth-100, 40.0)];
    markTxtField.backgroundColor = [UIColor clearColor];
    markTxtField.borderStyle = UITextBorderStyleNone;
    markTxtField.font = [UIFont systemFontOfSize:14];
    markTxtField.placeholder = @"请输入备注";
    markTxtField.textColor = RGBA(0x333333, 1.0);
    [self.view addSubview:markTxtField];
}

- (NSString *)getCurrentDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];//当前用户的calendar
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents * components = [calendar components:NSCalendarUnitYear | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:components];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    
    NSString *tmpStr = [NSString stringWithFormat:@"%ld年%ld月%ld日  %@",(long)year,(long)month,(long)day,[self getWeekday:[weekdayComponents weekday]]];
    
    return tmpStr;
}

- (void)selectTypeButtonPressed{
    [self.view endEditing:YES];

    NSArray *titleArray = @[@"支出",@"收入"];
    
    XZPickView *pickView = [[XZPickView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择"];
    pickView.delegate = self;
    pickView.dataSource = self;
    [pickView reloadData];
    [[UIApplication sharedApplication].keyWindow addSubview:pickView];
    [pickView show];
    [pickView selectRow:[titleArray indexOfObject:typeButton.titleLabel.text] inComponent:0 animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLeftMenuButton:@"添加账目"];
    [self initUI];
}

- (void)leftBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    if (![GW_TextHelper checkTextContent:moneyTxtField.text] ||
        ![GW_TextHelper checkTextContent:markTxtField.text]) {
        [self alertWithTitle:nil
                     message:@"信息未填写完整，是否放弃填写？"
                cancelButton:@"取消"
                    okButton:@"确定"
        clickedButtonAtIndex:^(NSInteger index){
            if (index == 1) {
                [self.navigationController popViewControllerAnimated:YES];

            }

        }];
    }else{
        NSString *str = dateButton.titleLabel.text;
        NSArray *arrayYear = [str componentsSeparatedByString:@"年"];
        NSArray *arrayMonth = [arrayYear[1] componentsSeparatedByString:@"月"];
        NSArray *arrayDay = [arrayMonth[1] componentsSeparatedByString:@"日"];
        
        //插入数据
        LKAccountModel *accountModel = [[LKAccountModel alloc]init];
        accountModel.type = typeButton.titleLabel.text;
        accountModel.money = moneyTxtField.text;
        accountModel.year = [arrayYear[0] integerValue];
        accountModel.month = [arrayMonth[0] integerValue];
        accountModel.day = [arrayDay[0] integerValue];
        accountModel.weekday = [arrayDay[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        accountModel.mark = markTxtField.text;
        accountModel.uniqueid = [self currentTimeStr];
        [accountModel saveToDB];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectButtonPressed{
    [self.view endEditing:YES];

    PGDatePicker *datePicker = [[PGDatePicker alloc]init];
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.delegate = self;
    datePicker.titleLabel.text = @"选择日期";
    [datePicker setDate:[self getCurrentSelectDate]];
    [datePicker show];
}

- (NSDate *)getCurrentSelectDate{
    
    NSString *str = dateButton.titleLabel.text;
    
    NSArray *arrayYear = [str componentsSeparatedByString:@"年"];
    NSArray *arrayMonth = [arrayYear[1] componentsSeparatedByString:@"月"];
    NSArray *arrayDay = [arrayMonth[1] componentsSeparatedByString:@"日"];
    
    return [NSDate setYear:[arrayYear[0] integerValue] month:[arrayMonth[0] integerValue] day:[arrayDay[0] integerValue]];
}

- (NSString *)getWeekday:(NSInteger)week{
    
    switch (week) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark- XZPickViewDelegate
-(void)pickView:(XZPickView *)pickerView confirmButtonClick:(UIButton *)button{
    
    NSArray *titleArray = @[@"支出",@"收入"];

    NSInteger selectBankIndex = [pickerView selectedRowInComponent:0];
    [typeButton setTitle:titleArray[selectBankIndex] forState:UIControlStateNormal];
}

-(NSInteger)pickerView:(XZPickView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return 2;
}

-(NSString *)pickerView:(XZPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *titleArray = @[@"支出",@"收入"];
    return titleArray[row];
}

-(NSInteger)numberOfComponentsInPickerView:(XZPickView *)pickerView{
    return 1;
}

#pragma mark -PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    NSInteger year = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:dateComponents];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    
    NSString *tmpStr = [NSString stringWithFormat:@"%ld年%ld月%ld日  %@",(long)year,(long)month,(long)day,[self getWeekday:[weekdayComponents weekday]]];
    
    [dateButton setTitle:tmpStr forState:UIControlStateNormal];

}

@end
