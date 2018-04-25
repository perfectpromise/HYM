/*!
 控制器的基类
 @discussion 封装了添加导航栏右侧按钮事件、增加下拉刷新和上提加载、点击统计接口
 */

#import <UIKit/UIKit.h>
#import "MSBaseTableView.h"
#import "MSBaseScrollView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BaseViewController : UIViewController<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/*!
 导航栏右侧按钮
 @param imgName 按钮背景图片
 @param titleStr 按钮标题
 */
- (void)setupRightMenuButton:(NSString *)imgName
                       title:(NSString *)titleStr;


- (void)alertWithTitle:(NSString *)title
               message:(NSString *)msg
          cancelButton:(NSString *)cancelButton
              okButton:(NSString *)okButton
  clickedButtonAtIndex:(void(^)(NSInteger index))block;


@end

