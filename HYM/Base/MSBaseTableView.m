
#import "MSBaseTableView.h"

@implementation MSBaseTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delaysContentTouches = NO;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        for (id view in self.subviews)
        {
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
            {
                if([view isKindOfClass:[UIScrollView class]])
                {
                    UIScrollView *scroll = (UIScrollView *) view;
                    scroll.delaysContentTouches = NO;
                }
                break;
            }
                
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delaysContentTouches = NO;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        for (id view in self.subviews)
        {
            if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"])
            {
                if([view isKindOfClass:[UIScrollView class]])
                {
                    UIScrollView *scroll = (UIScrollView *) view;
                    scroll.delaysContentTouches = NO;
                }
                break;
            }
            
        }

    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
