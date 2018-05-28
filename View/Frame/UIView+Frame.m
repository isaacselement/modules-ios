#import "UIView+Frame.h"
#import <objc/runtime.h>

@implementation UIView (Frame)


-(NSValue *)portraitFrame {
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)setPortraitFrame:(NSValue *)frame {
    objc_setAssociatedObject(self, @selector(portraitFrame), frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)landscapeFrame {
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)setLandscapeFrame:(NSValue *)frame {
    objc_setAssociatedObject(self, @selector(landscapeFrame), frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Center

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX: (CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}


- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY: (CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}


-(void) addCenterX:(CGFloat)x
{
    self.center = CGPointMake(self.center.x + x, self.center.y);
}

-(void) addCenterY:(CGFloat)y
{
    self.center = CGPointMake(self.center.x, self.center.y + y);
}


-(CGPoint) middlePoint
{
    return CGPointMake([self sizeWidth]/2, [self sizeHeight]/2);
}


#pragma mark - Size

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize: (CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}


- (CGFloat)sizeWidth
{
	CGRect frame = self.frame;
	return frame.size.width ;
}

- (void)setSizeWidth: (CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)sizeHeight
{
	CGRect frame = self.frame;
	return frame.size.height ;
}

- (void)setSizeHeight: (CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


- (void)addSizeWidth: (CGFloat)increment
{
	CGRect frame = self.frame;
	frame.size.width += increment;
	self.frame = frame;
}

- (void)addSizeHeight: (CGFloat)increment
{
    CGRect frame = self.frame;
	frame.size.height += increment;
	self.frame = frame;
}



#pragma mark - Origin

-(CGPoint) origin
{
    return self.frame.origin;
}

-(void) setOrigin: (CGPoint)point
{
    CGRect frame = self.frame;
	frame.origin = point;
	self.frame = frame;
}


- (CGFloat)originX
{
    CGRect frame = self.frame;
    return frame.origin.x ;
}

- (void)setOriginX: (CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)originY
{
    CGRect frame = self.frame;
    return frame.origin.y ;
}

- (void)setOriginY: (CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}


- (void)addOriginX: (CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x += x;
	self.frame = frame;
}

- (void)addOriginY: (CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y += y;
	self.frame = frame;
}


@end
