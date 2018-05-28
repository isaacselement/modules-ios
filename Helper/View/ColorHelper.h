#import <UIKit/UIKit.h>


@interface ColorHelper : NSObject


+(UIColor*) parseColor: (id)config ;

+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha;



#pragma mark -
#pragma mark -  Convenient Methods

// UIView or CALayer

// Border
+(void) setBorderRecursive: (id)obj;
+(void) setBorderRecursive: (id)obj color:(id)color;
+(void) setBorderRecursive: (id)obj color:(id)color width:(float)width;

+(void) setBorder: (id)obj;
+(void) setBorder: (id)obj color:(id)color;
+(void) setBorder: (id)obj color:(id)color width:(float)width;

+(void) clearBorder: (id)obj;
+(void) clearBorderRecursive: (id)obj;


// BackGround
+(void) setBackGroundRecursive: (id)obj;
+(void) setBackGroundRecursive: (id)obj color:(id)color;

+(void) setBackGround: (id)obj;
+(void) setBackGround: (id)obj color:(id)color;

+(void) clearBackGround: (id)obj;
+(void) clearBackGroundRecursive: (id)obj;


@end
