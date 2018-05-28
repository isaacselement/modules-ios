#import "FrameHelper.h"
#import "FrameTranslater.h"

#import "UIView+Frame.h"
#import "RectHelper.h"


@implementation FrameHelper


/**
 *
 *  Important, Font Size and Transform ,  choose one of them !!!
 *
 *  Both of them are need getFrame:
 *
 *  @param label The label you want to fit
 */

+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas
{
    [FrameTranslater transformView: label];
    label.frame = [FrameTranslater convertCanvasRect: canvas ];
}


#pragma mark -

+(void) setComponentFrame: (NSArray*)values component:(UIView*)view
{
    float x = 0.0, y = 0.0, width = 0.0, height = 0.0;
    bool isIgnoreX = NO, isIgnoreY = NO, isIgnoreWidth = NO, isIgnoreHeight = NO;
    [self paseIgnores: values :&x :&y :&width :&height :&isIgnoreX :&isIgnoreY :&isIgnoreWidth :&isIgnoreHeight];
    
    if ( !isIgnoreX && !isIgnoreY && !isIgnoreWidth && !isIgnoreHeight){
        CGRect canvas = [RectHelper parseRect: values];
        view.frame = [FrameTranslater convertCanvasRect: canvas];
    } else {
        if (!isIgnoreX) [view setOriginX:[FrameTranslater convertCanvasX:x]];
        if (!isIgnoreY) [view setOriginY:[FrameTranslater convertCanvasY:y]];
        if (!isIgnoreWidth) [view setSizeWidth: [FrameTranslater convertCanvasWidth: width]];
        if (!isIgnoreHeight) [view setSizeHeight: [FrameTranslater convertCanvasHeight: height]];
    }
}

+(void) paseIgnores:(NSArray*)values :(float*)x :(float*)y :(float*)width :(float*)height :(bool*)isIgnoreX :(bool*)isIgnoreY :(bool*)isIgnoreWidth :(bool*)isIgnoreHeight
{
    float ingore_value = -1.1f;
    
    NSNumber* valueX = ((int)values.count - 1) < (int)0 ? nil : [values objectAtIndex: 0];
    NSNumber* valueY = ((int)values.count - 1) < (int)1 ? nil : [values objectAtIndex: 1];
    NSNumber* valueWidth = ((int)values.count - 1) < (int)2 ? nil : [values objectAtIndex: 2];
    NSNumber* valueHeight = ((int)values.count - 1) < (int)3 ? nil : [values objectAtIndex: 3];
    
    *x = [valueX floatValue];
    *y = [valueY floatValue];
    *width = [valueWidth floatValue];
    *height = [valueHeight floatValue];
    
    *isIgnoreX      = valueX == nil         || *x == ingore_value;
    *isIgnoreY      = valueY == nil         || *y == ingore_value;
    *isIgnoreWidth  = valueWidth  == nil    || *width == ingore_value;
    *isIgnoreHeight = valueHeight == nil    || *height == ingore_value;
}


+(void) setComponentCenter: (NSArray*)values component:(UIView*)view
{
    if (values.count != 2) return;
    
    float ingore_value = -1.1f;
    
    float x = [values[0] floatValue];
    float y = [values[1] floatValue];
    
    bool isIgnoreX      = x         == ingore_value;
    bool isIgnoreY      = y         == ingore_value;
    
    
    if ( !isIgnoreX && !isIgnoreY){
        CGPoint point = [RectHelper parsePoint: values];
        CGPoint center = [FrameTranslater convertCanvasPoint: point];
        view.center = center;
        
    } else {
        if (!isIgnoreX) [view setCenterX:[FrameTranslater convertCanvasX:x]];
        if (!isIgnoreY) [view setCenterY:[FrameTranslater convertCanvasY:y]];
    }
    
}


+(UIEdgeInsets) convertCanvasEdgeInsets: (UIEdgeInsets)insets
{
    return UIEdgeInsetsMake([FrameTranslater convertCanvasHeight: insets.top],
                            [FrameTranslater convertCanvasWidth: insets.left],
                            [FrameTranslater convertCanvasHeight: insets.bottom],
                            [FrameTranslater convertCanvasWidth: insets.right]);
}


+(void) translateSubViewsFramesRecursive: (UIView*)view handler:(BOOL(^)(UIView* subView))handler
{
    NSArray* subviews = [view subviews];
    for (UIView* subview in subviews) {
        if (handler) if(handler(subview)) continue;
        
        subview.frame = [FrameTranslater convertCanvasRect: subview.frame];
        
        // 1. UILabel's Font
        if ([subview isKindOfClass:[UILabel class]]) {
            
            // for the situation label is the text filed placeholder
//            if ([ViewHelper getSuperView: subview clazz:[UITextField class]]) {
//              ....
//            }
            
            UILabel* label = (UILabel*)subview;
            UIFont* font = label.font;
            label.font = [font fontWithSize: [FrameTranslater convertFontSize: font.pointSize]];
        }
        
        // 2. UITextField's Font
        
        
        [self translateSubViewsFramesRecursive: subview handler:handler];
    }
}


@end
