#import "PopupViewHelper.h"
#import "RectHelper.h"
#import "UIView+Frame.h"
#import "UIView+Additions.h"


/**
 *  UIAlertView
 */
@interface PopAlertView : UIAlertView <UIAlertViewDelegate>

@property (copy) PopupViewActionBlock actionBlock;
@property (copy) PopupViewActionBlock dismissedBlock;

@end

@implementation PopAlertView

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PopAlertView* popupView = (PopAlertView*)alertView;
    if (popupView.actionBlock) popupView.actionBlock(popupView, buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    PopAlertView* popupView = (PopAlertView*)alertView;
    if (popupView.dismissedBlock) popupView.dismissedBlock(popupView, buttonIndex);
}

@end




/**
 *  UIActionSheet
 */
@interface PopActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (copy) PopupViewActionBlock actionBlock;

@end

@implementation PopActionSheet

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PopActionSheet* popupView = (PopActionSheet*)actionSheet;
    if (popupView.actionBlock) popupView.actionBlock(popupView, buttonIndex);
}

@end


/**
 * Overlay View
 */
@interface OverlayView : UIControl

@property (copy) void(^didDidTapActionBlock)(OverlayView* overlayView);

@end

@implementation OverlayView

- (id)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(didDidTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) didDidTapAction
{
    if(self.didDidTapActionBlock) self.didDidTapActionBlock(self);
}

@end

/**
 *  PopupViewHelper
 */
@implementation PopupViewHelper

+(UIAlertView*) popAlert: (NSString*)title message:(NSString*)message style:(UIAlertViewStyle)style actionBlock:(PopupViewActionBlock)actionBlock dismissBlock:(PopupViewActionBlock)dismissBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{
    PopAlertView* popupView = [[PopAlertView alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.dismissedBlock = dismissBlock;
    popupView.delegate = popupView;
    popupView.message = message;
    popupView.title = title;
    popupView.alertViewStyle = style;
    
    
    if (button) [popupView addButtonWithTitle: button];
    
    // button not in list , list is for ...
    // button just indicates where the compiler needs to go in memory to find the start of args
    // take a look at http://www.numbergrinder.com/2008/12/variable-arguments-varargs-in-objective-c/
    va_list list;
    va_start(list, button);
    
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [popupView addButtonWithTitle: nextButton];
    }
    
    va_end(list);
    
    
    [popupView show];
    
    return popupView;
}


+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttons:(NSString*)button, ... NS_REQUIRES_NIL_TERMINATION
{

    NSMutableArray* buttonTitles = [NSMutableArray array];
    if (button) [buttonTitles addObject: button];
    
    va_list list ;
    va_start(list, button);
    NSString* nextButton = nil;
    while((nextButton = va_arg(list, NSString*))){
        [buttonTitles addObject: nextButton];
    }
    va_end(list);
    
    return [self popSheet:title inView:inView actionBlock:actionBlock buttonTitles:buttonTitles];
}

+(UIActionSheet*) popSheet: (NSString*)title inView:(UIView*)inView actionBlock:(PopupViewActionBlock)actionBlock buttonTitles:(NSArray*)buttonTitles
{
    PopActionSheet* popupView = [[PopActionSheet alloc] init];
    popupView.actionBlock = actionBlock;
    popupView.delegate = popupView;
    popupView.title = title;
    
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString* buttonTitle = buttonTitles[i];
        [popupView addButtonWithTitle: buttonTitle];
    }
    
    if (!inView) inView = [UIApplication sharedApplication].keyWindow.subviews.firstObject;
	[popupView showInView:inView];
    
    return popupView;
}

// ------------------------------------------

static NSMutableArray* currentPopingViews = nil;
+(void) popView: (UIView*)view willDissmiss:(void(^)(UIView* view))block
{
    [self popView: view inView:nil tapOverlayAction:nil willDissmiss:block];
}

+(void) popView: (UIView*)view inView:(UIView*)inView tapOverlayAction:(void(^)(UIControl* control))tapOverlayAction willDissmiss:(void(^)(UIView* view))block
{
    // add to overlay
    OverlayView* overlayView = [[OverlayView alloc] init];
    overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    
    CGSize size = [RectHelper getScreenSizeByControllerOrientation];
    overlayView.frame = CGRectMake(0, 0, size.width, size.height);
    
    overlayView.didDidTapActionBlock = ^void(OverlayView* view) {
        if (tapOverlayAction) {
            tapOverlayAction(view);
        } else {
            [self dissmissCurrentPopView];
        }
    };
    [overlayView addSubview: view];
    
    // if inView nil
    if (! inView) inView = [UIView getTopView];
    
    [inView addSubview: overlayView];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.type = kCATransitionFade;
    [[inView layer] addAnimation:animation forKey: nil];
    
    // add to array
    if (!currentPopingViews) {
        currentPopingViews = [NSMutableArray array];
    }
    if (block) {
        [currentPopingViews insertObject: block atIndex:0];
    } else {
        [currentPopingViews insertObject: [NSNull null] atIndex:0];
    }
    [currentPopingViews insertObject:overlayView atIndex:0];
    view.center = [view.superview middlePoint];
}

+(void) dissmissCurrentPopView
{
    UIView* overlayView = [currentPopingViews firstObject];
    if (overlayView) {
        [currentPopingViews removeObjectAtIndex: 0];
        id block = [currentPopingViews firstObject];
        if (block) {
            [currentPopingViews removeObjectAtIndex: 0];
            if (block != [NSNull null]) {
                void(^willDissmissBlock)(UIView* view) = block;
                willDissmissBlock([overlayView.subviews lastObject]);
            }
        }
    }
    [UIView animateWithDuration:0.3 animations:^{overlayView.alpha = 0.0;} completion:^(BOOL finished){ [overlayView removeFromSuperview]; }];
}

+(BOOL) isCurrentPopingView
{
    return currentPopingViews.count >= 2;
}





#define DROPDOWN_OVERLAYVIEW_TAG 2021
+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView
{
    [self dropDownView: view belowView:belowView overlayFrame:[UIView getTopView].bounds];
}

+(void) dropDownView: (UIView*)view belowView:(UIView*)belowView overlayFrame:(CGRect)overlayFrame
{
    [self dissmissCurrentDropDownView];
    
    OverlayView* overlayView = [[OverlayView alloc] init];
    overlayView.backgroundColor = [UIColor clearColor];
    overlayView.didDidTapActionBlock = ^void(OverlayView* view) {
        [self dissmissCurrentDropDownView];
    };
    
    overlayView.frame = overlayFrame;
    UIView* topView = [UIView getTopView];
    [topView addSubview:overlayView];
    
    [view setOrigin: [belowView convertPoint: (CGPoint){0, belowView.frame.size.height} toView:overlayView]];
    
    overlayView.tag = DROPDOWN_OVERLAYVIEW_TAG;
    [overlayView addSubview: view];
}

+(void) dissmissCurrentDropDownView
{
    UIView* topView = [UIView getTopView];
    UIView* overlayView = [topView viewWithTag: DROPDOWN_OVERLAYVIEW_TAG];
    [overlayView removeFromSuperview];
}





@end
