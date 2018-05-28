#import "ViewHelper.h"
#import <QuartzCore/QuartzCore.h>

#import "KeyValueHelper.h"



@implementation ViewHelper




#pragma mark - Public Methods

+(void) logViewsRecursive: (UIView*)view
{
    NSLog(@"%@", view);
    for (UIView* subview in view.subviews) {
        [ViewHelper logViewsRecursive: subview];
    }
}



/**
 * 
 * Call the view already has a super view
 *
 * This method just make you know that , if you want radius(cause you have to set clipsToBounds/setMasksToBounds YES) and shadow exist at the same time
 * For the setMasksToBounds and clipsToBounds sake , they cannot exist at the same time 
 * So , you should create a shadow view to show the shadow for your view(cornerRadius and clipsToBounds/masksToBounds)
 *
 * the view should have frame first.
 */
+ (void) setShadowWithCorner: (UIView*)view config:(NSDictionary*)config
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];
    
    // set corner
    // CornerRadius
    id cornerRadiusObj = config[@"cornerRadius"];
    cornerRadiusObj = cornerRadiusObj ? cornerRadiusObj : @(10);
    [dictionary setObject: cornerRadiusObj forKey:@"cornerRadius"];
    // MasksToBounds
    id maskToBoundsObj = config[@"masksToBounds"];
    maskToBoundsObj = maskToBoundsObj ? maskToBoundsObj : @(YES);
    [dictionary setObject:maskToBoundsObj forKey:@"masksToBounds"];
    [[KeyValueHelper sharedInstance] setValues:config object:view.layer];
    
    [dictionary removeAllObjects];
    
    // set shadow
    // ShadowOpacity
    id shadowOpacityObj = config[@"shadowOpacity"];
    shadowOpacityObj = shadowOpacityObj ? shadowOpacityObj : @(1.0);
    [dictionary setObject: shadowOpacityObj forKey:@"shadowOpacity"];
    // ShadowOpacity
    id shadowRadiusObj = config[@"shadowRadius"];
    shadowRadiusObj = shadowRadiusObj ? shadowRadiusObj : @(5.0);
    [dictionary setObject: shadowRadiusObj forKey:@"shadowRadius"];
    [[KeyValueHelper sharedInstance] setValues:dictionary object:shadowView.layer];
    
    // re add
    UIView *superView = view.superview;
    [view removeFromSuperview];
    view.frame = view.bounds;
    [shadowView addSubview:view];
    [superView addSubview:shadowView];
}

/**
 *   Sort the view.subviews index by subview.frame.origin.x coordinate
 */
+(void) sortedSubviewsByXCoordinate: (UIView*)containerView
{
    // sort subviews
    NSMutableArray* views = [NSMutableArray arrayWithArray: containerView.subviews];
    [self sorteByXCoordinate: views];
    
    // reset index
    for (int i = 0; i < views.count; i++) {
        UIView* view = views[i];
        [containerView insertSubview: view atIndex:i];
    }
}

+(void) sorteByXCoordinate: (NSMutableArray*)views
{
    [views sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float view1X = view1.frame.origin.x;
        float view2X = view2.frame.origin.x;
        return [[NSNumber numberWithFloat: view1X] compare: [NSNumber numberWithFloat: view2X]];
    }];
}
+(void) sorteByYCoordinate: (NSMutableArray*)views
{
    [views sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float view1Y = view1.frame.origin.y;
        float view2Y = view2.frame.origin.y;
        return [[NSNumber numberWithFloat: view1Y] compare: [NSNumber numberWithFloat: view2Y]];
    }];
}

/**
 *  make the fist responser(u don't know who) loose its focus
 *
 *  @param containerView the view visible
 */
+(void) resignFirstResponserOnView: (UIView*)containerView
{
    // just a trick , make the fist responser(u don't know who) loose its focus
    UITextField* invisibleTextField = [[UITextField alloc] initWithFrame: CGRectZero];
    invisibleTextField.hidden = YES;
    [containerView addSubview: invisibleTextField];
    [invisibleTextField becomeFirstResponder];
    [invisibleTextField resignFirstResponder];
    [invisibleTextField removeFromSuperview];
}


+(void) tableViewRowInsert:(UITableView*)tableView insertIndexPaths:(NSArray*)insertIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion
{
    tableView.bounces = NO;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         // Perform insertRowsAtIndexPaths here
                         [tableView beginUpdates];
                         [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:animation];
                         [tableView endUpdates];
                     }
                     completion:^(BOOL finished) {
                         // This will be called when the animation is complete
                         tableView.bounces = YES;
                         if (completion) completion(finished);
                     }];
}

+(void) tableViewRowDelete:(UITableView*)tableView deleteIndexPaths:(NSArray*)deleteIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion
{
    tableView.bounces = NO;
    [UIView animateWithDuration:0.5
                     animations:^(){
                         // Perform insertRowsAtIndexPaths here
                         [tableView beginUpdates];
                         [tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:animation];
                         [tableView endUpdates];
                     }
                     completion:^(BOOL finished) {
                         // This will be called when the animation is complete
                         tableView.bounces = YES;
                         if (completion) completion(finished);
                     }];
}

#pragma mark - About Width

+(void) resizeSizeBySubviewsOccupiedSize: (UIView*)view
{
    [self resizeWidthBySubviewsOccupiedWidth: view];
    [self resizeHeightBySubviewsOccupiedHeight: view];
}

// i.e. when you chang localize text in label
// the width of the label change, you can invoke this to fix, resize it recursive
+(void) resizeWidthBySubviewsOccupiedWidth: (UIView*)view
{
    [self resizeLengthBySubviewsOccupied:view isForWidth:YES];
}

+(void) resizeHeightBySubviewsOccupiedHeight: (UIView*)view
{
    [self resizeLengthBySubviewsOccupied:view isForWidth:NO];
}

+(void) resizeLengthBySubviewsOccupied: (UIView*)view isForWidth:(BOOL)isForWidth
{
    for (UIView* subview in view.subviews) {
        [ViewHelper resizeLengthBySubviewsOccupied: subview isForWidth:isForWidth];
    }
    
    CGFloat length = [ViewHelper getSubViewsOccupiedLength: view isForWidth:isForWidth];
    
    if (length == 0) return;
    
    CGRect rect = view.frame;
    if (isForWidth) {
        rect.size.width = length;
    } else {
        rect.size.height = length;
    }
    view.frame = rect;
}

+(CGFloat) getSubViewsOccupiedLongestWidth: (UIView*)view
{
    return [self getSubViewsOccupiedLength: view isForWidth:YES];
}

+(CGFloat) getSubViewsOccupiedLongestHeight: (UIView*)view
{
    return [self getSubViewsOccupiedLength: view isForWidth:NO];
}

+(CGFloat) getSubViewsOccupiedLength: (UIView*)view isForWidth:(BOOL)isForWidth
{
    return [self getSubViewsOccupiedLength: view origin:0 isForWidth:isForWidth];
}

+(CGFloat) getSubViewsOccupiedLength: (UIView*)view origin: (CGFloat)origin isForWidth:(BOOL)isForWidth
{
    CGFloat result = 0.0f;
    for (UIView* subview in view.subviews) {
        CGFloat limit = 0.0f;
        CGRect rect = subview.frame;
        if (subview.subviews.count != 0) {
            CGFloat ruler = (isForWidth ? CGRectGetMinX(rect) : CGRectGetMinY(rect)) + origin;
            limit = [self getSubViewsOccupiedLength: subview origin: ruler isForWidth:isForWidth];
        } else {
            limit = (isForWidth ? CGRectGetMaxX(rect) : CGRectGetMaxY(rect)) + origin;
        }
        result = result < limit ? limit : result;
    }
    return result;
}



#pragma mark - About Subviews
+(void) iterateSubView: (UIView*)superView handler:(BOOL (^)(id subView))handler {
    for (UIView* subView in [superView subviews]) {
        if (handler(subView)) return;
        [ViewHelper iterateSubView: subView handler:handler];
    }
}

+(void) iterateSubView: (UIView*)superView class:(Class)clazz handler:(BOOL (^)(id subView))handler {
    [self iterateSubView: superView handler:^BOOL(id subView) {
        if ([subView isKindOfClass:clazz]) {
            return handler(subView);
        }
        return NO;
    }];
}

+(void) iterateSubView: (UIView*)superView classes:(NSArray*)clazzes handler:(BOOL (^)(id subView))handler {
    [self iterateSubView: superView handler:^BOOL(id subView) {
        // check if in clazzes
        BOOL flag = NO;
        for (Class clazz in clazzes) {
            flag = [subView isKindOfClass: clazz];
            if (flag) break;
        }
        
        // yes
        if (flag) {
            return handler(subView);
        }
        return NO;
    }];
}



+(void) iterateSuperView: (UIView*)subView handler:(BOOL (^)(id superView))handler
{
    UIView* superView = subView.superview;
    while (superView) {
        if (handler(superView)) return;
        superView = superView.superview;
    }
}


+(BOOL) isSuperview: (UIView*)superView forView:(UIView*)view
{
    BOOL result = NO;
    
    UIView* superview = view.superview;
    while (superview) {
        superview = superview.superview;
        
        if (superview == superView) {
            result = YES;
            break;
        }
    }
    
    return result;
}


+(UIView*) getSuperView: (UIView*)view clazz:(Class)clazz
{
    UIView* superview = view.superview;
    while (superview && ![superview isKindOfClass:clazz]) {
        superview = superview.superview;
    }
    return superview;
}

+(UIView*) getSubview: (UIView*)view clazz:(Class)clazz
{
    // get the result view
    for (UIView* subview in view.subviews) {
        if ([subview isKindOfClass:clazz]) {
            return subview;
        }
    }
    
    // no return , then we check subivews's subviews
    for (UIView* subview in view.subviews) {
        UIView* resultView = [self getSubview:subview clazz:clazz];
        if (resultView) {
            return resultView;
        }
    }
    
    // return nil
    return nil;
}


#pragma mark -

+(UIActivityIndicatorView*) getIndicatorInView: (UIView*)containerView
{
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[containerView viewWithTag: 20022];
    if (! indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.tag = 20022;
        
        indicator.color = [UIColor blackColor];
        [containerView addSubview: indicator];
        CGRect rect = containerView.frame;
        indicator.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    }
    [containerView bringSubviewToFront: indicator];
    return indicator;
}


#pragma mark -

+ (UIImage *)imageFromView: (UIView*) view
{
    return [self imageFromView: view atRect:CGRectNull];
}

// http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display
+ (UIImage *)imageFromView: (UIView *)view atRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0); // recommended
    if (!CGRectEqualToRect(rect, CGRectNull)) UIRectClip(rect);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];     // recommened
//    [layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromLayer: (CALayer*) layer
{
    return [self imageFromLayer: layer atRect:CGRectNull];
}

+ (UIImage *)imageFromLayer: (CALayer *)layer atRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.opaque, 0.0); // recommended
    if (!CGRectEqualToRect(rect, CGRectNull)) UIRectClip(rect);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];     // recommened
    [layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - 

+(void) printView: (UIView*)view completeHandler:(void(^)(UIPrintInteractionController *controller, BOOL completed, NSError *error))completeHandler
{
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printFormatter = view.viewPrintFormatter;
    UIImage* image = [ViewHelper imageFromView: view];
    [self print: image completeHandler:completeHandler];
}

// content can be UIImage, NSData (i.e data of pdf file) ...
+(void) print: (id)content completeHandler:(void(^)(UIPrintInteractionController *controller, BOOL completed, NSError *error))completeHandler
{
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    printController.showsPageRange = YES;
    printController.printingItem = content;
    [printController presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
        if (completeHandler) {
            completeHandler(printInteractionController, completed, error);
        }
    }];
}


@end


