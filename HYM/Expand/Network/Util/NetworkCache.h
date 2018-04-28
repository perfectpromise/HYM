//
//  NetworkCache.h
//  MSBCooperate
//
//  Created by xtxk on 15/7/17.
//  Copyright (c) 2015年 xtxk1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RespBase.h"

@interface NetworkCache : NSObject

+(void)clearCache;
+(void)cacheJsonResponse:(RespBase*)json withName:(NSString*)fileName;
+(RespBase*)getJsonCacheWithName:(NSString*)filename;
+(BOOL)isJsonStaleWithName:(NSString*)filename;  //是否过期

@end
