#import <UIKit/UIKit.h>

@interface RectHelper : NSObject

CGFloat CGSizeGetMax(CGSize size);
CGFloat CGSizeGetMin(CGSize size);


#pragma mark - About Screen Size;

+(CGRect) getScreenPortraitRect;
+(CGRect) getScreenLandscapeRect;
+(CGRect) getScreenRect: (BOOL)isLandscape;


+(CGRect) getScreenRectByDeviceOrientation;
+(CGRect) getScreenRectByControllerOrientation;


+(CGSize) getScreenPortraitSize;
+(CGSize) getScreenLandscapeSize;
+(CGSize) getScreenSize: (BOOL)isPortrait;


+(UIInterfaceOrientation) getTopViewControllerOrientation;

+(CGSize) getScreenSizeByDeviceOrientation;
+(CGSize) getScreenSizeByDeviceOrientation: (UIDeviceOrientation)orientation;
+(CGSize) getScreenSizeByControllerOrientation;
+(CGSize) getScreenSizeByControllerOrientation: (UIInterfaceOrientation)orientation;

#pragma mark - Parse Methods

+(CGSize) parseSize: (id)config;
+(CGRect) parseRect: (id)config;
+(CGPoint) parsePoint: (id)config;

+(UIOffset) parseUIOffset: (id)config;
+(UIEdgeInsets) parseUIEdgeInsets: (id)config;


@end
