#import <UIKit/UIKit.h>

@interface NormalLabel : UILabel

// when after adjustWidthToFontText , invoke it
@property (copy) void (^labelDidSetTextBlock)(NormalLabel* label, NSString* newText, NSString* oldText);

@end
