#import <UIKit/UIKit.h>

@interface KeyBoardHelper : NSObject



@property (readonly) BOOL isKeyboardShowing;


@property (assign) CGFloat keyboardDistanceFromTextView;
@property (assign) CGFloat keyboardDistanceFromTextField;



+(instancetype) sharedInstance;



@end
