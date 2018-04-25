
#import "MSBaseScrollView.h"

@implementation MSBaseScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {

    int location_X =40;

    if (gestureRecognizer ==self.panGestureRecognizer) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint point = [pan translationInView:self];
        
        UIGestureRecognizerState state = gestureRecognizer.state;
        
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            
            CGPoint location = [gestureRecognizer locationInView:self];
            
            if (point.x >0 && location.x < location_X &&self.contentOffset.x <=0) {
                return YES;
            }
        }
    }
    
    return NO;
}
@end
