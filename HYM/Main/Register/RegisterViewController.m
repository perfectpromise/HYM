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
    NSString *currentPhone;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";

    [self createButton];
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

/*获取项目
 
 正确返回:
 项目ID&项目名称&项目价格&项目类型\n项目ID&项目名称&项目价格&项目类型\n...
 
 其中项目类型解释如下：
 1. 表示此项目用于接收验证码
 2. 表示此项目用户发送短信
 3. 表示此项目即可接收验证码，也可以发送短信
 4. 表示可以接受多个验证码
 
 */
- (void)getItems{

    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/uGetItems?token=%@&tp=ut",[BWSingleton sharedInstance].token];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
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
    
    NSString *sid = @"5";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.shjmpt.com:9002/pubApi/GetPhone?ItemId=%@&token=%@",sid,[BWSingleton sharedInstance].token];
    
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
  sid=项目id&phone=取出来的手机号&token=登录时返回的令牌&author=软件作者 用户名(这里是传作者注册时的用户名)。
 
 方法调用返回值示例：
 1.成功返回值：1|短信内容
 2. 失败返回值：0|错误信息
 备注：当返回0|还没有接收到短信，请过3秒再试，请软件主动3秒再重新取短信内容。一般项目的短信在1分钟左右能取到，个别比较慢的也应该在3分钟左右能取到。所以重试间隔3秒的情况下一般循环获取20~60次之间即可。如果一超过60次取不到短信，可以加黑该手机号。
 
 */
- (void)getMessage{
    
    NSString *sid = @"35313";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.eobzz.com/api/do.php?action=getMessage&sid=%@&phone=%@&token=%@",sid,currentPhone,[BWSingleton sharedInstance].token];
    
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
