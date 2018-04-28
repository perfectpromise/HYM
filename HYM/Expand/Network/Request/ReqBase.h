//
//  ReqBase.h
//  DreamWallet
//
//  Created by song on 17/7/20.
//  Copyright © 2017年 王松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RespBase.h"

@interface ReqBase : NSObject
{
    BOOL mIsCache;          //默认不用缓存
    BOOL mIsReadFromCache;  //默认从缓存读取，对于下拉刷新等操作则由网络直接获取数据
}

@property (nonatomic, strong) NSString *token;  //Token

-(NSString *)baseURL;
-(NSString*)requestURL;     //子类实现：返回请求的方法名
-(Class)responseClass;      //子类实现：返回数据的类名，例如[RespGetCode class]

//服务器数据
-(NSURLSessionDataTask*)postRequest:(void(^)(RespBase* response,NSError* error))block;
-(NSURLSessionDataTask*)getRequest:(void(^)(RespBase* response,NSError* error))block;
-(NSURLSessionDataTask*)uploadTask:(NSData *)fileData withRequest:(void(^)(RespBase* response,NSError* error))block;

//第三方数据请求
-(NSURLSessionDataTask*)postThirdRequest:(void(^)(RespBase* response,NSError* error))block;
-(NSURLSessionDataTask*)getThirdRequest:(void(^)(RespBase* response,NSError* error))block;

- (void)setCacheFlag:(BOOL)isCache;   //是否将数据缓存,默认不用缓存
- (void)setReadFromCacheFlag:(BOOL)isReadFromCache;   //对于已缓存的数据，是否从缓存读取数据，默认从缓存读取，对于下拉刷新等操作则由网络直接获取数据

@end

