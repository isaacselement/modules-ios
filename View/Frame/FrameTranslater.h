#import <UIKit/UIKit.h>




#define CanvasX(x) [FrameTranslater convertCanvasX: x]
#define CanvasY(y) [FrameTranslater convertCanvasY: y]
#define CanvasW(w) [FrameTranslater convertCanvasWidth: w]
#define CanvasH(h) [FrameTranslater convertCanvasHeight: h]

#define CanvasFontSize(px) [FrameTranslater convertFontSize: px]

#define CanvasSize(w, h) [FrameTranslater convertCanvasSize: CGSizeMake(w, h)]
#define CanvasPoint(x, y) [FrameTranslater convertCanvasPoint: CGPointMake(x, y)]
#define CanvasRect(x, y, w, h) [FrameTranslater convertCanvasRect: CGRectMake(x, y, w, h)]

#define CanvasCGSize(size) [FrameTranslater convertCanvasSize: size]
#define CanvasCGRect(rect) [FrameTranslater convertCanvasRect: rect]
#define CanvasCGPoint(point) [FrameTranslater convertCanvasPoint: point]







@interface FrameTranslater : NSObject


#pragma mark - Canvas to Real

#pragma mark -

+(CGSize) canvas;
+(void) setCanvas:(CGSize)design;


#pragma mark -

+(void) transformView: (UIView*)view;

+(CGFloat) convertFontSize: (CGFloat)fontSize ;


#pragma mark - Canvas to Real

+(CGFloat) convertCanvasX: (CGFloat)x ;
+(CGFloat) convertCanvasY: (CGFloat)y ;
+(CGFloat) convertCanvasWidth: (CGFloat)x ;
+(CGFloat) convertCanvasHeight: (CGFloat)y ;

+(CGPoint) convertCanvasPoint: (CGPoint)point ;
+(CGSize) convertCanvasSize: (CGSize)size;
+(CGRect) convertCanvasRect: (CGRect)rect ;


#pragma mark - Real to Canvas

+(CGFloat) canvasX: (CGFloat)x ;
+(CGFloat) canvasY: (CGFloat)y ;
+(CGFloat) canvasWidth: (CGFloat)width ;
+(CGFloat) canvasHeight: (CGFloat)height ;

+(CGPoint) canvasPoint: (CGPoint)point;
+(CGSize) canvasSize: (CGSize)size;
+(CGRect) canvasRect: (CGRect)rect;

@end
