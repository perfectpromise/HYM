//
//  NSString+DES.h
//  BeadWallet
//
//  Created by LWF on 17/7/21.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DES.h"

@interface NSString (DES)

+(NSString *)desEncryption:(NSString *)str;

@end
