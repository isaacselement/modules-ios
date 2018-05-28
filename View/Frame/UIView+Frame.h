#import <UIKit/UIKit.h>

@interface UIView (Frame)

-(NSValue *)portraitFrame;
-(void)setPortraitFrame:(NSValue *)frame ;

-(NSValue *)landscapeFrame;
-(void)setLandscapeFrame:(NSValue *)frame;



#pragma mark - Center

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (readonly) CGPoint middlePoint;
-(void) addCenterX:(CGFloat)x;
-(void) addCenterY:(CGFloat)y;



#pragma mark - Size

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat sizeWidth;
@property (nonatomic) CGFloat sizeHeight;
-(void) addSizeWidth: (CGFloat)increment;
-(void) addSizeHeight: (CGFloat)increment;



#pragma mark - Origin

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;
-(void) addOriginX: (CGFloat)x;
-(void) addOriginY: (CGFloat)y;

@end
