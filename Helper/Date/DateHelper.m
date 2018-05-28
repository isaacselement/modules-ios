#import "DateHelper.h"

@implementation DateHelper

static NSString* defautPattern = PATTERN_DATE_TIME;
static NSDateFormatter* defaultFormatter = nil;

#pragma mark - String To Date / Date To String / Format Transform

+ (NSString *)stringFromDate:(NSDate *)date pattern:(NSString*)pattern {
    NSDateFormatter* df = [self getLocaleDateFormater: pattern];
    NSString *string = [df stringFromDate:date];
    return string;
}


+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern {
    NSDateFormatter* df = [self getLocaleDateFormater: pattern];
    NSDate *date= [df dateFromString:string];
    return date;
    
}

+ (NSString*)stringFromString:(NSString *)sourceString fromPattern:(NSString*)fromPattern toPattern:(NSString*)toPattern {
    NSDateFormatter* df = [self getLocaleDateFormater: fromPattern];
    NSDate *date = [df dateFromString:sourceString];
    [df setDateFormat: toPattern];
    NSString *string = [df stringFromDate:date];
    return string;
}

+ (void) setDefaultDatePattern: (NSString*)pattern {
    if (pattern) {
        defautPattern = pattern;
        defaultFormatter = [DateHelper getLocaleDateFormater: defautPattern];
    }
}

+ (NSDateFormatter*) getDefaultDateFormater {
    if (! defaultFormatter) {
        defaultFormatter = [DateHelper getLocaleDateFormater: defautPattern];
    }
    return defaultFormatter;
}

+ (NSDateFormatter*) getLocaleDateFormater: (NSString*)pattern {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:pattern == nil ? PATTERN_DATE_TIME_ZONE : pattern];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT: +8 * 60 * 60];
    [df setTimeZone: timeZone];
    
    NSLocale* locale = [NSLocale localeWithLocaleIdentifier: @"en_US"];
    [df setLocale: locale];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: timeZone];
    [calendar setLocale: locale];
    [df setCalendar: calendar];

    return df;
}


+ (NSDate*) date: (NSDate*)date addMonth: (int)month {
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth: month];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*) date: (NSDate*)date addDay: (int)day {
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:day];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


+ (NSDate*) translateDateToCurrentLocale: (NSDate*)date {           //TODO: Have something wrong . Failed
    NSDateFormatter *dateFormatter = [self getLocaleDateFormater: nil];
    NSString* dateString = [dateFormatter stringFromDate: date];
    NSDate* newDate = [dateFormatter dateFromString: dateString];
    return newDate;
}

// e.g. 2010-10-30 10:14:13 -> 2013-11-20 10:14:13  (2013-11-20 is today)
+ (NSDate*) truncateToday: (NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger preservedTimeComponents = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate* truncateDateTime = [calendar dateFromComponents:[calendar components:preservedTimeComponents fromDate:date]];       // xxx 10:14:13
    
    NSDate *nowDate = [NSDate date];
    NSCalendarUnit preservedDayComponents = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDate* truncateDateDay = [calendar dateFromComponents:[calendar components:preservedDayComponents fromDate:nowDate]];      // 2013-11-20 x:x:x
    
    NSDate *newDate = [calendar dateByAddingComponents:[calendar components:preservedTimeComponents fromDate:truncateDateTime] toDate:truncateDateDay options:0];
    return newDate;
}


+ (NSInteger) getAgeFromBirthday: (NSDate*)birthday
{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    return age;
}


// 08:00 -> 17:30   or  17:30 -> 08:00 (tomorrow)
+(NSArray*) subtractHourAndMinute: (NSString*)fromTime to:(NSString*)toTime
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSDate *dateFrom =[dateFormatter dateFromString: fromTime];
    NSDate *dateTo = [dateFormatter dateFromString: toTime];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                    components:kCFCalendarUnitHour | kCFCalendarUnitMinute
                                    fromDate:dateFrom
                                    toDate:dateTo
                                    options:0];
    NSInteger hour = [components hour];
    if (hour < 0) {
        hour = 24 + hour;
    }
    NSInteger minute = [components minute];
    if (minute < 0) {
        minute = 60 + minute;
    }
    return @[@(hour), @(minute)];
}




#pragma mark - 

/** Check if double click  */
+(BOOL) isDoubleClick: (NSTimeInterval)interval
{
    static NSDate* perviousDate = nil;
    Boolean doubleClick = NO;
    NSDate* now = [NSDate date];
    if (perviousDate) {
        doubleClick = [now timeIntervalSinceDate: perviousDate] < interval;
    }
    perviousDate = now;
    return doubleClick;
}

@end

