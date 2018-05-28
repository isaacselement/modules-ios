#import "WebViewProgressView.h"
#import "WebViewProgressHandler.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebViewProgressView
{
    NSTimeInterval barAnimationDuration;
    NSTimeInterval fadeAnimationDuration;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        barAnimationDuration = 0.27f;
        fadeAnimationDuration = 0.27f;

        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0] CGColor];
    }
    return self;
}


-(void)setProgress:(float)progress
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration: isGrowing ? barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.size.width = progress * self.superview.bounds.size.width;;
        self.frame = frame;
    } completion:nil];
    
    if (progress == 1.0f) {
        [UIView animateWithDuration: fadeAnimationDuration delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.frame;
            frame.size.width = 0;
            self.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:fadeAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:nil];
    }
}

@end
