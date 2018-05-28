#import <Foundation/Foundation.h>

typedef double (*NSKeyframeAnimationFunction)(double, double, double, double);

typedef enum {
    NoEasing        = 0,
    EaseInQuad      = 1,
    EaseOutQuad     = 2,
    EaseInOutQuad   = 3,
    EaseInCubic     = 4,
    EaseOutCubic    = 5,
    EaseInOutCubic  = 6,
    EaseInQuart     = 7,
    EaseOutQuart    = 8,
    EaseInOutQuart  = 9,
    EaseInQuint     = 10,
    EaseOutQuint    = 11,
    EaseInOutQuint  = 12,
    EaseInSine      = 13,
    EaseOutSine     = 14,
    EaseInOutSine   = 15,
    EaseInExpo      = 16,
    EaseOutExpo     = 17,
    EaseInOutExpo   = 18,
    EaseInCirc      = 19,
    EaseOutCirc     = 20,
    EaseInOutCirc   = 21,
    EaseInElastic   = 22,
    EaseOutElastic  = 23,
    EaseInOutElastic= 24,
    EaseInBack      = 25,
    EaseOutBack     = 26,
    EaseInOutBack   = 27,
    EaseInBounce    = 28,
    EaseOutBounce   = 29,
    EaseInOutBounce = 30,
} EasingType;

@interface EaseFunction : NSObject {    
    @private
    @protected
}

#pragma mark - Public Properties 

#pragma mark - Public Methods
+ (NSKeyframeAnimationFunction)easingFunctionForType:(EasingType)easingType ;

#pragma mark - Protected Methods

#pragma mark - Private Methods

@end
