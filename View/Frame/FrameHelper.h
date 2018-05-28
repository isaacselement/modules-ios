#import <UIKit/UIKit.h>

@interface FrameHelper : NSObject


+(void) translateLabel: (UILabel*)label canvas:(CGRect)canvas;


#pragma mark -

+(void) setComponentFrame: (NSArray*)frame component:(UIView*)view;
+(void) setComponentCenter: (NSArray*)values component:(UIView*)view;
+(void) paseIgnores:(NSArray*)values :(float*)x :(float*)y :(float*)width :(float*)height :(bool*)isIgnoreX :(bool*)isIgnoreY :(bool*)isIgnoreWidth :(bool*)isIgnoreHeight;

+(UIEdgeInsets) convertCanvasEdgeInsets: (UIEdgeInsets)insets;

+(void) translateSubViewsFramesRecursive: (UIView*)view handler:(BOOL(^)(UIView* subView))handler;


@end
