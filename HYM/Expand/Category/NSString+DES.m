//
//  NSString+DES.m
//  BeadWallet
//
//  Created by LWF on 17/7/21.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#import "NSString+DES.h"

@implementation NSString (DES)

+(NSString *)desEncryption:(NSString *)str
{
    NSData * da= [NSData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    Byte *testByte = (Byte *)[da bytes];
    NSString * string = [DES encryptDES:testByte key:DESKeyString useEBCmode:NO];
    return string ;
}

@end
