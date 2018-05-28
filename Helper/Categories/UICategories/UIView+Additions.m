#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController
{
    for (UIView* view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


#pragma mark - About View Hierarchy

+(UIView*) getTopView
{
    return [self getTopViewController].view;
}

+(UIViewController*) getTopViewController
{
    UIViewController* topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    while (topController && ([topController isKindOfClass:[UINavigationController class]] || [topController isKindOfClass:[UITabBarController class]])) {
        if ([topController isKindOfClass:[UINavigationController class]]) {
            topController = ((UINavigationController*)topController).topViewController;
        } else if ([topController isKindOfClass:[UITabBarController class]]) {
            topController = ((UITabBarController*)topController).selectedViewController;
        }
    }
    
    while (topController && ([topController presentedViewController])) topController = [topController presentedViewController];
    return topController;
}

+(UIView*) getRootView
{
    //    return [self getRootViewController].view;     //this way is ok, but do not use this , cause when UIActionSheet show or not complete dismiss animation , the rootViewController = nil !!!
    return [[[[UIApplication sharedApplication] keyWindow] subviews] firstObject];
}

+(UIViewController*) getRootViewController
{
    //Important !!! when UIActionSheet show or not complete dismiss animation , the rootViewController = nil !!! Apple is Kidding the World~!
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}


#pragma mark -

- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end


@implementation UIView (Subview)


-(NSMutableArray*) getSubviewsWithClazz:(Class)clazz {
    NSMutableArray *repository = [NSMutableArray array];
    [self getSubviewsWithClazz:clazz repository:repository];
    return repository;
}

-(void) getSubviewsWithClazz:(Class)clazz repository:(NSMutableArray *)repository {
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:clazz]) {
            [repository addObject:subview];
        }
    }
    for (UIView* subview in self.subviews) {
        [repository addObjectsFromArray:[subview getSubviewsWithClazz:clazz]];
        
    }
}

-(UIView*) getOnlyOneSubviewWithClazz:(Class)clazz {
    // get the result view
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:clazz]) {
            return subview;
        }
    }
    
    // no return , then we check subivews's subviews
    for (UIView* subview in self.subviews) {
        UIView* resultView = [subview getOnlyOneSubviewWithClazz:clazz];
        if (resultView) {
            return resultView;
        }
    }
    
    // return nil
    return nil;
}


@end
