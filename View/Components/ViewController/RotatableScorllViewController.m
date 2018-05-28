#import "RotatableScorllViewController.h"

@implementation RotatableScorllViewController

#pragma mark - UIViewController Methods
-(void)loadView {
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [[UIScreen mainScreen] bounds];
    self.view = scrollView;
}

@end
