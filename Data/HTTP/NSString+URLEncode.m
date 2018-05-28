#import "NSString+URLEncode.h"


@implementation NSString (URLEncode)

// http://stackoverflow.com/a/8088484/1749293
// http://stackoverflow.com/a/5507550/1749293
// http://stackoverflow.com/a/15651591/1749293
// http://stackoverflow.com/a/15651617/1749293
// http://en.wikipedia.org/wiki/Percent-encoding


-(NSString*) URLEncode
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)self, nil, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

-(NSString*) URLDecode
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
}

@end
