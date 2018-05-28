#import "ZoomablePanView.h"

@implementation ZoomablePanView
{
    float firstX;
    float firstY;
    
    CGFloat lastScale;
    
    CGPoint lastPoint;
    
    CGPoint oCenter;
    
    CGPoint oOffset;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariables];
        
        oCenter = CGPointZero;
        
        oOffset = CGPointZero;
    }
    return self;
}

-(void) initializeVariables
{
    // A . pan
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(panWithAnchor:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer: panRecognizer];
    
    // B . pinch
    UIPinchGestureRecognizer* pinReconizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchWithAnchor:)];
    [self addGestureRecognizer: pinReconizer];
}


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// http://stackoverflow.com/a/5228373
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (self.layer.affineTransform.a < 1.0f) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ self.transform = CGAffineTransformIdentity; self.center = oCenter;} completion:nil];
        }
    }
    
    if ([sender numberOfTouches] < 2)
        return;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(CGPointZero, oCenter)) oCenter = self.center;
        lastScale = 1.0;
        lastPoint = [sender locationInView:self];
    }
    
    // Scale
    CGFloat scale = 1.0 - (lastScale - sender.scale);
    [self.layer setAffineTransform:CGAffineTransformScale([self.layer affineTransform], scale, scale)];
    lastScale = sender.scale;
    
    // Translate
    CGPoint point = [sender locationInView:self];
    [self.layer setAffineTransform:CGAffineTransformTranslate([self.layer affineTransform], point.x - lastPoint.x, point.y - lastPoint.y)];
    lastPoint = [sender locationInView:self];
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)sender
{
    
}


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// http://stackoverflow.com/a/4957033/1749293

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)pinchWithAnchor:(UIPinchGestureRecognizer *)sender
{
    UIView *view = sender.view;
    // adjust anchor point
    // scale and rotation transforms are applied relative to the layer's anchor point
    // this method moves a gesture recognizer's view's anchor point between the user's fingers
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(CGPointZero, oCenter)) oCenter = view.center;
        
        CGPoint locationInView = [sender locationInView:view];
        CGPoint locationInSuperview = [sender locationInView:view.superview];
        
        view.layer.anchorPoint = CGPointMake(locationInView.x / view.bounds.size.width, locationInView.y / view.bounds.size.height);
        oOffset = CGPointMake(view.center.x - locationInSuperview.x, view.center.y - locationInSuperview.y);
        view.center = locationInSuperview;
        
        
        NSLog(@"anchor point : %@", NSStringFromCGPoint(view.layer.anchorPoint));
        NSLog(@"center : %@", NSStringFromCGPoint(view.center));
    }
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, [sender scale], [sender scale]);
        [sender setScale:1];
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (view.transform.a < 1.0f) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ view.transform = CGAffineTransformIdentity; view.center = oCenter; view.layer.anchorPoint = (CGPoint){0.5,0.5};} completion:nil];
        }
    }
}




- (void) panWithAnchor:(UIPanGestureRecognizer*)sender
{
    UIView* view = [sender view];
    CGPoint center = view.center;
    if ([sender state] == UIGestureRecognizerStateBegan) {
//        self.layer.anchorPoint = CGPointMake(.5f, .5f);
    }
    
    CGPoint translatedPoint = [sender translationInView:view.superview];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(CGPointZero, oCenter)) oCenter = center;
        firstX = translatedPoint.x;
        firstY = translatedPoint.y;
    }
    CGPoint point = CGPointMake(translatedPoint.x - firstX + center.x, translatedPoint.y - firstY + center.y);
    firstX = translatedPoint.x;
    firstY = translatedPoint.y;
    
    // to the x edge
    if (fabs(oCenter.x - (point.x + view.transform.tx + oOffset.x)) >= fabs(oCenter.x * view.transform.a - oCenter.x)) {
        //        return;
        point = CGPointMake(center.x , point.y);
    }
    // to the y edge
    if (fabs(oCenter.y - (point.y + view.transform.ty)) >= fabs(oCenter.y * view.transform.d - oCenter.y)) {
        //        return;
        point = CGPointMake(point.x, center.y);
    }
    
    view.center = point;
    
}




//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-(void)handlePinch:(UIPinchGestureRecognizer*)sender
{
    
    //____________________________________________
    
    // http://stackoverflow.com/a/7568011/1749293
    // http://stackoverflow.com/a/10780743/1749293
    UIView* view = sender.view;
    CGFloat scale = sender.scale;
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(CGPointZero, oCenter)) oCenter = view.center;
        lastScale = 1.0f;
        lastPoint = [sender locationInView:view];
    }
    
    // scale
    CGFloat _scale = 1.0f - (lastScale - scale);
    view.transform = CGAffineTransformScale(view.transform, _scale, _scale);
    lastScale = scale;
    
    // Translate
    CGPoint point = [sender locationInView:view];
    view.transform = CGAffineTransformTranslate(view.transform, point.x - lastPoint.x, point.y - lastPoint.y);
    lastPoint = [sender locationInView:view];
    
//    CGPoint point = [recognizer locationInView:view];       // the center point of two touch in pinch
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    for (int i = 0 ; i < [recognizer numberOfTouches]; i ++) {
//        NSLog(@"%i: %@", i, NSStringFromCGPoint([recognizer locationOfTouch: i inView:view]));
//    }
    
    //____________________________________________

    if ([sender state] == UIGestureRecognizerStateEnded) {
        NSLog(@"%@", NSStringFromCGAffineTransform(view.transform));
        if (view.transform.a < 1.0f) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ view.transform = CGAffineTransformIdentity; view.center = oCenter;} completion:nil];
        }
    }
    
}

-(void)handlePan:(UIPanGestureRecognizer*)sender
{
    UIView* view = [sender view];
    CGPoint center = view.center;
    
    CGPoint translatedPoint = [sender translationInView:view.superview];
    if ([sender state] == UIGestureRecognizerStateBegan) {
        if (CGPointEqualToPoint(CGPointZero, oCenter)) oCenter = center;
        firstX = translatedPoint.x;
        firstY = translatedPoint.y;
    }
    CGPoint point = CGPointMake(translatedPoint.x - firstX + center.x, translatedPoint.y - firstY + center.y);
    firstX = translatedPoint.x;
    firstY = translatedPoint.y;
    
    // to the x edge
    if (fabs(oCenter.x - (point.x + view.transform.tx)) >= fabs(oCenter.x * view.transform.a - oCenter.x)) {
        //        return;
        point = CGPointMake(center.x , point.y);
    }
    // to the y edge
    if (fabs(oCenter.y - (point.y + view.transform.ty)) >= fabs(oCenter.y * view.transform.d - oCenter.y)) {
        //        return;
        point = CGPointMake(point.x, center.y);
    }
    
    view.center = point;
    
}

@end
