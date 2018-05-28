#import "RectHelper.h"
#import "UIView+Additions.h"
#import "NSArray+Additions.h"

@implementation RectHelper


CGFloat CGSizeGetMax(CGSize size)
{
    return size.width > size.height ? size.width : size.height;
}
CGFloat CGSizeGetMin(CGSize size)
{
    return size.width < size.height ? size.width : size.height;
}




#pragma mark - About Screen Rect

+(CGRect) getScreenPortraitRect
{
    return [self getScreenRect: NO];
}

+(CGRect) getScreenLandscapeRect
{
    return [self getScreenRect: YES];
}

+(CGRect) getScreenRect: (BOOL)isLandscape
{
    CGRect rect = CGRectZero;
    rect.size = isLandscape ? [self getScreenLandscapeSize] : [self getScreenPortraitSize];
    return rect;
}

+(CGRect) getScreenRectByDeviceOrientation
{
    CGRect rect = CGRectZero;
    rect.size = [self getScreenSizeByDeviceOrientation];
    return rect;
}

+(CGRect) getScreenRectByControllerOrientation
{
    CGRect rect = CGRectZero;
    rect.size = [self getScreenSizeByControllerOrientation];
    return rect;
}



#pragma mark - About Screen Rect & Size

+(CGSize) getScreenPortraitSize
{
    return [self getScreenSize: NO];
}

+(CGSize) getScreenLandscapeSize
{
    return [self getScreenSize: YES];
}


// controller's orientation

+(UIInterfaceOrientation) getTopViewControllerOrientation
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [ViewHelper getTopViewController].interfaceOrientation;
#else
    CGSize size = [UIView getTopViewController].view.frame.size;
    return size.width > size.height ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
#endif
}

+(CGSize) getScreenSizeByControllerOrientation
{
    return [self getScreenSizeByControllerOrientation: [self getTopViewControllerOrientation]];
}

+(CGSize) getScreenSizeByControllerOrientation: (UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationUnknown) {
        return [self getScreenSizeByDeviceOrientation];
    } else {
        return [self getScreenSize: UIInterfaceOrientationIsLandscape(orientation)];
    }
}

// device's orientation
+(CGSize) getScreenSizeByDeviceOrientation
{
    return [self getScreenSizeByDeviceOrientation: [UIDevice currentDevice].orientation];
}

+(CGSize) getScreenSizeByDeviceOrientation: (UIDeviceOrientation)orientation
{
    return [self getScreenSize: UIDeviceOrientationIsLandscape(orientation)];
}

// root
+(CGSize) getScreenSize: (BOOL)isLandscape
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat _long_ = CGSizeGetMax(screenSize);
    CGFloat _short_ = CGSizeGetMin(screenSize);
    return isLandscape ? CGSizeMake(_long_, _short_) : CGSizeMake(_short_, _long_);
}


#pragma mark - Parse Methods

+(CGPoint) parsePoint: (id)config
{
    CGPoint point = CGPointZero;
    if ([config isKindOfClass: [NSArray class]]) {
        NSArray* array = (NSArray*)config;
        point = CGPointMake(
                            [[array safeObjectAtIndex: 0] floatValue],
                            [[array safeObjectAtIndex: 1] floatValue]
                            );
    } else if ([config isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)config;
        point = CGPointMake(
                            [dictionary[@"x"] floatValue],
                            [dictionary[@"y"] floatValue]
                            );
    }
    return point;
}


+(CGSize) parseSize: (id)config
{
    CGSize size = CGSizeZero;
    if ([config isKindOfClass: [NSArray class]]) {
        NSArray* array = (NSArray*)config;
        size = CGSizeMake(
                          [[array safeObjectAtIndex: 0] floatValue],
                          [[array safeObjectAtIndex: 1] floatValue]
                          );
        
    } else if ([config isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)config;
        size = CGSizeMake(
                          [dictionary[@"width"] floatValue],
                          [dictionary[@"height"] floatValue]
                          );
    }
    return size;
    
}


+(CGRect) parseRect: (id)config
{
    CGRect rect = CGRectZero;
    if ([config isKindOfClass: [NSArray class]]) {
        NSArray* array = (NSArray*)config;
        rect = CGRectMake(
                          [[array safeObjectAtIndex: 0] floatValue],
                          [[array safeObjectAtIndex: 1] floatValue],
                          [[array safeObjectAtIndex: 2] floatValue],
                          [[array safeObjectAtIndex: 3] floatValue]
                          );
    } else if ([config isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)config;
        rect = CGRectMake(
                          [dictionary[@"x"] floatValue],
                          [dictionary[@"y"] floatValue],
                          [dictionary[@"width"] floatValue],
                          [dictionary[@"height"] floatValue]
                          );
    }
    
    return  rect;
}


+(UIOffset) parseUIOffset: (id)config
{
    UIOffset offset = UIOffsetZero;
    if ([config isKindOfClass: [NSArray class]]) {
        NSArray* array = (NSArray*)config;
        offset = UIOffsetMake(
                              [[array safeObjectAtIndex: 0] floatValue],
                              [[array safeObjectAtIndex: 1] floatValue]
                              );
    } else if ([config isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)config;
        offset = UIOffsetMake(
                              [dictionary[@"horizontal"] floatValue],
                              [dictionary[@"vertical"] floatValue]
                              );
    }
    
    return  offset;
}


+(UIEdgeInsets) parseUIEdgeInsets: (id)config
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if ([config isKindOfClass: [NSArray class]]) {
        NSArray* array = (NSArray*)config;
        edgeInsets = UIEdgeInsetsMake(
                                      [[array safeObjectAtIndex: 0] floatValue],
                                      [[array safeObjectAtIndex: 1] floatValue],
                                      [[array safeObjectAtIndex: 2] floatValue],
                                      [[array safeObjectAtIndex: 3] floatValue]
                                      );
    } else if ([config isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dictionary = (NSDictionary*)config;
        edgeInsets = UIEdgeInsetsMake(
                                      [dictionary[@"top"] floatValue],
                                      [dictionary[@"left"] floatValue],
                                      [dictionary[@"bottom"] floatValue],
                                      [dictionary[@"right"] floatValue]
                                      );
    }
    
    return  edgeInsets;
}



@end
