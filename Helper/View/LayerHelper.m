#import "LayerHelper.h"

#import "KeyValueHelper.h"


@implementation LayerHelper

+(void) setAnchorPoint:(CGPoint)anchorPoint layer:(CALayer*)layer
{
    CGRect oldFrame = layer.frame;
    layer.anchorPoint = anchorPoint;
    layer.frame = oldFrame;
}

+(void) setBottomBorder: (CALayer*)layer
{
    CALayer *bottomBorderLayer = [CALayer layer];
    
    bottomBorderLayer.frame = CGRectMake(0, layer.frame.size.height - 1, layer.frame.size.width, 1.0f);
    
    bottomBorderLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    [layer addSublayer:bottomBorderLayer];
}

@end
