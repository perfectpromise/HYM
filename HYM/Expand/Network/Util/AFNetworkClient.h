//
//  AFNetworkClient.h
//  DreamWallet
//
//  Created by song on 17/7/20.
//  Copyright © 2017年 王松. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"

@interface AFNetworkClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
