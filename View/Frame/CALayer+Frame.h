#import <QuartzCore/QuartzCore.h>

@interface CALayer(Frame)

#pragma mark - Position

@property (nonatomic) CGFloat positionX;
@property (nonatomic) CGFloat positionY;
@property (readonly) CGPoint middlePoint;
-(void) addPositionX:(CGFloat)x;
-(void) addPositionY:(CGFloat)y;



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
