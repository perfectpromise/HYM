//
//  BWSingleton.m
//  BeadWallet
//
//  Created by LWF on 2017/8/24.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "BWSingleton.h"

static BWSingleton *sharedInstance = nil;

@implementation BWSingleton

+ (BWSingleton *)sharedInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
