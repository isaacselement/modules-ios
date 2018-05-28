#import "NSDate+Additions.h"

@implementation NSDate (Additions)

// e.g. 2010-10-30 10:14:13 -> 2010-10-30 00:00:00
- (NSDate*)cutTime {
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self]];
}

@end


@implementation NSDate (String)

- (NSString*)stringWithPattern:(NSString *)pattern {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: pattern];
    return [df stringFromDate: self];
}

+ (NSDate *)dateFromString:(NSString *)string pattern:(NSString*)pattern {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat: pattern];
    return [df dateFromString:string];
}

@end


@implementation NSDate (Compare)

// Conception here, time is hour & minute & second, date is year & month & day .

// compare with time

-(BOOL) GT:(NSDate*)date {
    return [self compare: date] == NSOrderedDescending;
}

-(BOOL) LT:(NSDate*)date {
    return [self compare: date] == NSOrderedAscending;
}

-(BOOL) EQ:(NSDate*)date {
    return [self compare: date] == NSOrderedSame;
}

-(BOOL) GTEQ:(NSDate*)date {
    return [self GT: date] || [self EQ:date];
}

-(BOOL) LTEQ:(NSDate*)date {
    return [self LT: date] || [self EQ:date];
}

// compare without time

-(BOOL) GTDate:(NSDate*)date {
    return [[self cutTime] GT: [date cutTime]];
}

-(BOOL) LTDate:(NSDate*)date {
    return [[self cutTime] LT: [date cutTime]];
}

-(BOOL) EQDate:(NSDate*)date {
    return [[self cutTime] EQ: [date cutTime]];
}

-(BOOL) GTEQDate:(NSDate*)date {
    return [self GTDate: date] || [self EQDate:date];
}

-(BOOL) LTEQDate:(NSDate*)date {
    return [self LTDate: date] || [self EQDate:date];
}

@end
