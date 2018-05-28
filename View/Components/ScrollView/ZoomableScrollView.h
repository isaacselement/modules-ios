#import <UIKit/UIKit.h>

@interface ZoomableScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong) UIView* contentView;     // add the zoomalbe subview
@property (assign) BOOL disableZoom;

-(void) setViewFrame: (CGRect)frame;

-(NSArray*) contentViewSubviews;
-(void) addSubviewToContentView: (UIView*)view;


#pragma mark - Subclass Override Methods
-(void) initializeVariables;

@end
