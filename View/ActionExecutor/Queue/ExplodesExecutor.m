#import "ExplodesExecutor.h"
#import "_ActionExecutor_.h"

#import <objc/runtime.h>

#import "ViewHelper.h"
#import "UIView+Additions.h"
#import "KeyValueHelper.h"
#import "UIImage+Additions.h"




@implementation ExplodesExecutor


#pragma mark - Override Methods

-(void) applyAnimation: (CAKeyframeAnimation*)animation layer:(CALayer*)layer config:(NSDictionary*)config
{
    NSArray* tiles = [ExplodesExecutor split:config[@"cover.tiles"] layer:layer];
    
    CALayer* coverLayer = [CALayer layer];
    
    // hard code now ...
    [[KeyValueHelper sharedInstance] setValues:config[@"cover.layer"] object:coverLayer];
    double duration = animation.duration - 0.1;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (CALayer* tile in tiles) {
            [tile removeAllAnimations];
            [tile removeFromSuperlayer];
        }
        [coverLayer removeAllAnimations];
        [coverLayer removeFromSuperlayer];
    });
    
    
    // after split
    CALayer* topViewLayer = [UIView getTopView].layer;
    coverLayer.frame = [layer.superlayer convertRect:layer.frame toLayer:topViewLayer];
    [topViewLayer addSublayer: coverLayer];
    
    
    // to do ...........
    animation.delegate = nil;
    // now , the animationDidStart and animationDidStop: will not call .... so to do ...
    // to do ...........
    
    CGSize containerSize = topViewLayer.frame.size;
    for (int i = 0; i < tiles.count; i++) {
        CALayer* tile = tiles[i];
        
        [coverLayer addSublayer: tile];
        
        animation.path = [ExplodesExecutor getParticlePath: tile containerSize:containerSize].CGPath;
        
        [tile addAnimation: animation forKey: animation.keyPath];
    }
    
}






#pragma mark -

// get the split layers
+(NSMutableArray*)split: (NSDictionary*)config layer:(CALayer*)layer
{
    int row = [config[@"row"] intValue];
    int column = [config[@"column"] intValue];
    row = row != 0 ? row : 5;
    column = column != 0 ? column : 5 ;
    
    NSMutableArray* tiles = [NSMutableArray array];
    
    CGSize viewSize = layer.frame.size;
    CGFloat borderWidth = layer.borderWidth;
    CGImageRef image = [ViewHelper imageFromLayer: layer].CGImage;
    
    CGSize tileSize = CGSizeMake( (viewSize.width - borderWidth * 2) / row, (viewSize.height  - borderWidth * 2) / column);
    
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            
            CGFloat x = j * tileSize.width + borderWidth;
            CGFloat y = i * tileSize.height + borderWidth;
            
            CGRect tileRect = (CGRect){{x, y}, tileSize};
            CALayer *tile = [CALayer layer];
            tile.frame = tileRect;
            
            CGRect tileImageRect = (CGRect){{x + 1, y + 1}, tileSize};
            CGImageRef tileImage = CGImageCreateWithImageInRect(image, tileImageRect);
            tile.contents = (__bridge id)(tileImage);
            CGImageRelease(tileImage);

            [tiles addObject: tile];
            [[KeyValueHelper sharedInstance] setValues:config[@"tiles.layer"] object:tile];
        }
    }
    return tiles;
}

+(UIBezierPath *)getParticlePath:(CALayer *)layer containerSize:(CGSize)containerSize
{
    CGFloat containerWidth = containerSize.width;
    CGFloat containerHeight = containerSize.height;
    
    CGRect superLayerFrame = layer.superlayer.frame;
    
    float r = randomFloat() + 0.3f;
    float r2 = randomFloat() + 0.4f;
    float r3 = r * r2;
    
    int upOrDown = (r <= 0.5) ? 1 : -1;
    
    CGPoint startPoint = layer.position;
    CGPoint curvePoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    float maxLeftRightShift = 1.f * randomFloat();
    
    CGFloat layerYPosAndHeight = (containerHeight-((layer.position.y+layer.frame.size.height)))*randomFloat();
    CGFloat layerXPosAndHeight = (containerWidth-((layer.position.x+layer.frame.size.width)))*r3;
    
    float endY = containerHeight - superLayerFrame.origin.y;
    
    if (layer.position.x <= superLayerFrame.size.width * 0.5) {
        endPoint = CGPointMake(-layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown)*maxLeftRightShift,-layerYPosAndHeight);
    } else {
        endPoint = CGPointMake(layerXPosAndHeight, endY);
        curvePoint= CGPointMake((((layer.position.x*0.5)*r3)*upOrDown+superLayerFrame.size.width)*maxLeftRightShift, -layerYPosAndHeight);
    }
    
    
    // after get the start/curve/end point, generate the path
    UIBezierPath *particlePath = [UIBezierPath bezierPath];
    [particlePath moveToPoint: startPoint];
    [particlePath addQuadCurveToPoint:endPoint controlPoint:curvePoint];
    
    return particlePath;
    
}

float randomFloat()
{
    return (float)rand()/(float)RAND_MAX;       // (0, 1)
}

@end
