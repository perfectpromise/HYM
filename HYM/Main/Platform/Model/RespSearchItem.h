//
//  RespSearchItem.h
//  OneKeySearch
//
//  Created by WS on 2017/11/7.
//  Copyright © 2017年 WS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RespItem : NSObject<NSCoding>

@end

@interface ImageItem : RespItem

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;            //外部链接
@end


@interface RespSearchURLItem : RespItem

@property (nonatomic, strong) NSArray *result;

@end
