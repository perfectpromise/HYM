//
//  AFNetworkClient.m
//  DreamWallet
//
//  Created by song on 17/7/20.
//  Copyright © 2017年 王松. All rights reserved.
//

#import "AFNetworkClient.h"

@implementation AFNetworkClient

+ (instancetype)sharedClient {
    static AFNetworkClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSString *urlStr = [NSString stringWithFormat:@"http://%@/",ServerIP];

        
        if ( [UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
            
            NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlStr] invertedSet];
            [urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            
        }else{
            [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        _sharedClient = [[AFNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];

        // 设置超时时间
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 15.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];

    });
    
    return _sharedClient;
}

@end
