#import <UIKit/UIKit.h>

@interface NSString (Additions)

- (NSString *)stringValue;

-(BOOL) isEqualToStringIgnoreCase: (NSString*)string;

#pragma - Class Methods

+ (NSString *)random:(int)length;

@end


@interface NSString (Graphic)

- (CGFloat)getHeightWithFont:(UIFont *)font width:(CGFloat)width ;

- (CGFloat)getWidthWithFont:(UIFont *)font height:(CGFloat)height ;

- (int)cn_linesWithFont:(UIFont *)font width:(CGFloat)width;

- (int)en_linesWithFont:(UIFont *)font width:(CGFloat)width;

#pragma - Class Methods

+ (CGFloat)oneChineseHeight:(UIFont *)font ;

+ (CGFloat)oneChineseWidth:(UIFont *)font ;

+ (CGFloat)oneEnglishHeight:(UIFont *)font ;

+ (CGFloat)oneEnglishWidth:(UIFont *)font ;

@end
