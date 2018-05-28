#import "EaseFunction.h"
#include <math.h>
#include <stdlib.h>

@implementation EaseFunction

// http://www.robertpenner.com/easing/
// https://github.com/NachoSoto/NSBKeyframeAnimation




// JAVASCRIPT SOURCE: http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// OBJECTIVE-C SOURCE : https://github.com/NachoSoto/NSBKeyframeAnimation
// REFERENCE:  http://gsgd.co.uk/sandbox/jquery/easing/
// EASING DEMO : http://jqueryui.com/resources/demos/effect/easing.html




// Warning : Unsequenced modification and access to parameter
// http://stackoverflow.com/questions/18729323/unsequenced-modification-and-access-to-parameter

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"

+ (NSKeyframeAnimationFunction)easingFunctionForType: (EasingType)easingType {
    switch (easingType) {
        case NoEasing:
            return nil;
        case EaseInQuad:
            return NSKeyframeAnimationFunctionEaseInQuad;
        case EaseOutQuad:
            return NSKeyframeAnimationFunctionEaseOutQuad;
        case EaseInOutQuad:
            return NSKeyframeAnimationFunctionEaseInOutQuad;
        case EaseInCubic:
            return NSKeyframeAnimationFunctionEaseInCubic;
        case EaseOutCubic:
            return NSKeyframeAnimationFunctionEaseOutCubic;
        case EaseInOutCubic:
            return NSKeyframeAnimationFunctionEaseInOutCubic;
        case EaseInQuart:
            return NSKeyframeAnimationFunctionEaseInQuart;
        case EaseOutQuart:
            return NSKeyframeAnimationFunctionEaseOutQuart;
        case EaseInOutQuart:
            return NSKeyframeAnimationFunctionEaseInOutQuart;
        case EaseInQuint:
            return NSKeyframeAnimationFunctionEaseInQuint;
        case EaseOutQuint:
            return NSKeyframeAnimationFunctionEaseOutQuint;
        case EaseInOutQuint:
            return NSKeyframeAnimationFunctionEaseInOutQuint;
        case EaseInSine:
            return NSKeyframeAnimationFunctionEaseInSine;
        case EaseOutSine:
            return NSKeyframeAnimationFunctionEaseOutSine;
        case EaseInOutSine:
            return NSKeyframeAnimationFunctionEaseInOutSine;
        case EaseInExpo:
            return NSKeyframeAnimationFunctionEaseInExpo;
        case EaseOutExpo:
            return NSKeyframeAnimationFunctionEaseOutExpo;
        case EaseInOutExpo:
            return NSKeyframeAnimationFunctionEaseInOutExpo;
        case EaseInCirc:
            return NSKeyframeAnimationFunctionEaseInCirc;
        case EaseOutCirc:
            return NSKeyframeAnimationFunctionEaseOutCirc;
        case EaseInOutCirc:
            return NSKeyframeAnimationFunctionEaseInOutCirc;
        case EaseInElastic:
            return NSKeyframeAnimationFunctionEaseInElastic;
        case EaseOutElastic:
            return NSKeyframeAnimationFunctionEaseOutElastic;
        case EaseInOutElastic:
            return NSKeyframeAnimationFunctionEaseInOutElastic;
        case EaseInBack:
            return NSKeyframeAnimationFunctionEaseInBack;
        case EaseOutBack:
            return NSKeyframeAnimationFunctionEaseOutBack;
        case EaseInOutBack:
            return NSKeyframeAnimationFunctionEaseInOutBack;
        case EaseInBounce:
            return NSKeyframeAnimationFunctionEaseInBounce;
        case EaseOutBounce:
            return NSKeyframeAnimationFunctionEaseOutBounce;
        case EaseInOutBounce:
            return NSKeyframeAnimationFunctionEaseInOutBounce;
        default:
            return nil;
    }
    
    return NULL;
}

double NSKeyframeAnimationFunctionEaseInQuad(double t,double b, double c, double d)
{
    return c*(t/=d)*t + b;
}

double NSKeyframeAnimationFunctionEaseOutQuad(double t,double b, double c, double d)
{
    return -c *(t/=d)*(t-2) + b;
}

double NSKeyframeAnimationFunctionEaseInOutQuad(double t,double b, double c, double d)
{
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
}

double NSKeyframeAnimationFunctionEaseInCubic(double t,double b, double c, double d)
{
    return c*(t/=d)*t*t + b;
}

double NSKeyframeAnimationFunctionEaseOutCubic(double t,double b, double c, double d)
{
    return c*((t=t/d-1)*t*t + 1) + b;
}

double NSKeyframeAnimationFunctionEaseInOutCubic(double t, double b, double c, double d)
{
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
    return c/2*((t-=2)*t*t + 2) + b;
}

double NSKeyframeAnimationFunctionEaseInQuart(double t, double b, double c, double d)
{
    return c*(t/=d)*t*t*t + b;
}

double NSKeyframeAnimationFunctionEaseOutQuart(double t, double b, double c, double d)
{
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
}

double NSKeyframeAnimationFunctionEaseInOutQuart(double t, double b, double c, double d)
{
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
}

double NSKeyframeAnimationFunctionEaseInQuint(double t, double b, double c, double d)
{
    return c*(t/=d)*t*t*t*t + b;
}

double NSKeyframeAnimationFunctionEaseOutQuint(double t, double b, double c, double d)
{
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
}

double NSKeyframeAnimationFunctionEaseInOutQuint(double t, double b, double c, double d)
{
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
}

double NSKeyframeAnimationFunctionEaseInSine(double t, double b, double c, double d)
{
    return -c * cos(t/d * (M_PI_2)) + c + b;
}

double NSKeyframeAnimationFunctionEaseOutSine(double t, double b, double c, double d)
{
    return c * sin(t/d * (M_PI_2)) + b;
}

double NSKeyframeAnimationFunctionEaseInOutSine(double t, double b, double c, double d)
{
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
}

double NSKeyframeAnimationFunctionEaseInExpo(double t, double b, double c, double d)
{
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

double NSKeyframeAnimationFunctionEaseOutExpo(double t, double b, double c, double d)
{
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}

double NSKeyframeAnimationFunctionEaseInOutExpo(double t, double b, double c, double d)
{
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    return c/2 * (-pow(2, -10 * --t) + 2) + b;
}

double NSKeyframeAnimationFunctionEaseInCirc(double t, double b, double c, double d)
{
    return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
}

double NSKeyframeAnimationFunctionEaseOutCirc(double t, double b, double c, double d)
{
    return c * sqrt(1 - (t=t/d-1)*t) + b;
}

double NSKeyframeAnimationFunctionEaseInOutCirc(double t, double b, double c, double d)
{
    if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
    return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
}

double NSKeyframeAnimationFunctionEaseInElastic(double t, double b, double c, double d)
{
    double s = 1.70158; double p=0; double a=c;
    
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
    if (a < fabs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}

double NSKeyframeAnimationFunctionEaseOutElastic(double t, double b, double c, double d)
{
    double s=1.70158, p=0, a=c;
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
    if (a < fabs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
}

double NSKeyframeAnimationFunctionEaseInOutElastic(double t, double b, double c, double d)
{
    double s=1.70158, p=0, a=c;
    if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
    if (a < fabs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin(c/a);
    if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
    return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

double NSKeyframeAnimationFunctionEaseInBack(double t, double b, double c, double d)
{
    const double s = 1.70158;
    return c*(t/=d)*t*((s+1)*t - s) + b;
}

double NSKeyframeAnimationFunctionEaseOutBack(double t, double b, double c, double d)
{
    const double s = 1.70158;
    return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
}

double NSKeyframeAnimationFunctionEaseInOutBack(double t, double b, double c, double d)
{
    double s = 1.70158;
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

double NSKeyframeAnimationFunctionEaseOutBounce(double t, double b, double c, double d)
{
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

double NSKeyframeAnimationFunctionEaseInBounce(double t, double b, double c, double d)
{
    return c - NSKeyframeAnimationFunctionEaseOutBounce(d-t, 0, c, d) + b;
}

double NSKeyframeAnimationFunctionEaseInOutBounce(double t, double b, double c, double d)
{
    if (t < d/2)
        return NSKeyframeAnimationFunctionEaseInBounce (t*2, 0, c, d) * .5 + b;
    else
        return NSKeyframeAnimationFunctionEaseOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
}


#pragma clang diagnostic pop


@end
