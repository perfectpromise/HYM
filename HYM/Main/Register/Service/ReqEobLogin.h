//
//  ReqEobLogin.h
//  HYM
//
//  Created by  song on 2018/4/28.
//  Copyright © 2018年  song. All rights reserved.
//

#import "ReqBase.h"

@interface ReqEobLogin : ReqBase

@property (nonatomic, strong) NSString *action;  
@property (nonatomic, strong) NSString *name;  //用户名
@property (nonatomic, strong) NSString *password;  //密码


@end
