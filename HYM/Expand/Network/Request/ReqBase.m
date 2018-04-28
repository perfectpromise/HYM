//
//  ReqBase.m
//  DreamWallet
//
//  Created by song on 17/7/20.
//  Copyright © 2017年 王松. All rights reserved.
//

#import "ReqBase.h"
#import "NSObject+YYModel.h"
#import "AFNetworkClient.h"

#import "NetworkCache.h"
#import "NSString+MD5.h"

@implementation ReqBase

-(id)init
{
    self = [super init];
    if (self) {
        mIsCache = NO;
        mIsReadFromCache = YES;
    }
    return self;
}

-(NSString *)baseURL
{
    return nil;
}

-(NSString *)requestURL
{
    return nil;
}

-(Class)responseClass
{
    return [RespBase class];
}

#define kUserDefaultsCookie @"userDefaultCookie"

//第三方数据请求
-(AFHTTPSessionManager *)networkClient{
    NSString *urlStr = [self baseURL];
    
    if ( [UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlStr] invertedSet];
        [urlStr stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
    }else{
        [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    AFHTTPSessionManager *_sharedClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    
    // 设置超时时间
    [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _sharedClient.requestSerializer.timeoutInterval = 15.f;
    [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return _sharedClient;
}

-(NSURLSessionDataTask*)postThirdRequest:(void(^)(RespBase* response,NSError* error))block{
    
    return [[self networkClient] POST:[self requestURL]
                           parameters:[self yy_modelToJSONObject]
                             progress:^(NSProgress *uploadProgress){
                             }
                              success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                  if ([JSON isKindOfClass:[NSArray class]])
                                  {
                                      NSArray *respArr = JSON;
                                      
                                      if (respArr.count > 0)
                                      {
                                          RespBase *response = [[self responseClass] yy_modelWithDictionary:respArr[0]];
                                          
                                          if (block) {
                                              block(response, nil);
                                          }
                                      }else
                                      {
                                          if (block) {
                                              block(nil, nil);
                                          }
                                      }
                                      
                                  }else
                                  {
                                      NSDictionary *respDict = JSON;
                                      
                                      RespBase *response = [[self responseClass] yy_modelWithDictionary:respDict];
                                      
                                      if (block) {
                                          block(response, nil);
                                      }
                                  }
                                  
                              }
            
                              failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                  
                                  NSLog(@"%@",error);
                                  if (block) {
                                      block(nil, error);
                                  }
                              }];
}

-(NSURLSessionDataTask*)getThirdRequest:(void(^)(RespBase* response,NSError* error))block{
    
    return [[self networkClient] GET:[self requestURL]
                          parameters:[self yy_modelToJSONObject]
                            progress:^(NSProgress *uploadProgress){
                                NSLog(@"");
                            }
                             success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                 
                                 NSLog(@"req = %@",[self yy_modelToJSONString]);
                                 
                                 if ([JSON isKindOfClass:[NSArray class]])
                                 {
                                     NSArray *respArr = JSON;
                                     
                                     if (respArr.count > 0)
                                     {
                                         RespBase *response = [[self responseClass] yy_modelWithDictionary:respArr[0]];
                                         
                                         if (block) {
                                             block(response, nil);
                                         }
                                     }else
                                     {
                                         if (block) {
                                             block(nil, nil);
                                         }
                                     }
                                     
                                 }else
                                 {
                                     NSDictionary *respDict = JSON;
                                     
                                     
                                     RespBase *response = [[self responseClass] yy_modelWithDictionary:respDict];
                                     
                                     if (block) {
                                         block(response, nil);
                                     }
                                 }
                                 
                             }
                             failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                 
                                 NSLog(@"%@",error);
                                 if (block) {
                                     block(nil, error);
                                 }
                             }];
}
//追梦宝数据请求
-(NSURLSessionDataTask *)postRequest:(void (^)(RespBase *, NSError *))block
{
    NSString *data2String = [self yy_modelToJSONString];
    NSString *filename = [[data2String MD5Hash] stringByAppendingString:[self requestURL]];
    if (mIsCache && mIsReadFromCache) {
        //判断是否过期
        if (![NetworkCache isJsonStaleWithName:filename]) {
            RespBase *jsonResp = [NetworkCache getJsonCacheWithName:filename];
            if (jsonResp) {
                if (block) {
                    block(jsonResp,nil);
                    return nil;
                }
            }
        }
        
    }
    
    NSString *valueString = [BWSingleton sharedInstance].token;
    if ([GW_TextHelper checkTextContent:valueString]) {
        self.token = valueString;
        [[AFNetworkClient sharedClient].requestSerializer setValue:self.token forHTTPHeaderField:@"token"];

    }
    
    return [[AFNetworkClient sharedClient] POST:[self requestURL]
                                     parameters:[self yy_modelToJSONObject]
                                       progress:^(NSProgress *uploadProgress){
                                           BWLog(@"");
                                       }
                                        success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                            BWLog(@"req = %@",[self yy_modelToJSONString]);
                                             if ([JSON isKindOfClass:[NSArray class]])
                                             {
                                                 NSArray *respArr = JSON;
                                                 
                                                 BWLog(@"response = %@",respArr);
                                                 if (respArr.count > 0)
                                                 {
                                                     RespBase *response = [[self responseClass] yy_modelWithDictionary:respArr[0]];
                                                     if (mIsCache) {
                                                         [NetworkCache cacheJsonResponse:response withName:filename];
                                                     }
                                                     
                                                     if (block) {
                                                         block(response, nil);
                                                     }
                                                 }else
                                                 {
                                                     if (block) {
                                                         block(nil, nil);
                                                     }
                                                 }
                                                 
                                             }else
                                             {
                                                 NSDictionary *respDict = JSON;
                                                 
                                                 BWLog(@"response = %@",respDict);
                                                 
                                                 RespBase *response = [[self responseClass] yy_modelWithDictionary:respDict];
                                                 if (mIsCache) {
                                                     [NetworkCache cacheJsonResponse:response withName:filename];
                                                 }
                                                 
                                                 if (block) {
                                                     block(response, nil);
                                                 }
                                             }
                                             
                                        }

                                        failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                         BWLog(@"req = %@",[self yy_modelToJSONString]);

                                         BWLog(@"%@",error);
                                         if (block) {
                                             block(nil, error);
                                         }
                                        }];
}

-(NSURLSessionDataTask*)getRequest:(void(^)(RespBase* response,NSError* error))block{

    NSString *data2String = [self yy_modelToJSONString];
    NSString *filename = [[data2String MD5Hash] stringByAppendingString:[self requestURL]];
    if (mIsCache && mIsReadFromCache) {
        //判断是否过期
        if (![NetworkCache isJsonStaleWithName:filename]) {
            RespBase *jsonResp = [NetworkCache getJsonCacheWithName:filename];
            if (jsonResp) {
                if (block) {
                    block(jsonResp,nil);
                    return nil;
                }
            }
        }
        
    }
    
    NSString *valueString = [BWSingleton sharedInstance].token;
    if ([GW_TextHelper checkTextContent:valueString]) {
        self.token = valueString;
        [[AFNetworkClient sharedClient].requestSerializer setValue:self.token forHTTPHeaderField:@"token"];

    }
    
    return [[AFNetworkClient sharedClient] GET:[self requestURL]
                                     parameters:[self yy_modelToJSONObject]
                                       progress:^(NSProgress *uploadProgress){
                                           BWLog(@"");
                                       }
                                        success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                            
                                            BWLog(@"req = %@",[self yy_modelToJSONString]);

                                            if ([JSON isKindOfClass:[NSArray class]])
                                            {
                                                NSArray *respArr = JSON;
                                                
                                                BWLog(@"response = %@",respArr);
                                                if (respArr.count > 0)
                                                {
                                                    RespBase *response = [[self responseClass] yy_modelWithDictionary:respArr[0]];
                                                    if (mIsCache) {
                                                        [NetworkCache cacheJsonResponse:response withName:filename];
                                                    }
                                                    
                                                    if (block) {
                                                        block(response, nil);
                                                    }
                                                }else
                                                {
                                                    if (block) {
                                                        block(nil, nil);
                                                    }
                                                }
                                                
                                            }else
                                            {
                                                NSDictionary *respDict = JSON;
                                                
                                                BWLog(@"response = %@",respDict);
                                                
                                                RespBase *response = [[self responseClass] yy_modelWithDictionary:respDict];
                                                if (mIsCache) {
                                                    [NetworkCache cacheJsonResponse:response withName:filename];
                                                }
                                                
                                                if (block) {
                                                    block(response, nil);
                                                }
                                            }
                                            
                                        }
                                        failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                            
                                            BWLog(@"%@",error);
                                            if (block) {
                                                block(nil, error);
                                            }
                                        }];
}

-(NSURLSessionDataTask*)uploadTask:(NSData *)fileData withRequest:(void(^)(RespBase* response,NSError* error))block{
    
    NSString *data2String = [self yy_modelToJSONString];
    NSString *filename = [[data2String MD5Hash] stringByAppendingString:[self requestURL]];
    if (mIsCache && mIsReadFromCache) {
        //判断是否过期
        if (![NetworkCache isJsonStaleWithName:filename]) {
            RespBase *jsonResp = [NetworkCache getJsonCacheWithName:filename];
            if (jsonResp) {
                if (block) {
                    block(jsonResp,nil);
                }
            }
        }
        
    }
    
    NSString *valueString = [BWSingleton sharedInstance].token;
    if ([GW_TextHelper checkTextContent:valueString]) {
        self.token = valueString;
        [[AFNetworkClient sharedClient].requestSerializer setValue:self.token forHTTPHeaderField:@"token"];
        
    }


    return [[AFNetworkClient sharedClient] POST:[self requestURL]
                                     parameters:nil
                      constructingBodyWithBlock:^void(id<AFMultipartFormData>formData){
                          
                              // 设置上传图片的名字
                              NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                              formatter.dateFormat = @"yyyyMMddHHmmss";
                              NSString *str = [formatter stringFromDate:[NSDate date]];
                              NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                          
                              [formData appendPartWithFileData:fileData
                              name:@"image"
                              fileName:fileName
                              mimeType:@"image/png"];
                          
                           }
                                       progress:nil
                                        success:^(NSURLSessionDataTask * __unused task, id JSON) {
                                            BWLog(@"req = %@",[self yy_modelToJSONString]);
                                            if ([JSON isKindOfClass:[NSArray class]])
                                            {
                                                NSArray *respArr = JSON;
                                                
                                                BWLog(@"response = %@",respArr);
                                                if (respArr.count > 0)
                                                {
                                                    RespBase *response = [[self responseClass] yy_modelWithDictionary:respArr[0]];
                                                    if (mIsCache) {
                                                        [NetworkCache cacheJsonResponse:response withName:filename];
                                                    }
                                                    
                                                    if (block) {
                                                        block(response, nil);
                                                    }
                                                }else
                                                {
                                                    if (block) {
                                                        block(nil, nil);
                                                    }
                                                }
                                                
                                            }else
                                            {
                                                NSDictionary *respDict = JSON;
                                                
                                                BWLog(@"response = %@",respDict);
                                                
                                                RespBase *response = [[self responseClass] yy_modelWithDictionary:respDict];
                                                if (mIsCache) {
                                                    [NetworkCache cacheJsonResponse:response withName:filename];
                                                }
                                                
                                                if (block) {
                                                    block(response, nil);
                                                }
                                            }
                                            
                                        }
                                        failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                                            BWLog(@"req = %@",[self yy_modelToJSONString]);
                                            
                                            BWLog(@"%@",error);
                                            if (block) {
                                                block(nil, error);
                                            }
                                        }];
}

-(void)setCacheFlag:(BOOL)isCache
{
    mIsCache = isCache;
}

-(void)setReadFromCacheFlag:(BOOL)isReadFromCache
{
    mIsReadFromCache = isReadFromCache;
}

@end
