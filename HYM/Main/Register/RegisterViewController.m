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

//登录
- (void)smLogin{

    NSString *name = @"wust419";
    NSString *password = @"st5201314";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.eobzz.com/api/do.php?action=loginIn&name=%@&password=%@",name,password];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
    NSArray *respArr = [respStr componentsSeparatedByString:@"|"];
    if (respArr.count == 2) {
        if ([respArr[0] isEqualToString:@"1"]) {
            [BWSingleton sharedInstance].token = respArr[1];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            
            [self getUserInfo];
        }else{
            [SVProgressHUD showErrorWithStatus:respArr[1]];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"登录失败"];

    }
}

/*获取个人信息
 1.成功返回：1|余额|等级|批量取号数|用户类型
 2.失败返回：0|错误信息
 */
- (void)getUserInfo{

    NSString *urlStr = [NSString stringWithFormat:@"http://api.eobzz.com/api/do.php?action=getSummary&token=%@",[BWSingleton sharedInstance].token];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
}

/*获取手机号
 可选参数：
 1.phone=你要指定获取的号码,传入号码不正确的情况下,获取新号码.
 2.phoneType=CMCC，CMCC是指移动，UNICOM是指联通，TELECOM是指电信
 3.locationMatching、locationLevel、location三个必须一起使用。用来指定获取某个地区的号码
 例：http://api.eobzz.com/api/do.php?action=getPhone&sid=项目ID&token=登录时返回的令牌&locationMatching=include&locationLevel=p&location=广东
 注：location 参数为中文，必须要编码 上海 编码后为 %E4%B8%8A%E6%B5%B7
 成功返回值：1|手机号
 失败返回值：0|错误信息(系统暂时没有可用号码，请过3秒再重新取号|余额不足|其它错误信息)
 如何一个手机号接收多条短信
 第一条取出短信后，再调用获取手机号指定手机号调用实例：
 http://api.eobzz.com/api/do.php?action=getPhone&sid=项目id&phone=手机号&token=登录时返回的令牌
 */
- (void)getPhone{
    
    NSString *sid = @"35313";
    NSString *urlStr = [NSString stringWithFormat:@"http://api.eobzz.com/api/do.php?action=getPhone&sid=%@&token=%@",sid,[BWSingleton sharedInstance].token];
    
    //获取到服务器的url地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *respStr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    BWLog(@"%@",respStr);
    
    NSArray *respArr = [respStr componentsSeparatedByString:@"|"];
    if (respArr.count == 2) {
        if ([respArr[0] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            currentPhone = respArr[1];
            [self getMessage];
        }
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
