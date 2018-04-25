/*!
 继承自UIScrollView，项目中所有UISCrollView继承该类
 @discussion 解决UIScrollView中UIButton点击事件延迟问题
 */

#import <UIKit/UIKit.h>

@interface MSBaseScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end
