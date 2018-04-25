//
//  RespSearchItem.m
//  OneKeySearch
//
//  Created by WS on 2017/11/7.
//  Copyright © 2017年 WS. All rights reserved.
//

#import "RespSearchItem.h"

@implementation RespItem
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar var = vars[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    for (int i = 0;i < outCount; i++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}
@end

@implementation ImageItem

@end

@implementation RespSearchURLItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [ImageItem class]};
}

@end
