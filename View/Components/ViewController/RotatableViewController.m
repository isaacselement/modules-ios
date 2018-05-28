#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

#pragma mark - Override UIViewController Methods

//------------------------ Rotate Information Check Begin
//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSLog(@"willRotateToInterfaceOrientation %d, Width x Height (%f x %f)",UIInterfaceOrientationIsPortrait(toInterfaceOrientation),self.view.bounds.size.width, self.view.bounds.size.height);
//}
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    NSLog(@"didRotateFromInterfaceOrientation  %d, Width x Height (%f x %f)",UIInterfaceOrientationIsPortrait(self.interfaceOrientation),self.view.bounds.size.width, self.view.bounds.size.height);
//}

//- (void)viewWillLayoutSubviews {
//}
//- (void)viewDidLayoutSubviews {
//}
//------------------------ Rotate Information Check End



//**************Rotate Needed Begin

// for ios5.0 , 6.0 deprecated
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait ;
}

// for ios6.0 supported
-(BOOL) shouldAutorotate {
    return YES;
}

//**************Rotate Needed End


@end
