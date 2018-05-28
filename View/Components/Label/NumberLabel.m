#import "NumberLabel.h"

#define kTimerInterval 0.05f
#define animationDuration (0.5)

@implementation NumberLabel
{
    NSTimer* timer;
    
    float currentNumber;
    float increment;
    BOOL isBeing;
}


@synthesize format;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        
        format = @"%.2f";
        timer = [NSTimer timerWithTimeInterval: kTimerInterval target:self selector:@selector(increaseText) userInfo:nil repeats:YES];
        isBeing = NO;
    }
    return self;
}


-(void) startTimer {
    [self setNeedsDisplay];     // call the StrokeLabel drawRect method
    
    if (! isBeing) {
        [[NSRunLoop mainRunLoop] addTimer: timer forMode:NSRunLoopCommonModes];
        isBeing = YES;
    } else {
        [timer setFireDate: [NSDate date]];
    }

}

-(void) increaseText {
    currentNumber += increment;
    
    //check if the timer needs to be disabled
    if ((increment >= 0 && currentNumber >= _number) || (increment < 0 && currentNumber <= _number)) {
        currentNumber = _number;
        [timer setFireDate: [NSDate distantFuture]];
    }
    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.1;
//    animation.removedOnCompletion = YES;
//    animation.fillMode = kCAFillModeRemoved;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.layer removeAnimationForKey:@"changeTextTransition"];
//    [self.layer addAnimation:animation forKey:@"changeTextTransition"];
    
    [super setText: [NSString stringWithFormat: format , currentNumber]] ;
}


#pragma mark - Overrides

- (void)setNumber:(float)number
{
    _number = number;
    increment = (_number - currentNumber) * kTimerInterval / animationDuration;
    [self startTimer];
}

- (void)dealloc {
    [timer invalidate];
}

@end



