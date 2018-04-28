//
//  RespBase.h
//  DreamWallet
//
//  Created by song on 17/7/20.
//  Copyright © 2017年 王松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RespItem.h"

@interface RespBase : NSObject<NSCoding>

@property (nonatomic, assign) int code;//000:成功  111:失败  222:内部异常  333:第三方服务异常
@property (nonatomic, strong) NSString *mesg;
@property (nonatomic, strong) NSString *retCode;

@end
