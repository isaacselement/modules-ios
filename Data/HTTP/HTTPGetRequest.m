#import "HTTPGetRequest.h"

@implementation HTTPGetRequest

#pragma mark - Overwrite Methods
-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {
    [request setHTTPMethod:@"GET"];
}

-(NSURL*) getURL: (NSString*)urlString parameters:(NSDictionary*)parameters {
    NSMutableString* urlParameterString = [NSMutableString stringWithString: urlString];
    
    for(NSString* key in parameters) {
        NSString* value = [parameters objectForKey: key];
        
        if ([urlParameterString rangeOfString: @"?"].location != NSNotFound) {
            [urlParameterString appendFormat: @"&%@=%@", key, value];
        } else {
            [urlParameterString appendFormat: @"?%@=%@", key, value];
        }
    }
    
    return [super getURL: urlParameterString parameters:parameters];
}

@end
