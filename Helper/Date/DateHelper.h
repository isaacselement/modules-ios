#import <Foundation/Foundation.h>

#define PATTERN_CLOCK @"HH:mm:ss"
#define PATTERN_DATE_TIME @"yyyy-MM-dd HH:mm:ss"
#define PATTERN_DATE_TIME_ZONE @"yyyy-MM-dd HH:mm:ss Z"

@interface DateHelper : NSObject

+ (NSString *)stringFromDate:(NSDate *)date pattern:(NSString*)pattern ;

+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern ;

+ (NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern ;

+ (void) setDefaultDatePattern: (NSString*)pattern ;
+ (NSDateFormatter*) getDefaultDateFormater ;
+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern ;

+ (NSDate*) date: (NSDate*)date addDay: (int)day ;
+ (NSDate*) date: (NSDate*)date addMonth: (int)month ;

+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date ;

+ (NSDate*) truncateToday: (NSDate*)date;

+ (NSInteger) getAgeFromBirthday: (NSDate*)birthday;



+(NSArray*) subtractHourAndMinute: (NSString*)fromTime to:(NSString*)toTime;



#pragma mark -

/** Check if double click  */
+(BOOL) isDoubleClick: (NSTimeInterval)interval;


@end

