#import "ZoomableScrollView.h"

#ifdef DEBUG

#ifndef __DLOG

#define __DLOG(format, ...) NSLog(format, ##__VA_ARGS__)

#else

#define __DLOG(format, ...)

#endif

#endif


@implementation ZoomableScrollView
{
    float originalCenterX;
    float originalCenterY;
    
    float latestCenterX;
    float latestCenterY;
}

@synthesize contentView;

#pragma mark - Override Methods

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeVariables];
    }
    return self;
}

-(void) initializeVariables {
    self.delegate = self;
    self.scrollEnabled = YES;           // if YES, will affect the Button's click effect, and UITableView , so , in subclass we have to use UIPanGestureRecognizer to drag
    self.minimumZoomScale = 1.0f;       // ios default value
    self.maximumZoomScale = 2.0f;
//    self.delaysContentTouches = NO;   // will affect the zoom effect
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    
    contentView = [[UIView alloc] init];
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    [super addSubview: contentView];
}

-(void) setViewFrame: (CGRect)frame
{
    self.frame = frame;
    contentView.frame = self.bounds;
}

-(NSArray*) contentViewSubviews
{
    return contentView.subviews;
}

-(void) addSubviewToContentView: (UIView*)view
{
    [contentView addSubview: view];
}

// for easy debug , comment it will be better !!!
//-(void) addSubview:(UIView *)view {
//    [contentView addSubview: view];
//}

// for easy debug , comment it will be better !!!
// and will cause subveiw auto layout constraints no effect !!!
//-(NSArray *)subviews
//{
//    return contentView.subviews;
//}

// for easy debug , comment it will be better !!!
//-(void)setFrame:(CGRect)frame {
//    [super setFrame: frame];
//    [contentView setFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
//}


#pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.disableZoom ? nil : contentView;
}


// begin -> end

// scrollView.frame :   not change
// scrollView.bounds :  size not change , but , origin change

// view.frame :         size change (old * scale) , but , origin not change
// view.bounds :        not change

// view.center :        change (old * scale)

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2)
{
    
#ifdef DEBUG
    
    __DLOG(@"%@", NSStringFromCGRect(scrollView.frame));
    __DLOG(@"%@", NSStringFromCGRect(scrollView.bounds));
    
    __DLOG(@"%@", NSStringFromCGRect(view.frame));
    __DLOG(@"%@", NSStringFromCGRect(view.bounds));
    
    __DLOG(@"view center : %f,%f", view.center.x, view.center.y);
    
#endif
    
    if (!originalCenterX) originalCenterX = view.center.x;
    if (!originalCenterY) originalCenterY = view.center.y;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
#ifdef DEBUG
    
    __DLOG(@"***************** %f *****************", scale);
    __DLOG(@"%@", NSStringFromCGRect(scrollView.frame));
    __DLOG(@"%@", NSStringFromCGRect(scrollView.bounds));
    
    __DLOG(@"%@", NSStringFromCGRect(view.frame));
    __DLOG(@"%@", NSStringFromCGRect(view.bounds));
    
    // view.center.x = view's origin center.x * scale
    // view.center.y = view's origin center.y * scale
    
    __DLOG(@"view center : %f,%f", view.center.x, view.center.y);

#endif
    
    latestCenterX = view.center.x;
    latestCenterY = view.center.y;
}

@end
