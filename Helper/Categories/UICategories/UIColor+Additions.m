#import "UIColor+Additions.h"

@implementation UIColor (Additions)

- (instancetype)alpha:(CGFloat)alpha {
    return [self colorWithAlphaComponent: alpha];
}

@end
