#import "StringHelper.h"


#define SPACE_META_CONNECTOR      @"|"
#define SPACE_TAIL_CONNECTOR      @","
#define SPACE_ATOM_CONNECTOR      @"."

#define SPACE_STRING    @" "


@implementation StringHelper

+(int) numberOfUpperCaseCharacter: (NSString*)string {
    int count = 0;
    for (int i = 0; i < [string length]; i++) {
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:i]];
        if (isUppercase == YES) count++;
    }
    return count;
}

+(BOOL) isNumeric:(NSString*)string
{
    NSScanner *scanner = [NSScanner scannerWithString: string];
    BOOL isNumeric = [scanner scanDouble:NULL] && [scanner isAtEnd];
    return isNumeric;
}

+(NSString*) appendStrings: (NSString*)string, ...
{
    if (!string) return nil;
    NSString* result = string;
    
    va_list list ;
    va_start(list, string);
    NSString* arg = nil;
    while ((arg = va_arg(list, NSString*))) {
        result = [result stringByAppendingString: arg];
    }
    
    return result;
}

#pragma mark -

+(BOOL) isContainsEnglish:(NSString *)string {
    NSRegularExpression *englishRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [englishRegular numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if (count > 0) {
        return YES;
    }
    return NO;
}

+(int) getChineseCount: (NSString*)string
{
    __block int count = 0;
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        count++;
        return NO;
    }];
    return count;
}

+(BOOL) isContainsChinese:(NSString*)string
{
    __block BOOL result = NO;
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        result = YES;
        return YES;
    }];
    return result;
}

+(NSMutableString*) getChinese:(NSString*)string
{
    NSMutableString* chineseString = [[NSMutableString alloc] init];
    [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *chinese) {
        [chineseString appendString: chinese];
        return NO;
    }];
    return chineseString;
}



+(NSMutableString*) insertSpace: (NSString*)string atIndex:(NSUInteger)index spaceCount:(NSUInteger)spaceCount
{
    NSMutableString* newString = [[NSMutableString alloc] initWithString: string];
    NSMutableString* spaceString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0 ; i < spaceCount; i++) {
        [spaceString appendString: SPACE_STRING];
    }
    [newString insertString: spaceString atIndex:index];
    return newString;
}


#pragma mark -

// space = 1, means every chinese will separate by 1 space
// space = 1|23, means every chinese will separate by 1 space, and the 2nd chinese (tail) will have 3 more space additional.
// space = 0|03, means that every chinese have 0 space , and the 1st (head) will have 3 space . (in this case , prefix will be 3 space)
// space = 0|0.3,4.5, ...., the 4st (tail) will have 5 space.
+(NSMutableString*) separate:(NSString*)string spaceMeta:(NSString*)spaceMeta
{
    NSArray* array = [spaceMeta componentsSeparatedByString: SPACE_META_CONNECTOR];
    int everyspace = [[array firstObject] intValue];
    NSArray* tails = array.count == 2 ? [[array lastObject] componentsSeparatedByString:SPACE_TAIL_CONNECTOR] : nil;
    
    NSMutableString* separateString = [[NSMutableString alloc] init];
    BOOL isChinese = [StringHelper isContainsChinese: string];
    if (isChinese) {                                                                // Here , has to be optimized
        [StringHelper iterateChineseWord: string handler:^BOOL(int length, int index, NSString *word) {
            [StringHelper appendSpace: separateString space:everyspace tails:tails length:length index:index word:word];
            return NO;
        }];
    } else {
        [StringHelper iterateEnglishWord: string handler:^BOOL(int length, int index, NSString *word) {
            [StringHelper appendSpace: separateString space:everyspace tails:tails length:length index:index word:word];
            return NO;
        }];
    }
    return separateString;
}

#pragma mark -

// util method
+(void) appendSpace: (NSMutableString*)separateString space:(int)space tails:(NSArray*)tails length:(int)length index:(int)index word:(NSString*)word
{
    // tails
    if (index == 0) {                   // the first one
        int num = [StringHelper getSpaceNumber: tails index: index];
        for (int i = 0; i < num; i++) {
            [separateString appendString: SPACE_STRING];
        }
    }
    
    
    [separateString appendString: word];
    
    
    // every space between word
    if (index != length-1) {            // not the last one
        for (int i = 0; i < space; i++) {
            [separateString appendString: SPACE_STRING];
        }
    }
    
    // tails
    int num = [StringHelper getSpaceNumber: tails index: index+1];
    for (int i = 0; i < num; i++) {
        [separateString appendString: SPACE_STRING];
    }
}

+(int) getSpaceNumber: (NSArray*)tails index:(int)index
{
    NSUInteger length = tails.count;
    for (NSUInteger i = 0; i < length; i++) {
        NSString* string = tails[i];
        NSArray* atoms = [string componentsSeparatedByString:SPACE_ATOM_CONNECTOR];
        
        NSString* seqStr = [atoms firstObject];
        NSString* numStr = [atoms lastObject];
        
        int seq = [seqStr intValue];
        int num = [numStr intValue];
        
        if (seq == index) return num;
    }
    
    return 0;
}


+(void) iterateChineseWord:(NSString*)string handler:(BOOL(^)(int length, int index, NSString* chinese))handler
{
    int length = (int)string.length;
    for (int i = 0 ; i < length; i++) {
        unichar ch = [string characterAtIndex:i];
        
        // chinese
        if (0x4e00 < ch  && ch < 0x9fff) {
            NSString * chinessCharacter = [string substringWithRange:NSMakeRange(i, 1)];
            if(handler(length, i, chinessCharacter)) return;
        }
    }
}

+(void) iterateEnglishWord: (NSString*)string handler:(BOOL(^)(int length, int index, NSString* word))handler
{
    NSArray* array = [string componentsSeparatedByString: SPACE_STRING];
    int length = (int)array.count;
    for (int i = 0; i < array.count; i++) {
        NSString* word = array[i];
        if(handler(length, i, word)) return;
    }
}



#pragma mark - 

+(NSString*) stringBetweenString:(NSString*)string start:(NSString*)start end:(NSString*)end
{
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return nil;
}

+(NSMutableArray*)stringsBetweenString:(NSString*)string start:(NSString*)start end:(NSString*)end
{
    
    NSMutableArray* strings = [NSMutableArray arrayWithCapacity:0];
    NSRange startRange = [string rangeOfString:start];
    for( ;; ) {
        if (startRange.location != NSNotFound) {
            NSRange targetRange;
            
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = [string length] - targetRange.location;
            
            NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
            
            if (endRange.location != NSNotFound) {
                
                targetRange.length = endRange.location - targetRange.location;
                [strings addObject:[string substringWithRange:targetRange]];
                
                NSRange restOfString;
                
                restOfString.location = endRange.location + endRange.length;
                restOfString.length = [string length] - restOfString.location;
                
                startRange = [string rangeOfString:start options:0 range:restOfString];
                
            } else {
                break;
            }
        } else {
            break;
        }
    }
    return strings;
}


// http://stackoverflow.com/a/5691341
+(void) iterateString: (NSString*)string handler:(BOOL(^)(int index, unichar character))handler
{
    NSUInteger len = [string length];
    unichar buffer[len];
    
    // this way (preferred):
    [string getCharacters: buffer];
    
    for(int i = 0; i < len; ++i) {
        unichar current = buffer[i];
        //do something with current...
        if (handler) {
            if (handler(i, current)) {
                break;
            }
        }
    }
}

@end
