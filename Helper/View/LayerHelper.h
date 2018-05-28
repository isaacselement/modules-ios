#import <UIKit/UIKit.h>

#define degreeToRadian(x) (x * M_PI / 180.0)

@interface LayerHelper : NSObject


// change the anchorPOint, but the visual psoition on screen is not change
+(void) setAnchorPoint:(CGPoint)anchorPoint layer:(CALayer*)layer;

+(void) setBottomBorder: (CALayer*)layer;

@end
