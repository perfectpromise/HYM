//
//  BWDefine.h
//  BeadWallet
//
//  Created by LWF on 17/7/19.
//  Copyright © 2017年 贾富珍. All rights reserved.
//

#ifndef BWDefine_h
#define BWDefine_h

#define ServerIP            @"www.52youzhen.com"

#define DESKeyString        @"meiyouzy"

#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width       //屏幕宽度
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height     //屏幕高度

#define BACK_BTN_FRAME  CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)        //导航栏返回按钮尺寸

#define RGBA(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]        //颜色设置


#define BWString(str)   [GW_TextHelper checkTextContent:str]?str:@""        //nil对象处理
#define NUMBERS       @"0123456789\n"
#define IDNUMBERS     @"0123456789xX\n"
#define PageSize 10

/*判断设备类型*/
#define UI_IS_IPHONE    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE5   (UI_IS_IPHONE && ScreenHeight == 568.0)
#define UI_IS_IPHONE6   (UI_IS_IPHONE && ScreenHeight == 667.0)
#define UI_IS_IPHONE_X  (UI_IS_IPHONE && ScreenHeight == 812.0)

//适配导航iPhoneX
#define NAV_BG              (UI_IS_IPHONE_X ? @"nav_bg_x" : @"nav_bg")
#define STATUS_HEIGHT       (UI_IS_IPHONE_X ? 40 : 20)

//通知
#define TakeCashChangeCard    @"TakeCashChangeCard"
#define TakeCashPayBack       @"TakeCashPayBack"


#endif /* BWDefine_h */
