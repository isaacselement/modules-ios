#import "StrokeLabel.h"

@implementation StrokeLabel

@synthesize strokeR;
@synthesize strokeG;
@synthesize strokeB;
@synthesize strokeAlpha;

@synthesize strokeWidth;
@synthesize drawingMode;

- (void)drawTextInRect:(CGRect)rect {
    CGSize shadowOffset = self.shadowOffset;
    UIColor* textColor = self.textColor;
    
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(context, drawingMode);  // default kCGTextStroke
    self.textColor = [UIColor colorWithRed: strokeR green:strokeG blue:strokeB alpha:strokeAlpha];
    [super drawTextInRect:rect];
    
    
    // the original text
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
