//
//  GW_TextHelper.m
//  Gateway
//
//  Created by shi liangbin on 13-3-7.
//  Copyright (c) 2013年 Archermind. All rights reserved.
//

#import "GW_TextHelper.h"

@implementation GW_TextHelper

+ (BOOL)checkTextContent:(NSString *)txt {
    
    if ([txt isMemberOfClass:[NSNull class]])
    {
        return NO;
    }
    
    if (txt == nil || [txt isEqualToString:@""] == YES || txt.length == 0) {
        return NO;
    }
    
    NSString *msg = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (msg == nil || [msg isEqualToString:@""] == YES || msg.length == 0) {
        return NO;
    }
    
    return YES;
    
}


+ (NSString *)getCurrentTime {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
    
}

+ (NSString *)getCurrentDateAndTime {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
    
}

+ (BOOL)validateString:(NSString *)string
{
    NSString *nicknameRegex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:string];
}

/**
 开启一个定时器
 
 @param target 定时器持有者
 @param timeInterval 执行间隔时间
 @param handler 重复执行事件
 */
void dispatchTimer(id target, double timeInterval,void (^handler)(dispatch_source_t timer))
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(timeInterval *NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(target) weaktarget  = target;
    dispatch_source_set_event_handler(timer, ^{
        if (!weaktarget)  {
            dispatch_source_cancel(timer);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(timer);
            });
        }
    });
    // 启动定时器
    dispatch_resume(timer);
}
@end
