#import <UIKit/UIKit.h>

@interface UIView (Additions)


- (UIViewController *)viewController;

#pragma mark - About View Hierarchy
+(UIView*) getTopView;
+(UIViewController*) getTopViewController;
+(UIView*) getRootView;
+(UIViewController*) getRootViewController;

#pragma mark - 

- (UIViewController *) firstAvailableUIViewController;

@end


@interface UIView (Subview)

-(NSMutableArray*) getSubviewsWithClazz:(Class)clazz ;
-(UIView*) getOnlyOneSubviewWithClazz:(Class)clazz ;

@end
