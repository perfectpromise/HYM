//
//  AddLoanViewController.m
//  HYM
//
//  Created by  song on 2018/1/11.
//  Copyright © 2018年  song. All rights reserved.
//

#import "AddLoanViewController.h"
#import "PGDatePicker.h"
#import "LKLoanModel.h"
#import "UIImage+Color.h"

@interface AddLoanViewController ()<PGDatePickerDelegate>
{
    UITextField *nameTxtField;
    UIButton *dateButton;

    UITextField *moneyTxtField;
}

@end

@implementation AddLoanViewController
    
- (void)initUI{
    NSArray *typeArray = @[@"姓名",@"日期",@"金额"];
    float yPos = 0.0;
    
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
    
    //备注
    nameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100.0,  yPos+5, ScreenWidth-100, 40.0)];
    nameTxtField.backgroundColor = [UIColor clearColor];
    nameTxtField.borderStyle = UITextBorderStyleNone;
    nameTxtField.font = [UIFont systemFontOfSize:14];
    nameTxtField.placeholder = @"请输入姓名";
    nameTxtField.textColor = RGBA(0x333333, 1.0);
    [self.view addSubview:nameTxtField];
    
    //选择日期
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.backgroundColor = [UIColor clearColor];
    dateButton.frame = CGRectMake(100.0,  yPos + 55.0, ScreenWidth-100, 40.0);
    [dateButton addTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setTitle:[self getCurrentDate] forState:UIControlStateNormal];
    [dateButton setTitleColor:RGBA(0x333333, 1.0) forState:UIControlStateNormal];
    dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [dateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:dateButton];
    
    //金额
    moneyTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100.0,  yPos + 105.0, ScreenWidth-100, 40.0)];
    moneyTxtField.backgroundColor = [UIColor clearColor];
    moneyTxtField.borderStyle = UITextBorderStyleNone;
    moneyTxtField.font = [UIFont systemFontOfSize:14];
    moneyTxtField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTxtField.placeholder = @"请输入金额";
    moneyTxtField.textColor = RGBA(0x333333, 1.0);
    [self.view addSubview:moneyTxtField];
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
    
    NSString *tmpStr = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    return tmpStr;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增借款信息";
    [self initUI];
    [self customBackButton];
}
    
    // 自定义返回按钮
- (void)customBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0.0f, 0.0f, 80.0f, 44.0f);
    backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)backBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    if (![GW_TextHelper checkTextContent:moneyTxtField.text] ||
        ![GW_TextHelper checkTextContent:nameTxtField.text]) {
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
        
        //插入数据
        LKLoanModel *loanModel = [LKLoanModel new];
        loanModel.name = nameTxtField.text;
        loanModel.money = moneyTxtField.text;
        loanModel.date = dateButton.titleLabel.text;
        loanModel.uniqueid = [self currentTimeStr];
        [loanModel saveToDB];
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
    
    NSString *tmpStr = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    
    [dateButton setTitle:tmpStr forState:UIControlStateNormal];
    
}


@end
