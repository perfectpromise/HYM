//
//  LKAccountModel.h
//  DreamWallet
//
//  Created by  song on 2017/12/8.
//

#import <Foundation/Foundation.h>

@interface LKAccountModel : NSObject

@property (nonatomic, strong) NSString *type;   //类型
@property (nonatomic, strong) NSString *money;  //金额
@property (nonatomic, assign) NSInteger year;   //年
@property (nonatomic, assign) NSInteger month;  //月
@property (nonatomic, assign) NSInteger day;    //日
@property (nonatomic, strong) NSString *weekday;    //星期
@property (nonatomic, strong) NSString *mark;   //备注
@property (nonatomic, strong) NSString *uniqueid;   //唯一标识

@end
