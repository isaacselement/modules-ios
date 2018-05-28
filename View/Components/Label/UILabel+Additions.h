#import <UIKit/UIKit.h>

@interface UILabel (Additions)

- (id)initWithText:(NSString*)text;


- (void)adjustWidthToFontText ;

- (void)adjustFontSizeToWidth ;

-(void) adjustFontSizeToWidthWithGap: (CGFloat)gap;


-(CGSize) getTextSize;

-(CGFloat) getTextWidth;

-(CGFloat) getTextHeight;

-(void) setTextFontSize:(CGFloat)pointSize;

@end
