#import "NormalLabel.h"

#import "_Frame.h"

@implementation NormalLabel

// http://stackoverflow.com/a/4359845/1749293
// http://stackoverflow.com/a/14306893/1749293
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultVariable];
    }
    return self;
}

-(void) setDefaultVariable
{
    self.font = [UIFont fontWithName:@"Arial" size:[FrameTranslater convertFontSize: 25]];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.highlightedTextColor = [UIColor blackColor];
    //		self.textAlignment = NSTextAlignmentCenter;
    
    [self setSizeHeight: [FrameTranslater convertCanvasHeight: 30]]; // default
}


// http://stackoverflow.com/a/6267259/1749293
-(void) setText:(NSString *)text {
    NSString* oldText = self.text;
    [super setText: text];
    if (self.labelDidSetTextBlock) self.labelDidSetTextBlock(self, text, oldText);
}


@end
