//
//  GW_TextHelper.h
//  Gateway
//
//  Created by shi liangbin on 13-3-7.
//  Copyright (c) 2013年 Archermind. All rights reserved.
//  文字内容检测

#import <Foundation/Foundation.h>

@interface GW_TextHelper : NSObject

+ (BOOL)checkTextContent:(NSString *)txt;           // 检验内容是否为空，返回YES为非空，NO为空

+ (NSString *)getCurrentTime;                       // 获取当前时间yyyy-MM-dd

+ (NSString *)getCurrentDateAndTime;                // 获取当前时间yyyyMMddHHmmss

+ (BOOL)validateString:(NSString *)string;          //判断是否包含特殊字符,YES表示没有

void dispatchTimer(id target, double timeInterval,void (^handler)(dispatch_source_t timer));

@end
