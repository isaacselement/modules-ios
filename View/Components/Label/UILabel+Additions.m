#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (id)initWithText:(NSString*)text
{
    self = [super init];
    if (self) {
        self.font = [UIFont fontWithName:@"Arial" size:20];
        self.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.highlightedTextColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.text = text;
        if (text)[self adjustWidthToFontText];
    }
    return self;
}

// http://doing-it-wrong.mikeweller.com/2012/07/youre-doing-it-wrong-2-sizing-labels.html
// https://github.com/MikeWeller/ButtonInsetsPlayground   comment line 159 [self sizeButtonToFit] to see .
-(void) adjustWidthToFontText {
    CGRect frame = self.frame;
    frame.size.width = [self getTextWidth];
    self.frame = frame; // when you change the frame , the center will be changed. when you change the center, the frame's origin will be changed
}

-(void) adjustFontSizeToWidth
{
    [self adjustFontSizeToWidthWithGap: 0];
}

-(void) adjustFontSizeToWidthWithGap: (CGFloat)gap
{
    while ( [self getTextWidth] > (self.frame.size.width - gap)) {
        [self setTextFontSize:self.font.pointSize - 8];
        // be aware of infinite loop
        if (self.font.pointSize < 8) {
            break;
        }
    }
}

-(CGSize) getTextSize
{
    return [self.text sizeWithAttributes: @{NSFontAttributeName: self.font}];
}

-(CGFloat) getTextWidth
{
    return [self getTextSize].width;
}

-(CGFloat) getTextHeight
{
    return [self getTextSize].height;
}

-(void) setTextFontSize:(CGFloat)pointSize
{
    self.font = [self.font fontWithSize: pointSize];
}

@end
