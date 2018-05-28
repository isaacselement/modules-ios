#import <UIKit/UIKit.h>

@interface NormalButton : UIButton

@property (copy) void(^didTouchUpInsideAction)(NormalButton* sender);

@end
