#import "FrameTranslater.h"


/** Note here : All "canvas" here is the designed frame **/




// Take the landscape design for example :


// ipad     1024×768(mini) & 2048×1536(air)         :   1024/768 = 1.333 ,  2048/1536 = 1.333
// iphone   1136×640(5&5s) & 960×640(4s)            :   1136/640 = 1.775 ,  960/640   = 1.5

// For iphone5(s), Get it to int . then we get 1000 * 1.775 = 1775, so finally , we get the designed result 1775x1000
// in config and your frame, size, origin, width, height, do notice to use the desiged canvas to measure.

//(iphone5(s) solution)
//#define LONG 1775
//#define SHORT 1000

// Explain this one design , 1920 / 1280 = 1.5 . and (1.333 + 1.775) / 2=1.555 . ok , there is a little bit contrast
// so , this just bring the average of iphone5(s) and ipad's screen resolution, and its equals to iphone4s screen ratio.

//(Average solution)
//#define LONG 1920
//#define SHORT 1280









@implementation FrameTranslater

static CGSize canvas;

#pragma mark -

+(CGSize) canvas
{
    return canvas;
}
+(void) setCanvas:(CGSize)design
{
    canvas = design;
    [self updateCanvasRatio];
}

#pragma mark - About Font (In UILable)
// transform label , then getFrame
+(void) transformView: (UIView*)view
{
    if (self.ratioX == 1.0 && self.ratioY == 1.0) {
        view.transform = CGAffineTransformIdentity;
    } else {
        view.transform = CGAffineTransformMakeScale(self.ratioX, self.ratioY);
    }
}

// convert size for label(then getFrame), textfield ...
+(CGFloat) convertFontSize: (CGFloat)fontSize {
    return fontSize * ((self.ratioX + self.ratioY) / 2);
}


#pragma mark - Canvas to Real

+(CGFloat) convertCanvasX: (CGFloat)x {
    x *= self.ratioX;
    return x;
}

+(CGFloat) convertCanvasY: (CGFloat)y {
    y *= self.ratioY;
    return y;
}

+(CGFloat) convertCanvasWidth: (CGFloat)width {
    width *= self.ratioX;
    return width;
}

+(CGFloat) convertCanvasHeight: (CGFloat)height {
    height *= self.ratioY;
    return height;
}

+(CGPoint) convertCanvasPoint: (CGPoint)point
{
    CGFloat x = [self convertCanvasX: point.x];
    CGFloat y = [self convertCanvasY: point.y];
    return CGPointMake(x, y);
}

+(CGSize) convertCanvasSize: (CGSize)size
{
    CGFloat width = [self convertCanvasWidth: size.width];
    CGFloat height = [self convertCanvasHeight: size.height];
    return CGSizeMake(width, height);
}

+(CGRect) convertCanvasRect: (CGRect)rect {
    CGFloat x = [self convertCanvasX: rect.origin.x];
    CGFloat y = [self convertCanvasY: rect.origin.y];
    CGFloat width = [self convertCanvasWidth: rect.size.width];
    CGFloat height = [self convertCanvasHeight: rect.size.height];
    return CGRectMake(x, y, width, height);
}


#pragma mark - Real to Canvas

+(CGFloat) canvasX: (CGFloat)x {
    x /= self.ratioX;
    return x;
}

+(CGFloat) canvasY: (CGFloat)y {
    y /= self.ratioY;
    return y;
}

+(CGFloat) canvasWidth: (CGFloat)width {
    width /= self.ratioX;
    return width;
}

+(CGFloat) canvasHeight: (CGFloat)height {
    height /= self.ratioY;
    return height;
}

+(CGPoint) canvasPoint: (CGPoint)point
{
    return CGPointMake([self canvasX:point.x], [self canvasY:point.y]);
}

+(CGSize) canvasSize: (CGSize)size
{
    return CGSizeMake([self canvasWidth:size.width], [self canvasHeight:size.height]);
}

+(CGRect) canvasRect: (CGRect)rect
{
    return CGRectMake([self canvasX:rect.origin.x], [self canvasY:rect.origin.y], [self canvasWidth:rect.size.width], [self canvasHeight:rect.size.height]);
}



#pragma mark - Ratio

static float _ratioX = 1;
static float _ratioY = 1;

+(float) ratioX
{
    return _ratioX;
}

+(float) ratioY
{
    return _ratioY;
}

+(void) updateCanvasRatio {
    [self getRatios: canvas ratioX:&_ratioX ratioY:&_ratioY];
}

/**
 
 Note here:
 For the status Bar, 1 for portrait , 0 for landscape (Heigth in ipad,iphone = 20)
 
 willRotate: controller.view {768, 1024} , 1; statusBaris {768, 20},  1
 
 didRotate:  controller.view {1024, 768} , 0; statusBaris {20, 1024}, 0
 
 But for ios 7 , the status bar does influence the controller.view
 
 **/

+(void) getRatios: (CGSize)canvas ratioX:(float*)ratioX ratioY:(float*)ratioY {
    
    // like UIWindow's bounds, ios 7 and below ,  always will be (768 x 1024)(ipad) not influnce by orientation.
    // 2014-9-23 note: ios 7 and below : 320 X 568 , but in ios 8 : 568 X 320
    // get the width and height
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.height;
    if (canvas.width > canvas.height) {             // landscape is width > height
        width = CGSizeGetMaximum(screenSize);
        height = CGSizeGetMinimun(screenSize);
    }
    
    
    // Ignore the case of statusbar on ios >= 7.0 and hidden.
    if (! [UIApplication sharedApplication].statusBarHidden) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            height -= CGSizeGetMinimun([UIApplication sharedApplication].statusBarFrame.size);
        }
    }
    
    
    // after get the width and height , than caculate the ratio
    *ratioX = (float)width / (float)canvas.width;
    *ratioY = (float)height / (float)canvas.height;
}


#pragma mark -

CGFloat CGSizeGetMaximum(CGSize size)
{
    return size.width > size.height ? size.width : size.height;
}
CGFloat CGSizeGetMinimun(CGSize size)
{
    return size.width < size.height ? size.width : size.height;
}


@end
