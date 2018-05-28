#import "ColorHelper.h"
#import "UIColor+FlatColors.h"


@implementation ColorHelper


#pragma mark - Public Methods

+(UIColor*) parseColor: (id)config {
    if (!config) return nil;
    if ([config isKindOfClass:[UIColor class]]) return config;
    if ([config isKindOfClass:[NSNumber class]]) return [ColorHelper color:[config intValue]];
    if (!([config isKindOfClass: [NSArray class]] || [config isKindOfClass: [NSDictionary class]])) return nil;
    
    float red = 0.0, green = 0.0, blue = 0.0 ,alpha = 1.0;
    [self parseColor: config red:&red green:&green blue:&blue alpha:&alpha];
    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha] ;
}

// config - dic or array
+(void) parseColor: (id)config red:(float*)red green:(float*)green blue:(float*)blue alpha:(float*)alpha
{
    *red = 0.0 , *green = 0.0, *blue = 0.0, *alpha = 1.0;
    if ([config isKindOfClass: [NSDictionary class]]) {
        *red = [[config objectForKey:   @"R"] floatValue] ;
        *green = [[config objectForKey: @"G"] floatValue] ;
        *blue = [[config objectForKey:  @"B"] floatValue] ;
        NSNumber* alphaNum = [config objectForKey:  @"alpha"];
        if (alphaNum) *alpha = [alphaNum floatValue];
    } else if ([config isKindOfClass: [NSArray class]]) {
        for (int i = 0 ; i < [config count]; i++ ) {
            if (i == 0) *red = [[config objectAtIndex: i] floatValue];
            else
            if (i == 1) *green = [[config objectAtIndex: i] floatValue];
            else
            if (i == 2) *blue = [[config objectAtIndex: i] floatValue];
            else
            if (i == 3) *alpha = [[config objectAtIndex: i] floatValue];
        }
    }
    *red = *red > 1.0 ? *red/255.0 : *red,  *green = *green > 1.0 ? *green/255.0 : *green,  *blue = *blue > 1.0 ? *blue/255.0 : *blue;
}



#pragma mark - 
#pragma mark - Convenient Methods

#define DEFAULT_COLOR [UIColor greenColor]
#define DEFAULT_WIDTH 1.0f

+(void) setBorderRecursive: (id)obj
{
    [self setBorderRecursive: obj color:DEFAULT_COLOR];
}
+(void) setBorderRecursive: (id)obj color:(id)color
{
    [self setBorderRecursive: obj color:color width:DEFAULT_WIDTH];
}
+(void) setBorderRecursive: (id)obj color:(id)color width:(float)width
{
    if ([obj isKindOfClass: [UIView class]]) {
        UIView* view = (UIView*)obj;
        for (UIView* subview in view.subviews) {
            [self setBorderRecursive: subview color:color width:width];
        }
    } else if ([obj isKindOfClass: [CALayer class]]) {
        CALayer* layer = (CALayer*)obj;
        for (CALayer* sublayer in layer.sublayers) {
            [self setBorderRecursive: sublayer color:color width:width];
        }
    }
    [self setBorder: obj color:color width:width];
}


+(void) setBorder: (id)obj
{
    [self setBorder:obj color:DEFAULT_COLOR];
}

+(void) setBorder: (id)obj color:(id)color
{
    [self setBorder:obj color:color width:DEFAULT_WIDTH];
}

+(void) setBorder: (id)obj color:(id)color width:(float)width
{
    CALayer* layer = nil;
    if ([obj isKindOfClass: [UIView class]]) {
        layer = ((UIView*)obj).layer;
    } else if ([obj isKindOfClass: [CALayer class]]) {
        layer = obj;
    }
    layer.borderWidth = width;
    layer.borderColor = [[self parseColor:color] CGColor];
}


// clear
+(void) clearBorder: (id)obj
{
    [self setBorder: obj color:0 width:0.0f];
}
+(void) clearBorderRecursive: (id)obj
{
    [self setBorderRecursive: obj color:0 width:0.0f];
}







// background

+(void) setBackGroundRecursive: (id)obj
{
    [self setBackGroundRecursive: obj color:DEFAULT_COLOR];
}
+(void) setBackGroundRecursive: (id)obj color:(id)color
{
    if ([obj isKindOfClass: [UIView class]]) {
        UIView* view = (UIView*)obj;
        for (UIView* subview in view.subviews) {
            [self setBackGroundRecursive: subview color:color];
        }
    } else if ([obj isKindOfClass: [CALayer class]]) {
        CALayer* layer = (CALayer*)obj;
        for (CALayer* sublayer in layer.sublayers) {
            [self setBackGroundRecursive: sublayer color:color];
        }
    }
    [self setBackGround: obj color:color];
}


+(void) setBackGround: (id)obj
{
    [self setBackGround: obj color:DEFAULT_COLOR];
}
+(void) setBackGround: (id)obj color:(id)color
{
    if ([obj isKindOfClass: [UIView class]]) {
        UIView* view = (UIView*)obj;
        view.backgroundColor = [self parseColor: color];
    } else if ([obj isKindOfClass: [CALayer class]]) {
        CALayer* layer = (CALayer*)obj;
        layer.backgroundColor = [[self parseColor: color] CGColor];
    }
}


+(void) clearBackGround: (id)obj
{
    [self setBackGround: obj color:0];
}

+(void) clearBackGroundRecursive: (id)obj
{
    [self setBackGroundRecursive: obj color:0];
}








#pragma mark - Util Private 

+(UIColor*) color: (int)chosenColor
{
    UIColor *color = [UIColor blackColor];
    switch (chosenColor) {
        case 0:
            color = [UIColor clearColor];
            break;
            
        case 1:
            color = [UIColor flatGreenColor];
            break;
        case 2:
            color = [UIColor flatBlueColor];
            break;
        case 3:
            color = [UIColor flatTealColor];
            break;
        case 4:
            color = [UIColor flatPurpleColor];
            break;
        case 5:
            color = [UIColor flatYellowColor];
            break;
        case 6:
            color = [UIColor flatOrangeColor];
            break;
        case 7:
            color = [UIColor flatGrayColor];
            break;
        case 8:
            color = [UIColor flatWhiteColor];
            break;
        case 9:
            color = [UIColor flatBlackColor];
            break;
        case 10:
            color = [UIColor flatRedColor];
            break;
        case 11:
            color = [UIColor flatDarkGreenColor];
            break;
        case 12:
            color = [UIColor flatDarkBlueColor];
            break;
        case 13:
            color = [UIColor flatDarkTealColor];
            break;
        case 14:
            color = [UIColor flatDarkPurpleColor];
            break;
        case 15:
            color = [UIColor flatDarkYellowColor];
            break;
        case 16:
            color = [UIColor flatDarkOrangeColor];
            break;
        case 17:
            color = [UIColor flatDarkGrayColor];
            break;
        case 18:
            color = [UIColor flatDarkWhiteColor];
            break;
        case 19:
            color = [UIColor flatDarkBlackColor];
            break;
        case 20:
            color = [UIColor flatDarkRedColor];
            break;
            
            
            
        case 21:
            color = [UIColor darkGrayColor]; // 0.333 white
            break;
        case 22:
            color = [UIColor lightGrayColor]; // 0.667 white
            break;
        case 23:
            color = [UIColor whiteColor]; // 1.0 white
            break;
        case 24:
            color = [UIColor grayColor]; // 0.5 white
            break;
        case 25:
            color = [UIColor redColor]; // 1.0, 0.0, 0.0 RGB
            break;
        case 26:
            color = [UIColor greenColor]; // 0.0, 1.0, 0.0 RGB
            break;
        case 27:
            color = [UIColor blueColor]; // 0.0, 0.0, 1.0 RGB
            break;
        case 28:
            color = [UIColor cyanColor]; // 0.0, 1.0, 1.0 RGB
            break;
        case 29:
            color = [UIColor yellowColor]; // 1.0, 1.0, 0.0 RGB
            break;
        case 30:
            color = [UIColor magentaColor]; // 1.0, 0.0, 1.0 RGB
            break;
        case 31:
            color = [UIColor orangeColor]; // 1.0, 0.5, 0.0 RGB
            break;
        case 32:
            color = [UIColor purpleColor]; // 0.5, 0.0, 0.5 RGB
            break;
        case 33:
            color = [UIColor brownColor]; // 0.6, 0.4, 0.2 RGB
            break;
        case 34:
            color = [UIColor blackColor]; // 0.0 white
            break;
            
        default:
            
            break;
    }
    return color;
}

@end
