#import <Foundation/Foundation.h>

#define DATE_PATTERN_DOT @"yyyy.MM.dd"
#define DATE_PATTERN_DASH @"yyyy-MM-dd"

@interface NSDate (Additions)

- (NSDate*)cutTime ;

@end


@interface NSDate (String)

- (NSString*)stringWithPattern:(NSString *)pattern;

+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern;

@end


@interface NSDate (Compare)

// GT for Greate Than
// LT for Less Than
// EQ for Equal

/**
 *  compare with time
 */
-(BOOL) GT:(NSDate*)date;
-(BOOL) LT:(NSDate*)date;
-(BOOL) EQ:(NSDate*)date;
-(BOOL) GTEQ:(NSDate*)date;
-(BOOL) LTEQ:(NSDate*)date;

/**
 *  compare without time
 */
-(BOOL) GTDate:(NSDate*)date;
-(BOOL) LTDate:(NSDate*)date;
-(BOOL) EQDate:(NSDate*)date;
-(BOOL) GTEQDate:(NSDate*)date;
-(BOOL) LTEQDate:(NSDate*)date;

@end
