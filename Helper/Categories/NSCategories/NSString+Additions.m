#import "NSString+Additions.h"

@implementation NSString (Additions)

// compatibility of NSNumber & NSString
- (NSString *)stringValue {
    return self;
}

-(BOOL) isEqualToStringIgnoreCase: (NSString*)string {
    return [[self lowercaseString] isEqualToString: [string lowercaseString]];
}

#pragma - Class Methods

+ (NSString *)random:(int)length {
    NSString *printableString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *result = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
    for (int i = 0; i < length; i++) {
//        unsigned index = rand() % [printableString length];
        unsigned index = arc4random() % [printableString length];
        NSString *oneStr = [printableString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:oneStr];
    }
    return result;
}

@end


@implementation NSString (Graphic)

- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize max = CGSizeMake(width, MAXFLOAT);
    CGRect rect = [self boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.height;
}

- (CGFloat)getWidthWithFont:(UIFont *)font height:(CGFloat)height {
    CGSize max = CGSizeMake(MAXFLOAT, height);
    CGRect rect = [self boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.width;
}

- (int)cn_linesWithFont:(UIFont *)font width:(CGFloat)width {
    return [self getHeightWithFont:font width:width] / [NSString oneChineseHeight:font];
}

- (int)en_linesWithFont:(UIFont *)font width:(CGFloat)width {
    return [self getHeightWithFont:font width:width] / [NSString oneEnglishHeight:font];
}

#pragma - Class Methods

+ (CGFloat)oneChineseHeight:(UIFont *)font {
    return [@"汉" getHeightWithFont:font width:MAXFLOAT];
}

+ (CGFloat)oneChineseWidth:(UIFont *)font {
    return [@"汉" getWidthWithFont:font height:MAXFLOAT];
}

+ (CGFloat)oneEnglishHeight:(UIFont *)font {
    return [@"A" getHeightWithFont:font width:MAXFLOAT];
}

+ (CGFloat)oneEnglishWidth:(UIFont *)font {
    return [@"A" getWidthWithFont:font height:MAXFLOAT];
}

@end

