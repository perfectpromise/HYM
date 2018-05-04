//
//  RegisterViewController.m
//  HYM
//
//  Created by  song on 2018/4/28.
//  Copyright © 2018年  song. All rights reserved.
//

#import "RegisterViewController.h"
#import "ReqEobLogin.h"

@interface RegisterViewController ()
{
    NSString *currentPhone;  //当前获取到的手机号
    NSString *itemID;        //项目ID

}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";

    [self createButton];
    
    itemID = @"5";
}

- (void)createButton{
    
    NSArray *array = @[@"登录",@"获取手机号",@"获取验证码"];
    
    for (int i = 0; i< array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"home_apply"] forState:UIControlStateNormal];
        btn.frame = CGRectMake((ScreenWidth-255)/2.0, 30+60*i , 255, 40.0);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}

- (void)buttonPressed:(UIButton *)btn{
    
    if (btn.tag == 100) { //登录
        [self smLogin];
    }else if(btn.tag == 101){ //获取手机号
        [self getPhone];
    }else if(btn.tag == 102){ //获取验证码
        [self getMessage];
    }
}

/*登录
 token&
 账户余额&
 最大登录客户端个数&
 最多获取号码数&
 单个客户端最多获取号码数&
 折扣
 */
- (void)smLogin{

    NSString *name = @"wust419";
    NSString *password = @"st5201314";
    NSString *developKey = @"Developer=yzsmwj89ruhI00WmsZIlPA%3d%3d";

    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/uLogin?uName=%@&pWord=%@&Developer=",name,password];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"登录返回值：%@",respStr);
    NSArray *respArr = [respStr componentsSeparatedByString:@"&"];
    if (respArr.count == 7) {
        [BWSingleton sharedInstance].token = respArr[0];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
//        [self getItems];
    }else{
        [SVProgressHUD showErrorWithStatus:@"登录失败"];

    }
}


/*获取手机号
 参数名         必传    缺省值       描述
 token          Y               登录token
 ItemId         Y               项目代码
 Count          N       1       获取数量 [不填默认1个]
 Phone          N               指定号码获取 [不填则 随机]
 Area           N               区域 [不填则 随机]
 PhoneType      N       0       运营商 [不填为 0] 0 [随机] 1 [移动] 2 [联通] 3 [电信]
 onlyKey        N               私人对接Key，与卡商直接对接
 */
- (void)getPhone{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/GetPhone?ItemId=%@&token=%@",itemID,[BWSingleton sharedInstance].token];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"获取手机号：%@",respStr);
    
    NSArray *respArr = [respStr componentsSeparatedByString:@";"];
    if (respArr.count > 0) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            currentPhone = respArr[0];
    }
}

/*获取验证码
 参数名    必传    缺省值    描述
 token    Y        登录token
 ItemId    Y        项目ID
 Phone    Y        获取的号码
 
 */
- (void)getMessage{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/GMessage?token=%@&ItemId=%@&Phone=%@",[BWSingleton sharedInstance].token,itemID,currentPhone];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
}


/*释放全部号码
 */
- (void)releaseAllPhone{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/ReleaseAllPhone?token=%@",[BWSingleton sharedInstance].token];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
}

/*添加黑名单
 */
- (void)addBlackList{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/AddBlack?token=%@&phoneList=%@-%@;",[BWSingleton sharedInstance].token,itemID,currentPhone];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
