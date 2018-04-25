//
//  BWSingleton.h
//  BeadWallet
//
//  Created by LWF on 2017/8/24.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWSingleton : NSObject

@property (nonatomic, strong) NSArray *searchKeyArray; //搜索

+ (BWSingleton *)sharedInstance;

@end
